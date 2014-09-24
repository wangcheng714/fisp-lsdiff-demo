{%extends file="common/page/layout.tpl"%}
{%block name="block_head_static"%}
    <!--[if lt IE 9]>
        <script src="/lib/js/html5.js"></script>
    <![endif]-->
    {%* 模板中加载静态资源 *%}
    {%require name="home:static/lib/css/bootstrap.css"%}
    {%require name="home:static/lib/css/bootstrap-responsive.css"%}
    {%require name="home:static/lib/js/jquery-1.10.1.js"%}
{%/block%}
{%block name="content"%}
    <div id="wrapper">
        <div id="sidebar">
            {%* 通过widget插件加载模块化页面片段，name属性对应文件路径,模块名:文件目录路径 *%}
            {%widget
                name="common:widget/sidebar/sidebar.tpl"
                data=$docs
            %}
        </div>
        <div id="container">
            {%widget name="home:widget/slogan/slogan.tpl"%}
            {%foreach $docs as $index=>$doc%}
                {%widget
                    name="home:widget/section/section.tpl"
                    call="section"
                    data=$doc index=$index
                %}
            {%/foreach%}
            {%widget name="home:widget/big/big.tpl"%}
            {%*widget name="home:widget/big1/big1.tpl"*%}
            {%*widget name="home:widget/big2/big2.tpl"*%}
            {%*widget name="home:widget/big3/big3.tpl"*%}
            {%*widget name="home:widget/big4/big4.tpl"*%}
            {%*widget name="home:widget/big5/big5.tpl"*%}
            {%*widget name="home:widget/big6/big6.tpl"*%}
            {%*widget name="home:widget/big7/big7.tpl"*%}
            {%*widget name="home:widget/big8/big8.tpl"*%}
            {%*widget name="home:widget/big9/big9.tpl"*%}
            {%*widget name="home:widget/big10/big10.tpl"*%}
            {%*widget name="home:widget/big11/big11.tpl"*%}
            {%*widget name="home:widget/big12/big12.tpl"*%}
            {%*widget name="home:widget/big13/big13.tpl"*%}
            {%*widget name="home:widget/big14/big14.tpl"*%}
            {%*widget name="home:widget/big15/big15.tpl"*%}
        </div>
    </div>
    {%require name="home:static/index/index.css"%}
    {%* 通过script插件收集JS片段 *%}

{%/block%}