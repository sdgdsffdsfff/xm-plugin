package com.xiaomi.plugin.controller;

import com.xiaomi.plugin.Constant;
import com.xiaomi.plugin.bean.PageResults;
import com.xiaomi.plugin.model.FileList;
import com.xiaomi.plugin.model.FileType;
import com.xiaomi.plugin.model.Type;
import com.xiaomi.plugin.model.User;
import com.xiaomi.plugin.service.FileTypeService;
import com.xiaomi.plugin.service.TypeService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Set;

/**
 * 处理文件上传
 * Created by lijie on 2015-06-11.
 */
@Controller
@RequestMapping(value = "/filetype")
public class FileTypeController extends BaseController {

    @Autowired
    private TypeService typeService;
    @Autowired
    private FileTypeService fileTypeService;


    /**
     * 所有的上传管理
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/list")
    public ModelAndView appList(HttpServletRequest request) {

        ModelMap modelMap = new ModelMap();
        List<Type> typeList = typeService.getListByHQL("from Type order by orderNo");
        modelMap.addAttribute("type", typeList);//查询侧边栏目树

        String tid = request.getParameter("tid");//二级栏目
        if (StringUtils.isEmpty(tid)) {
            if (typeList != null && typeList.size() > 0) {
                tid = typeList.get(0).getName();
            }
        }
        modelMap.put("tid", tid);

        String fid = request.getParameter("fid");//三级栏目
        if (fid == null) {
            fid = Constant.APP_SOFT_UPGRADE;
        }
        modelMap.put("fid", fid);


        String searchFileValue = getSearchFiledValue();

        String hql = "from FileType where sid=? and style=?";

        if (StringUtils.isNotEmpty(searchFileValue)) {
            hql = "from FileType t where t.sid=? and t.style=? and t.name like '%" + searchFileValue + "%'";
        }

        PageResults<FileType> fileTypePageResults = fileTypeService.findPageByFetchedHql(hql, null, getPagenumber(), getPagesize(), tid, fid);

        modelMap.put("filetype", fileTypePageResults.getResults());

        modelMap.put("pagenumber", getPagenumber());
        modelMap.put("pagecount", fileTypePageResults.getPagecount());

        if ("zzyw".equals(tid)) {
            return new ModelAndView("zzyw_file", modelMap);
        }

        return new ModelAndView("yyrj_file", modelMap);
    }

    /**
     * 应用软件上传 添加
     *
     * @param fileList
     * @param request
     * @return
     */
    @RequestMapping(value = "/addappsoft")
    public String addappsoft(FileList fileList, HttpServletRequest request) {
        //设置上传用户
        fileList.setUser((User) request.getSession().getAttribute(Constant.CURRENT_USER));

        FileType oldFileType = fileList.getFileType();

        String name = request.getParameter("name");//当前软件名称
        String fid = request.getParameter("fid");//style
        String tid = request.getParameter("tid");//sid
        FileType fileType = fileTypeService.saveFile(fileList, name, tid, fid);

        //如果是更新软件 更新了软件的类型 更新原来类型 如果类型下面没有软件就删除
        if (oldFileType.getId() != null && !(fileType.getId().equals(oldFileType.getId()))) {
            oldFileType = fileTypeService.get(oldFileType.getId());
            if (oldFileType.getFileListSet().size() < 1) {
                fileTypeService.delete(oldFileType);
            }
        }

        return "redirect:/filetype/list?tid=" + tid + "&fid=" + fid;
    }


    @RequestMapping(value = "/deleteappsoft")
    public String deleteappsoft(HttpServletRequest request) {
        String ids = request.getParameter("ids");
        String fid = request.getParameter("fid");//当前软件属于哪个类别
        String tid = request.getParameter("tid");//当前软件属于哪个栏目
        fileTypeService.deleteFile(ids, tid, fid);
        return "redirect:/filetype/list?tid=" + tid + "&fid=" + fid;
    }

    @RequestMapping(value = "/ajax")
    @ResponseBody
    public String get(String name) {
        String hql = "from FileType where name=?";
        FileType fileType = fileTypeService.getByHQL(hql, name);
        if (fileType != null) {
            Set<FileList> fileListSet = fileType.getFileListSet();
            if (fileListSet.size() > 0) {
                FileList fileList = fileListSet.iterator().next();
                return fileList.getPlus();
            }
        }
        return null;
    }

}
