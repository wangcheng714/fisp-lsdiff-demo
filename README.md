fisp-lsdiff-demo
================

## Demo Getting Start

### 下载Demo

```sh
$ git clone https://github.com/wangcheng714/fisp-lsdiff-demo.git
$ cd fisp-lsdiff-demo
$ git submodule init
$ git submodule update
```

关于[git submodule](http://git-scm.com/docs/git-submodule)可以参考这里。

### 运行Demo

```sh
$ fisp release -cmpr common
$ fisp release -cmpr photo
```

### 查看效果

* 浏览页面http://127.0.0.1:8080/查看效果

        1. 查看network首次请求和第二次请求，发送的请求数和请求内容
        2. 查看localStorage存贮的内容
        3. 清空localStorage重新请求页面查看请求

## 接入指导

### [1]接入fis-postpackager-lsdiff-map插件

* 安装插件

```sh
$ npm install -g fis-postpackager-lsdiff-map
```

* 使用插件

fis-config.js中增加如下配置

	fis.config.merge({
		modules : {
			postpackager : "lsdiff-map"
		}
	});
	
* 确认效果

```sh
$ fisp release -d output
```

会在output/config目录中生成module.lslist.json和module.lsdata.json文件。

### [2]升级新版Smarty插件

从[这里](https://github.com/wangcheng714/fis-plus-lsidff-plugin)下载支持增量更新的Smarty插件，替换本地的plugin。

### [3]升级新版组件加载类库modjs

从[这里](https://github.com/2betop/mod/mod-ls.js)下载新版支持增量更新的组件类库，替换本地mod.js。

### [4]配置增量更新请求

* 首先你需要下载提供增量更新服务的后端文件ls-diff.php

从[这里](https://github.com/wangcheng714/fis-localstorage-php-backend)下载ls-diff.php文件，部署到模块中(建议common模块)。

配置fis-config.js，讲ls-diff.php发布到config目录.具体配置参考下面：

	fis.config.get("roadmap.path").unshift({
		reg : /lsdiff\-backend\/ls\-diff\.php/i,
		release : '/config/ls-diff.php'
	});

* 其次你需要配置服务器将前端更新请求转发到该文件。

对于Fis本地调试：server.conf增加如下配置

	rewrite \/fis-diff /config/ls-diff.php
		
对于线上服务：

	如果你是apache服务器
	
### [5]Finish

至此我们已经完成了接入增量更新方案的所有操作。编译看看效果吧。

```sh
$ fisp release -cmpr common
$ fisp release -cmpr home
```

	