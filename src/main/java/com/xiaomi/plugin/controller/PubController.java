package com.xiaomi.plugin.controller;

import com.xiaomi.plugin.Constant;
import com.xiaomi.plugin.bean.PageResults;
import com.xiaomi.plugin.model.*;
import com.xiaomi.plugin.service.FileTypeService;
import com.xiaomi.plugin.service.PubService;
import com.xiaomi.plugin.service.TypeService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 文件发布管理
 * Created by lijie on 2015-06-29.
 */
@Controller
@RequestMapping(value = "/pub")
public class PubController extends BaseController {

    @Autowired
    private TypeService typeService;
    @Autowired
    private FileTypeService fileTypeService;
    @Autowired
    private PubService pubService;

    @RequestMapping(value = "/list")
    public ModelAndView list(HttpServletRequest request) {
        ModelMap modelMap = new ModelMap();
        List<Type> typeList = typeService.getListByHQL("from Type order by orderNo");
        modelMap.addAttribute("type", typeList);//查询侧边栏目树

        String tid = request.getParameter("tid");//代表侧边栏目点击的哪一个 二级栏目
        modelMap.put("tid", tid);

        String fid = request.getParameter("fid");//三级栏目
        modelMap.put("fid", fid);

        //页面需要用到的数据
        //1.范围设置中的 代理商设置,区域设置
        //2.当前发布对应的资源选择

        //当前发布对应的资源选择
        String hql = "from FileType where sid=? and style=?";
        List<FileType> fileTypeList = fileTypeService.getListByHQL(hql, tid, fid);
        modelMap.put("fileTypeList", fileTypeList);

        //列表
        String searchFileValue = getSearchFiledValue();

        hql = "from Pub where sid=? and style=?";

        if (StringUtils.isNotEmpty(searchFileValue)) {
            hql = "from Pub p where p.sid=? and p.style=? and p.desc like '%" + searchFileValue + "%'";
        }

        PageResults<Pub> pubPageResults = pubService.findPageByFetchedHql(hql, null, getPagenumber(), getPagesize(), tid, fid);
        modelMap.put("publist", pubPageResults.getResults());

        modelMap.put("pagenumber", getPagenumber());
        modelMap.put("pagecount", pubPageResults.getPagecount());

        if ("zzyw".equals(tid)) {
            return new ModelAndView("zzyw_pub", modelMap);
        }

        return new ModelAndView("yyrj_pub", modelMap);
    }

    @RequestMapping(value = "/addapppub")
    public String addapppub(Pub pub, HttpServletRequest request) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        String fid = request.getParameter("fid");//三级栏目 style
        String tid = request.getParameter("tid");//二级栏目 sid
        String startTimes = request.getParameter("startTimes");
        String endTimes = request.getParameter("endTimes");

        String filelistids = request.getParameter("filelistids");//资源选择

        Pub entity;
        if (pub.getId() != null) {
            entity = pubService.get(pub.getId());
            entity.setDesc(pub.getDesc());
            entity.setRangeType(pub.getRangeType());
            entity.setRangeValue(pub.getRangeValue());
            entity.setDelay(pub.getDelay());
            entity.setLimit(pub.getLimit());
            entity.setState(pub.getState());
            entity.setStart(pub.getStart());
            entity.setNumber(pub.getNumber());

        } else {
            entity = pub;
            entity.setCreateTime(new Date());
        }
        try {
            entity.setStartTime(simpleDateFormat.parse(startTimes));
            entity.setEndTime(simpleDateFormat.parse(endTimes));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        Set<FileList> fileListSet = new HashSet<FileList>();
        if (StringUtils.isNotEmpty(filelistids)) {
            for (String filelistid : filelistids.split(",")) {
                if (!"".equals(filelistid.trim())) {
                    FileList fileList = new FileList();
                    fileList.setId(Integer.valueOf(filelistid.trim()));
                    fileListSet.add(fileList);
                }
            }
        }
        entity.setFileListSet(fileListSet);

        entity.setStyle(fid);
        entity.setSid(tid);

        //设置当前发布人
        entity.setUser((User) request.getSession().getAttribute(Constant.CURRENT_USER));

        pubService.saveOrUpdate(entity);
        return "redirect:/pub/list?tid=" + tid + "&fid=" + fid;
    }

    @RequestMapping(value = "/deletepub")
    public String deletepub(HttpServletRequest request) {
        String fid = request.getParameter("fid");//三级栏目
        String tid = request.getParameter("tid");//二级栏目
        String ids = request.getParameter("ids");
        List<Integer> idsList = new ArrayList<Integer>();
        for (String id : ids.split(",")) {
            if (!"".equals(id.trim())) {
                idsList.add(Integer.valueOf(id));
            }
        }
        pubService.deleteByIds(idsList);
        return "redirect:/pub/list?tid=" + tid + "&fid=" + fid;
    }

}
