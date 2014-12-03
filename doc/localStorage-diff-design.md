
# 模块设计

模块设计包括以下几部分：前端框架、后端资源更新服务、编译支持以及其他包括调试、统计等部分。

## 前端(组件化+增量更新)框架

前端框架负责资源的组件化以及资源diff、更新、存贮、执行等功能。

### 资源加载：load([pkg,pkg], fn)

代替传统script、style加载并执行静态资源。load进行资源diff、更新、存贮、执行工作。

* 参数格式

```javascript
pkg : {
	id : "",
	hash : ""
}
```

* diff获取改变的文件列表

		详细diff流程参考上面的更新流程图

* 更新改变的内容

		资源下载需要支持资源包并行和串行两种加载方式

* 存贮完整静态资源

**具体存贮格式开发时在确认**

* 数据统计

		前端需要统计静态资源的加载情况、以及缓存的使用情况，详细方案参考统计部分

### 组件化：require、require.ansyc

前端框架是在mod.js基础之上开发，组件化方案同mod.js。提供require、require.async。

**require.async需要支持资源的增量更新功能**

### 其他

* setResourceList ： 设置静态资源的ResourceMap列表

		有了ResourceMap列表就可以不用发送list请求，直接进行资源版本diff，减少一个请求

* setLSKey ： 设置localStorage的存贮key，防止产品线key冲突


## 后端服务

后端服务分为两块：后端增量更新请求服务、后端插件运行时服务。

### 后端插件运行时支持


#### 异步资源加载方案

异步加载通过将resourceMap输出到页面完成支持。

```javascript
//异步输出resourceMap的格式
F.config({
	ls_resourceMap : {
		res : {
			"home:static/css/bootstrap.js" : {
				uri : "/static/home/css/bootstrap_871defe.js",
				type : "js",
				pkg : "home:p0",
				hash : "871defe",
				key : "home_static_css_bootstrap_js",
				deps : [
					"home:static/css/bootstrap_1.js",
					"home:static/css/bootstrap_2.js",
					"home:static/css/bootstrap_3.js"
				]
			}
		},
		pkg : {
			"home:p0" : {
				uri : "/static/home/pkg/aio_855177f.js",
				hash : "871defe",
				type : "js",
				key: "home_static_pkg_aio_js"
			}
		}
	}
});
```

### 后端更新请求服务


请求统一采用POST格式

#### list请求

返回打包文件的详细资源列表

* 请求格式

		pkg_id1..2 包的id名称
		fis_diff?type=list
			get参数 : type=list
			post参数 : pids=pkg_id1,pkg_id2

* 返回格式

```javascript
//hash1..2..3 为小文件的md5值
{
	pkg_id1 : {
		"list" : ["hash1","hash2","hash3"],
		"hash" : "包的hash值",
		"type" : "js"
	}，
	pkg_id2 : {
		"list" : ["hash1","hash2","hash3"],
		"hash" : "包的hash值",
		"type" : "css"
	}
}
```

#### data请求

返回请求的资源内容

* 请求格式

		//hash1..2..3 为小文件的md5值
		pkg_id1= 如果为空则返回全部内容
		fis_diff?type=data
			get参数 : type=data
			post参数 : pkg_id1=hash1,hash2,hash3&pkg_id2=hash4,hash5,hash6

* 返回格式

```javascript
//格式1
{
	pkg_id1 : {
		"type" : "js",
		"hash" : "包的hash值",
		"data" : [
			{
				"hash" : "hash1",
				"content" : 小文件内容
			},
			{
				"hash" : "hash2",
				"content" : 小文件内容
			}
		]
	},
	pkg_id2 : {
		"type" : "css",
		"hash" : "包的hash值",
		"data" : [
			{
				"hash" : "hash1",
				"content" : 小文件内容
			},
			{
				"hash" : "hash1",
				"content" : 小文件内容
			}
		]
	}
}
//格式2
{
	pkg_id1 : {
		"hash1" : 小文件内容,
		"hash2" : xxx
	},
	pkg_id2 : {
		"hash1" : xxx,
		"hash2" : xxx
	}
}
```

**为什么要采用格式1**

		当用户第一次访问时没有list列表，因此data需要保存完整的顺序.
		同样也没有type和hash值因此都需要传递过去。


### 调试模式

* 调试模式对于异步require.async的支持

## 编译支持

* 编译分析资源使用情况，自动生成load调用 (Quickling插件支持)

		需要支持JS、Css选择

### fis-postpackager-diff

* 编译产出list和data Json文件 (编译插件支持)
*  扩展map.json文件，增加hash和id

一个模块产出list和data两个文件。

**list文件**

		文件名 ： common[模块名].lslist.json(记录整个模块资源列表以及版本号)
		资源Key替换规则 : ( . : / ) 替换成 (_) ; Key必须以模块名开头
		格式 ：

```javascript
{
	common_static_pkg_aio_css : {
		"hash" : md5版本号,
		"type" : 2,
		"list" : [
			"hash1",
			"hash2",
			"hash3"
		]
	},
	common_static_pkg_aio_js : {
		"hash" : md5版本号,
		"type" : 1,
		"list" : [
			"hash1",
			"hash2",
			"hash3"
		]
	},
	//单文件情况
	common_static_photo_js : {
		"hash" : md5版本号,
		"type" : 1,
		"list" : [
			md5版本号
		]
	}
}
```
		
**data文件**

	文件名 : common[模块名].lsdata.json(记录整个模块资源版本号和内容)
	文件格式 : 
	
```javascript
{
	common_static_pkg_aio_css : {
		"hash1" : "文件内容",
		"hash2" : "文件内容"
	},
	common_static_pkg_aio_js : {
		"hash1" : "文件内容",
		"hash2" : "文件内容"
	},
	//单文件情况
	common_static_photo_js : {
		"hash1" : "文件内容"
	}
}
```

* map.json文件扩展
		
```javascript
//增加hash和key
{
	"res": {
		"home:static/index/index.css": {
			"uri": "/static/home/index/index_3cb6829.css",
			"type": "css"，
			“hash” : "3cb6829",
			"key" : "home_static_index_index_css"
		}
	},
	"pkg": {
		"home:p0": {
				"uri": "/static/home/pkg/aio_855177f.css",
				"type": "css",
				"has": [
					"home:static/lib/css/bootstrap.css"
				],
				"hash" : "855177f",
				"key" : "home_static_pkg_aio_css"
		}
	}
}
```

**为什么不使用map.json**

	1. map.json数据不能够完全满足需求
	2. 当没有md5参数编译map.json没有产出hash
	
	总体需要对现有map.json结构做较大变动，甚至影响原有功能，所以单独生成list和json文件
		
**为什么采用json不使用php**

	考虑到后续可能会扩展到各种后端，比如Node等Json数据格式具有更好的移植性
	
**为什么要合并到一个文件**

	1. 单独按一个包一个文件零散文件比较多，会导致大量读写
	2. 合并到一起每次只用读一次文件 提高效率
	
	问题 ： 文件太大比较消耗内存，后续确认

* ResourceMap通过setResourceList设置到页面 (编译插件支持)


