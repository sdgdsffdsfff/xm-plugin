<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="has" uri="http://hasOperate.com" %>
<%@ taglib prefix="fmtstat" uri="http://formatState.com" %>
<%@ page trimDirectiveWhitespaces="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>通用更新管理后台</title>


    <link href="${pageContext.request.contextPath}/resources/ui/themes/default/easyui.css" rel="stylesheet" type="text/css">

    <link href="${pageContext.request.contextPath}/resources/css/popModal.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
    <%--ajax上传--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/ajaxfileupload.js"></script>
    <%--弹出表单 表单回显--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.reveal.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/form/yyrj_pub.js"></script>
    <%--弹出层--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/popModal.js"></script>
    <%--分页插件--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/page/jquery.pager.js"></script>
    <%--页面折叠--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/js.js"></script>
    <%--tree--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/ui/jquery.easyui.min.js"></script>
    <%--时间选择--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/laydate.dev.js"></script>
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
    <jsp:param name="index" value="2"/>
</jsp:include>
<div class="content_box clearfix">
    <div class="vmenu fl">
        <div class="mt80">
            <%--<div class="soft_add"><a href="/type/list"><span>管理软件类型</span></a></div>--%>
            <ul>
                <has:operate>
                    <li><a href="/filetype/list?tid=zzyw&fid=3" ><span>增值业务插件包管理</span></a></li>
                </has:operate>
                <has:operate>
                    <li><a href="/filetype/list?tid=zzyw&fid=4" ><span>增值业务资源包管理</span></a></li>
                </has:operate>
                <has:operate>
                    <li><a href="/pub/list?tid=zzyw&fid=3" <c:if test="${fid==3}"> class="on" </c:if> ><span>增值业务插件发布管理</span></a></li>
                </has:operate>
                <has:operate>
                    <li><a href="/pub/list?tid=zzyw&fid=4" <c:if  test="${fid==4}"> class="on" </c:if>><span>增值业务资源发布管理</span></a></li>
                </has:operate>
            </ul>
        </div>
    </div>
    <div class="content fr" id="scroll">
        <div class="m20">
            <div class="con_box">
                <div class="p10">
                    <div class="add_box clearfix">
                        <div class="add_div fl">
                            <a href="#" data-reveal-id="addWindow" data-animation="fade" class="add_btn btn"> <em>+</em> 新增 </a>
                            <a href="#" data-reveal-id="delWindow" data-animation="fade" class="del_btn btn">批量删除</a>
                        </div>
                        <div class="search fr clearfix">
                            <form action="/pub/list?tid=zzyw&fid=${fid}" method="post">
                                <input type="text" name="namefield" id="namefield" class="search_input fl" value="请输入搜索关键字"  onfocus="if(value=='请输入搜索关键字') {value=''}"  onblur="if (value=='') {value='请输入搜索关键字'}"/>
                                <input type="submit" value="" onclick="return s();" class="search_btn fl"/>
                            </form>
                        </div>
                    </div>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list1">
                        <tr>
                            <th width="6%"><input type="checkbox" id="checkall"/> 全选</th>
                            <th width="4%">序号</th>
                            <th>任务说明</th>
                            <th width="6%">任务范围</th>
                            <th width="10%">范围设置</th>
                            <th width="13%">发布时间</th>
                            <th width="13%">有效期 -- 开始</th>
                            <th width="13%">有效期 -- 结束</th>
                            <th width="6%">发布状态</th>
                            <th width="6%">发布用户</th>
                            <th width="13%">操作</th>
                        </tr>
                        <c:forEach items="${publist}" var="pub" varStatus="state">
                            <c:if test="${state.index%2==0}"><tr class="tr1"></c:if>
                            <c:if test="${state.index%2==1}"><tr class="tr2"></c:if>
                            <td><input type="checkbox" name="keys" value="${pub.id}"/></td>
                            <td>${state.index+1}</td>
                            <td>${pub.desc}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${pub.rangeType==1}">目标机器</c:when>
                                    <c:when test="${pub.rangeType==2}">产品版本</c:when>
                                    <c:when test="${pub.rangeType==3}">代理商</c:when>
                                    <c:when test="${pub.rangeType==4}">区域</c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${fn:length(pub.rangeValue)>10}">${fn:substring(pub.rangeValue, 0,10 )}...</c:when>
                                    <c:otherwise>${pub.rangeValue}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${fn:substring(pub.createTime, 0, 19)}</td>
                            <td>${fn:substring(pub.startTime, 0, 19)}</td>
                            <td>${fn:substring(pub.endTime, 0, 19)}</td>
                            <fmtstat:operate>${pub.state},${pub.startTime},${pub.endTime}</fmtstat:operate>
                            <td>${pub.user.nickname}</td>
                            <td class="operate">
                                <a href="#" data-reveal-id="addWindow" data-animation="fade" class="edit"
                                   data="${pub.desc}#${pub.rangeType}#${pub.rangeValue}# <c:forEach items="${pub.fileListSet}" var="filelist">${filelist.id}, </c:forEach> #${fn:substring(pub.startTime, 0, 19)}#${fn:substring(pub.endTime, 0, 19)}#${pub.delay}#${pub.limit}#${pub.state}#${pub.id}#${pub.number}#${pub.start}#<c:forEach items="${pub.fileListSet}" var="filelist">${filelist.fileType.name}[${filelist.version}], </c:forEach>">编辑</a>
                                <a href="/pub/deletepub?tid=${tid}&fid=${fid}&ids=${pub.id}" class="delete">删除</a>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                    <div class="page_box">
                        <div id="pager" pagenumber="${pagenumber}" pagecount="${pagecount}"
                             url="/pub/list?tid=${tid}&fid=${fid}"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--新增弹出层开始-->
<div class="reveal-modal" id="addWindow">
    <div class="modal_title">增值业务 - 插件包 - <span>新增</span></div>
    <!--<div class="form_tip">表单错误提示</div>-->
    <div class="formbox">
        <form method="post" id="add" action="/pub/addapppub">
            <div class="r_form clearfix"><label class="labels_w">任务说明：</label>
                <input type="text" name="desc" id="desc" class="inputs"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">任务范围：</label>
                <select name="rangeType" id="rangeType" class="selects">
                    <option value="1">目标机器</option>
                    <option value="2">产品版本</option>
                    <option value="3">代理商</option>
                    <option value="4">区域</option>
                </select>
            </div>
            <div class="r_form clearfix"><label class="labels_w">范围设置：</label>
                <input type="text" name="rangeValue" id="rangeValue" class="inputs plus"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">资源选择：</label>
                <input type="hidden" name="filelistids" id="filelistids" class="inputs plus">
                <input type="text" name="filelistnames" id="filelistnames" class="inputs plus">
            </div>
            <div class="r_form clearfix"><label class="labels_w">有效期：</label>
                <input type="text" name="startTimes" id="startTimes" class="inputs date"
                       onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})"/>&nbsp;-&nbsp;
                <input type="text" name="endTimes" id="endTimes" class="inputs date"
                       onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">发布延迟：</label>
                <input type="text" name="delay" id="delay" class="inputs plus"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">限制个数：</label>
                <input type="text" name="limit" id="limit" class="inputs"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">获取次数：</label>
                <input type="text" name="number" id="number" class="inputs"/>
            </div>
            <div class="r_form clearfix"><label class="labels_w">执行方式：</label><span>
                <input type="radio" name="start" value="0"/> 重启后执行</span><span>
                <input type="radio" name="start" value="1"  checked="checked"/> 下载后执行</span>
            </div>
            <div class="r_form clearfix"><label class="labels_w">发布状态：</label><span>
                <input type="radio" name="state" value="1" checked="checked"/> 启用</span><span>
                <input type="radio" name="state" value="0"/> 停用</span>
            </div>
            <div style="display: none;">
                <input type="hidden" value="${fid}" name="fid"/><%--三级栏目--%>
                <input type="hidden" value="${tid}" name="tid"/><%--二级栏目--%>
                <input type="hidden" name="id" id="id"/>
            </div>
            <div class="r_btn clearfix">
                <a href="javascript:document.getElementById('add').submit();" class="btn add_btn">保存</a>
                <a href="#" class="btn del_btn close-reveal">关闭</a>
            </div>
        </form>
    </div>
</div>
<!--新增弹出层结束-->
<%--范围设置--%>
<div style="display:none">
    <div id="agentcontent" class="popcon">
        <div class="r_form clearfix">
            <div id="agenttree" class="easyui-tree" data-options="url:'/agent/get',method:'get',checkbox:true"></div>
        </div>
        <div class="r_btn clearfix">
            <a href="javascript:rangeValueAdd('agenttree');" class="btn add_btn">保存</a>
            <a href="#" class="btn del_btn close">关闭</a>
        </div>
    </div>
    <div id="regioncontent" class="popcon">
        <div class="r_form clearfix">
            <div id="regiontree" class="easyui-tree" data-options="url:'/region/get',method:'get',checkbox:true"></div>
        </div>
        <div class="r_btn clearfix">
            <a href="javascript:rangeValueAdd('regiontree');" class="btn add_btn">保存</a>
            <a href="#" class="btn del_btn close">关闭</a>
        </div>
    </div>
</div>
<%--文件选择--%>
<div style="display:none">
    <div id="content2" class="popcon">
        <div class="tree">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list2">
                <thead>
                <tr>
                    <th width="20%"></th>
                    <th width="30%">序号</th>
                    <th>资源版本</th>
                </tr>
                </thead>

                <c:forEach items="${fileTypeList}" var="filetype">
                    <tbody>
                    <tr>
                        <td colspan="7" class="row_null"></td>
                    </tr>
                    <tr>
                        <td colspan="7" class="row_head2">资源名称：<strong>${filetype.name}</strong>
                            （<strong>${fn:length(filetype.fileListSet)}</strong> 条记录）
                        </td>
                    </tr>
                    <tbody class="table_border2">
                    <c:forEach items="${filetype.fileListSet}" var="filelist" varStatus="state">
                        <tr>
                            <td><input type="radio" class="fileselect" name="${filetype.name}" value="${filelist.id}" data="${filetype.name}[${filelist.version}]"/>
                            </td>
                            <td>${state.index+1}</td>
                            <td>${filelist.version}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                    </tbody>
                </c:forEach>

                <tfoot>
                </tfoot>
            </table>
        </div>
        <div class="r_btn clearfix">
            <a href="javascript:filelistidsValue()" class="btn add_btn">保存</a>
            <a href="#" class="btn del_btn close">关闭</a>
        </div>
    </div>
</div>
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
    <form id="rf" method="post" action="/pub/deletepub">
        <input type="hidden" value="${fid}" name="fid"/><%--指代当前上传的是跟新包还是资源包--%>
        <input type="hidden" value="${tid}" name="tid"/><%--指代当前上传的属于哪个栏目--%>
        <input type="hidden" name="ids" id="ids"/>
    </form>
</div>
<script type="text/javascript">
    $(function () {
        $('#filelistnames').click(function () {
            var filelistids= $("#filelistids").val();
            $("input[class='fileselect']").each(function () {
                if(filelistids.indexOf($(this).val()+",")!=-1){
                    $(this).attr("checked",true);
                }else{
                    $(this).attr("checked",false);
                }
            });
            $('#filelistnames').popModal({
                html: $('#content2'),
                placement: 'bottomLeft'
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
    function filelistidsValue() {
        var filelistids = "";
        var filelistnames="";
        $(".fileselect").each(function () {
            var _select = $(this).attr("checked");
            if (_select) {
                filelistids += $(this).val() + ",";
                filelistnames += $(this).attr("data") + ",";
            }
        });
        $("#filelistids").val(filelistids);
        $("#filelistnames").val(filelistnames);
        $(".close").trigger("click");
    }
    function rf(){
        var keys="";
        $("input[name='keys']").each(function () {
            if($(this).attr("checked")){
                keys+=$(this).val()+",";
            }
        });
        if(keys==""){
            alert("请选择删除项!");
            return;
        }
        $("#ids").val(keys);
        $("#rf").submit();
    }
</script>
</body>
</html>
