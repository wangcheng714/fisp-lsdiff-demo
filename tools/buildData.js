
var widgetName = "big",
    widgetDir = __dirname + "/../home/widget/",
    bigWidget = widgetDir + widgetName;

var fsext = require("fs-extra"),
    fs = require("fs");

function copyWidget(name){
    var newWidget = widgetDir + name,
        oldjs = newWidget + "/big.js",
        oldCss = newWidget + "/big.css",
        js = newWidget + "/" + name + ".js",
        css = newWidget + "/" + name + ".css",
        oldTpl = newWidget + "/big.tpl",
        tpl = newWidget + "/" + name + ".tpl";

    fsext.copy(bigWidget, newWidget, function(){
        fsext.move(oldjs, js, function(){
            fsext.move(oldCss, css, function(){
                var content = fs.readFileSync(css , {
                    encoding : "utf-8"
                })
                content = "/*this is a test " + Math.random() + "*/\n" + content;
                fs.writeFileSync(css, content);
                fsext.move(oldTpl, tpl, function(){
                    var content = fs.readFileSync(tpl, {
                        encoding : "utf8"
                    });
                    content = content.replace("big/big.js", name + "/" + name + ".js");
                    content = content.replace("big/big.css", name + "/" + name + ".css");
                    fs.writeFileSync(tpl, content);
                    var files = fs.readdirSync(newWidget);
                    for(var i=0; i<files.length; i++){
                        if(files[i].indexOf("sub") >= 0){
                            var subFile = newWidget + "/" + files[i];
                            var subContent = fs.readFileSync(subFile, {
                                encoding : "utf8"
                            });
                            subContent += 'var test = "' + Math.random() + '";';
                            fs.writeFileSync(subFile, subContent)
                        }
                    }
                })
            });
        });
    });
}

for(var index=1; index<=15; index++){
    copyWidget("big" + index);
}