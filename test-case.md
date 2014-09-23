
## 测试case整理

* 按照用户文档正常操作验证
* fisp release 不添加-m 正常运行
* fisp release 不添加-p list和data请求零散文件正常运行
* ?debug=pkg调试模式 

    通过script、style标签单独请求
    
* 针对require.async异步调用的场景能正常运行
* localStorage禁用、存满情况测试确认
* 不打包，单文件有超过500个确认localStorage是否会报错
* js和css大小超过2M确认是否有问题
