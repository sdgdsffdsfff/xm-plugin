/**
 * Created by lijie on 2015-06-26.
 */
//data="主键值"
$.fn.echo = function ($this) {
    var value = $this.attr('data');

    if (value) {
        $.ajax({
            type: 'post',
            url: "/filelist/ajax",
            data: {id: value},
            dataType: 'json',
            success: function (data) {
                var name = data.fileType.name;
                var id = data.id;
                var version = data.version;
                var md5 = data.md5;
                var url = data.url;
                var desc = data.desc;
                var plus = data.plus;
                var model = data.model;
                var check = data.check;
                var process = data.process;
                var fileTypeId = data.fileType.id;
                var size = data.size;
                $("#name").val(name);
                $("#id").val(id);
                $("#version").val(version);
                $("#md5").val(md5);
                $("#url").val(url);
                $("#desc").val(desc);
                $("#plus").val(plus);
                $("input[name='model'][value='" + model + "']").attr("checked", true);
                $("input[name='check'][value='" + check + "']").attr("checked", true);
                if (process) {
                    if (process.indexOf("1") != -1) {
                        $("input[name='process'][value='1']").attr("checked", true);
                    }
                    if (process.indexOf("2") != -1) {
                        $("input[name='process'][value='2']").attr("checked", true);
                    }
                } else {
                    $("input[name='process'][value='1']").attr("checked", false);
                    $("input[name='process'][value='2']").attr("checked", false);
                }
                $("#filetypeid").val(fileTypeId);
                $("#size").val(size);
            }

        });

    } else {
        $("#name").val("");
        $("#id").val("");
        $("#version").val("");
        $("#md5").val("");
        $("#url").val("");
        $("#desc").val("");
        $("#plus").val("");
        $("input[name='model'][value='0']").attr("checked", true);
        $("input[name='check'][value='1']").attr("checked", true);
        $("#filetypeid").val("");
        $("#size").val("");
    }

};


//1、新增资源包（插件包、更新包、广告包……）时，界面上初始化时，附件信息初始化为最后一次同名资源包的附加信息
$(function () {

    $("input[name='name']").change(function () {
        var name = $(this).val();
        if (!$("input[name='fileType.id']").val()) {

            $.ajax({
                type: 'post',
                url: "/filetype/ajax",
                data: {name: name},
                success: function (data) {
                    if (data) {
                        $("#plus").val(data);
                    }
                }
            })

        }

    });

});