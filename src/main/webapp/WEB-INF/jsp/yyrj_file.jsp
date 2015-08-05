<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="has" uri="http://hasOperate.com" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>通用更新管理后台</title>
    <link href="${pageContext.request.contextPath}/resources/css/popModal.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
    <%--ajax上传--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/ajaxfileupload.js"></script>
    <%--弹出表单 表单回显--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.reveal.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/form/yyrj_file.js"></script>
    <%--弹出层--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/popModal.js"></script>
    <%--分页插件--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/page/jquery.pager.js" ></script>
    <%--页面折叠--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/js.js"></script>
    <script type="text/javascript">
        var ss;
        window.onload = function () {
//var w=document.documentElement.clientWidth ;//可见区域宽度
            var h = document.documentElement.clientHeight;//可见区域高度
            ss = document.getElementById('scroll');
//alert(w);
//ss.style.width=w+"px";
            ss.style.height = h - 60 + "px";
        }
    </script>
</head>

<body>
<jsp:include page="top.jsp">
    <jsp:param name="index" value="1"/>
</jsp:include>
<div class="content_box clearfix">
    <div class="vmenu fl">
        <div class="mt80">
            <div class="soft_add"><a href="/type/list"><span>管理软件类型</span></a></div>
            <ul>
                <c:forEach items="${type}" var="ty">
                    <li><a href="/filetype/list?tid=${ty.name}&fid=1" <c:if test="${tid eq ty.name}"> class="on" </c:if>><span>${ty.desc}</span></a></li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <div class="content fr" id="scroll">
        <div class="m20">
            <div class="nav">
                <has:operate> <a href="/filetype/list?tid=${tid}&fid=1" <c:if test="${fid==1}"> class="on" </c:if>>应用软件更新包管理</a></has:operate>
                <has:operate><a href="/filetype/list?tid=${tid}&fid=2" <c:if test="${fid==2}"> class="on" </c:if>>应用软件资源包管理</a></has:operate>
                <has:operate><a href="/pub/list?tid=${tid}&fid=1" >应用软件更新发布管理</a></has:operate>
                <has:operate> <a href="/pub/list?tid=${tid}&fid=2">应用软件资源发布管理</a></has:operate>
            </div>
            <div class="con_box">
                <div class="p10">
                    <div class="add_box clearfix">
                        <div class="add_div fl">
                            <a href="#" data-reveal-id="addWindow" data-animation="fade" class="add_btn btn"> <em>+</em> 新增 </a>
                            <a href="#" data-reveal-id="delWindow" data-animation="fade" class="del_btn btn">批量删除</a>
                        </div>
                        <div class="search fr clearfix">
                            <form action="/filetype/list?tid=${tid}&fid=${fid}" method="post">
                                 <input type="text" name="namefield" id="namefield"   class="search_input fl" value="请输入搜索关键字"  onfocus="if(value=='请输入搜索关键字') {value=''}"  onblur="if (value=='') {value='请输入搜索关键字'}"/>
                                 <input type="submit" value="" onclick="return s();" class="search_btn fl"/>
                            </form>
                        </div>
                    </div>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list2">
                        <thead>
                        <tr>
                            <th width="5%"><input type="checkbox" id="checkall"/> 全选</th>
                            <th width="5%">序号</th>
                            <th width="10%">资源版本</th>
                            <th width="15%">上传日期</th>
                            <th width="15%">MD5</th>
                            <th>下载地址</th>
                            <th width="5%">上传用户</th>
                            <th width="10%">操作</th>
                        </tr>
                        </thead>

                        <c:forEach items="${filetype}" var="ft">

                            <tbody>
                            <tr>
                                <td colspan="8" class="row_null"></td>
                            </tr>
                            <tr>
                                <td colspan="8" class="row_head retract" href="javascript:void(null)">
                                    资源名称：<strong>${ft.name}</strong> （<strong>${fn:length(ft.fileListSet)}</strong> 条记录）
                                </td>
                            </tr>
                            <tbody class="table_border">
                            <c:forEach items="${ft.fileListSet}" var="fl" varStatus="state">
                                <tr>
                                    <td><input type="checkbox" name="keys" value="${fl.id}"/></td>
                                    <td>${state.index+1}</td>
                                    <td>${fl.version}</td>
                                    <td>${fn:substring(fl.time, 0, 19)}</td>
                                    <td>${fl.md5}</td>
                                    <td class="http"><a href="${fl.url}" target="_blank">${fl.url}</a> </td>
                                    <td>${fl.user.nickname}</td>
                                    <td class="operate">
                                        <a href="#" class="edit" data-reveal-id="addWindow" data-animation="fade" data="${fl.id}">编辑</a>
                                        <a href="/filetype/deleteappsoft?tid=${tid}&fid=${fid}&ids=${fl.id}" class="delete">删除</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            </tbody>

                        </c:forEach>

                        <tfoot>
                        </tfoot>
                    </table>
                    <div class="page_box">
                            <div id="pager" pagenumber="${pagenumber}" pagecount="${pagecount}" url="/filetype/list?tid=${tid}&fid=${fid}"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--新增弹出层开始-->
<div class="reveal-modal" id="addWindow">
    <div class="modal_title">增值业务 - 资源包 - <span>新增</span></div>
    <%--<a class="close-reveal-modal"&lt;%&ndash; href="javascript:$('#close-reveal').trigger('click')"&ndash;%&gt;>×</a>--%>
    <!--<div class="form_tip">表单错误提示</div>-->
    <div class="formbox">
        <form method="post" action="/filetype/addappsoft" id="add">
            <div class="r_form clearfix"><label class="labels_w">资源名称：</label>
                <input type="text" name="name" id="name" class="inputs"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">上传文件：</label>
                <input type="text" name="url" id="url" class="inputs plus"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">资源MD5：</label>
                <input type="text" name="md5" id="md5" class="inputs"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">资源大小：</label>
                <input type="text" name="size" id="size" class="inputs"/>
            </div>
            <%--<div class="r_form clearfix"><label class="labels_w">上传时间：</label>--%>
            <%--<input type="text" name="time" id="time" class="inputs"/>--%>
            <%--</div>--%>
            <div class="r_form clearfix"><label class="labels_w">上传版本：</label>
                <input type="text" name="version" id="version" class="inputs"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">上传备注：</label>
                <textarea name="desc" id="desc" cols="45" rows="2"></textarea>
            </div>
            <div class="r_form clearfix"><label class="labels_w">附加信息：</label>
                <textarea name="plus" id="plus" cols="45" rows="3"></textarea>
            </div>
            <div class="r_form clearfix"><label class="labels_w">更新模式：</label><span>
                <input type="radio" name="model" value="0" checked="checked"/> 小于新版本号时更新</span><span>
                <input type="radio" name="model" value="1"/> 不等于新版本号时更新</span>
            </div>
            <div class="r_form clearfix"><label class="labels_w">MD5校验：</label><span>
                <input type="radio" name="check" value="1" checked="checked"/> 校验</span><span>
                <input type="radio" name="check" value="0"/> 不校验</span>
            </div>
            <%--<div class="r_form clearfix"><label class="labels_w">进程保护：</label><span>--%>
                <%--<input type="checkbox" name="process" value="1"/> 隐藏</span><span>--%>
                <%--<input type="checkbox" name="process" value="2"/> 防杀</span>--%>
            <%--</div>--%>
            <div style="display: none;">
                <input type="hidden" value="${fid}" name="fid"/><%--指代当前上传的是跟新包还是资源包--%>
                <input type="hidden" value="${tid}" name="tid"/><%--指代当前上传的属于哪个栏目--%>
                <input type="hidden" name="id" id="id"/>
                <input type="hidden" name="fileType.id" id="filetypeid"/><%--FileType--%>
            </div>
            <div class="r_btn clearfix">
                <a href="javascript:document.getElementById('add').submit();" class="btn add_btn">保存</a>
                <a href="#" class="btn del_btn close-reveal">关闭</a>
            </div>
        </form>
    </div>
</div>
<div style="display:none">
    <div id="content" class="popcon">
        <div class="r_form clearfix"><label class="labels_w">文件上传：</label>
            <input type="file" name="file" id="file" class="upload"/></div>
        <div class="r_form clearfix"><label class="labels_w">计算MD5：</label>
            <span> <input type="radio" id="isMd" name="isMd" value="1" checked="checked"/> 是</span>
            <span> <input type="radio" name="isMd" value="0"/> 否</span>
        </div>
        <div class="r_form clearfix"><label class="labels_w">计算大小：</label>
            <span> <input type="radio" id="isSize" name="isSize" value="1" checked="checked"/> 是</span>
            <span> <input type="radio" name="isSize" value="0"/> 否</span>
        </div>
        <div class="r_btn clearfix">
            <a href="javascript:sub();" class="btn add_btn">保存</a>
            <a href="#" id="close" class="btn del_btn close">关闭</a>
        </div>
    </div>
</div>
<!--新增弹出层结束-->
<!--删除弹出层开始-->
<div class="reveal-modal2" id="delWindow" >
    <div class="del_text clearfix"><span>数据删除后将无法恢复，您是否确定要继续执行删除操作？</span></div>
    <div class="operation">
        <a href="javascript:rf();" class="btns add_btn close-reveal">确认</a>
        <a href="#" class="btns del_btn close-reveal">取消</a>
    </div>
</div>
<!--删除弹出层开始-->
<%--刷新当前页面--%>
<div style="display: none;">
    <form id="rf" method="post" action="/filetype/deleteappsoft">
        <input type="hidden" value="${fid}" name="fid"/><%--指代当前上传的是跟新包还是资源包--%>
        <input type="hidden" value="${tid}" name="tid"/><%--指代当前上传的属于哪个栏目--%>
        <input type="hidden" name="ids" id="ids"/>
    </form>
</div>
<script>
    $(function () {
        $('#url').click(function () {
            $('#url').popModal({
                html: $('#content'),
                onDocumentClickClose: false
            });
        });
        $("#checkall").bind("change",function(){
           if($(this).attr("checked")){
               $("input[name='keys']").attr("checked", true);
           }else{
               $("input[name='keys']").attr("checked", false);
           }
        });
    });
    function sub() {
        $.ajaxFileUpload({
            url: '/upload',
            secureuri: false,
            data: {isMd: $("#isMd:checked").val(),isSize: $("#isSize:checked").val()},
            fileElementId: 'file',
            dataType: 'json',
            success: function (data) {
                $("#url").val("").val(data.url);
                $("#md5").val("").val(data.md5);
                $("#size").val("").val(data.size);
                $("#close").trigger("click");
            },
            error: function (data) {
                alert("error");
            }
        });
    }
    function rf(){
        var keys="";
        $("input[name='keys']").each(function () {
            if($(this).attr("checked")){
                keys+=$(this).val()+",";
            }
        });
        $("#ids").val(keys);
        $("#rf").submit();
    }
</script>

</body>
</html>
