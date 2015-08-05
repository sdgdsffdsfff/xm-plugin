/**
 * Created by lijie on 2015-06-29.
 */
$(function () {
    //任务范围设置 根据任务范围的选择 给定不同的内容
    $("#rangeType").on("change", function () {
        var $rangeValue = $("#rangeValue");
        if ($(this).val() == 3) {
            $rangeValue.popModal({
                html: $('#agentcontent'),
                placement: 'bottomLeft'
            });
        } else if ($(this).val() == 4) {
            $rangeValue.popModal({
                html: $('#regioncontent'),
                placement: 'bottomLeft'
            });
        }
    })
});

/*
 *  树 选择值后确认
 * */
function rangeValueAdd(id) {
    var nodes = $("#" + id).tree('getChecked');
    var s = '';
    for (var i = 0; i < nodes.length; i++) {
        if (s != '') s += ',';
        if (nodes[i].value) {
            s += nodes[i].value;
        } else {
            s += nodes[i].text.substring(0, nodes[i].text.indexOf("["));
        }
    }
    $("#rangeValue").val(s);
    $(".close").trigger("click");
}

/*
 * 表单回显
 * ${pub.desc}-${pub.rangeType}-${pub.rangeValue}-${pub.filelistids}-${fn:substring(pub.startTime, 0, 19)}-${fn:substring(pub.endTime, 0, 19)}-${pub.delay}-${pub.limit}-${pub.state}-${pub.id}#${pub.number}#${pub.start}#${pub.filelistnames}
 * */

$.fn.echo = function ($this) {
    var value = $this.attr('data');
    if (value) {
        var val = value.split("#");
        var desc = val[0];
        var rangeType = val[1];
        var rangeValue = val[2];
        var filelistids = val[3];
        var startTime = val[4];
        var endTime = val[5];
        var delay = val[6];
        var limit = val[7];
        var state = val[8];
        var id = val[9];
        var number = val[10];
        var start = val[11];
        var filelistnames = val[12];
        $("#desc").val(desc);
        $("#rangeType").val(rangeType);
        $("#rangeValue").val(rangeValue);
        $("#filelistids").val(filelistids);
        $("#filelistnames").val(filelistnames);
        $("#startTimes").val(startTime);
        $("#endTimes").val(endTime);
        $("#delay").val(delay);
        $("#limit").val(limit);

        if (state.indexOf("0") != -1) {
            $("input[name='state'][value='0']").attr("checked", true);
        }
        if (state.indexOf("1") != -1) {
            $("input[name='state'][value='1']").attr("checked", true);
        }
        if (start.indexOf("0") != -1) {
            $("input[name='start'][value='0']").attr("checked", true);
        }
        if (start.indexOf("1") != -1) {
            $("input[name='start'][value='1']").attr("checked", true);
        }
        $("#id").val(id);
        $("#number").val(number);
    } else {
        $("#desc").val("");
        $("#rangeType").val("");
        $("#rangeValue").val("");
        $("#filelistids").val("");
        $("#filelistnames").val("");
        $("#startTimes").val("");
        $("#endTimes").val("");
        $("#delay").val(0);
        $("#limit").val(0);
        $("#number").val(0);
        $("#id").val("");
        $("input[name='state'][value='1']").attr("checked", true);
        $("input[name='start'][value='0']").attr("checked", true);
    }
};