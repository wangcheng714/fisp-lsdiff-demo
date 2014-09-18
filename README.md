fisp-lsdiff-demo
================

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

