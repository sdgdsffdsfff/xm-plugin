package com.xiaomi.plugin.controller;

import com.xiaomi.plugin.Constant;
import com.xiaomi.plugin.bean.PageResults;
import com.xiaomi.plugin.model.FileType;
import com.xiaomi.plugin.model.Operate;
import com.xiaomi.plugin.model.Type;
import com.xiaomi.plugin.model.User;
import com.xiaomi.plugin.service.FileTypeService;
import com.xiaomi.plugin.service.OperateService;
import com.xiaomi.plugin.service.TypeService;
import com.xiaomi.plugin.service.UserService;
import com.xiaomi.plugin.util.MD5Util;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 用户管理
 * Created by lijie on 2015-06-16.
 */
@Controller
@RequestMapping(value = "/usr")
public class UserController extends BaseController {
    @Autowired
    private UserService userService;
    @Autowired
    private TypeService typeService;
    @Autowired
    private FileTypeService fileTypeService;
    @Autowired
    private OperateService operateService;


    @RequestMapping(value = "/list")
    public ModelAndView list() {
        ModelMap modelMap = new ModelMap();

        String searchFileValue = getSearchFiledValue();

        String hql = "from User";
        if (StringUtils.isNotEmpty(searchFileValue)) {
            hql = "from User where username like '%" + searchFileValue + "%' or nickname like '%" + searchFileValue + "%'";
        }

        PageResults<User> userPageResults = userService.findPageByFetchedHql(hql, null, getPagenumber(), getPagesize());

        modelMap.put("userlist", userPageResults.getResults());

        modelMap.put("pagenumber", getPagenumber());
        modelMap.put("pagecount", userPageResults.getPagecount());

        //权限操作
        List<Operate> operateList = operateService.getListByHQL("from Operate order by style ,orderNo");
        modelMap.put("operateList", operateList);

        return new ModelAndView("user", modelMap);
    }

    @RequestMapping(value = "/add")
    public String add(User user) {
        User entity;
        if (user.getId() != null) {
            entity = userService.get(user.getId());
            entity.setUsername(user.getUsername());
            entity.setNickname(user.getNickname());
        } else {
            entity = user;
            entity.setPassword(MD5Util.getStrMd5String(entity.getPassword()));
        }
        userService.saveOrUpdate(entity);
        return "redirect:/usr/list";
    }

    @RequestMapping(value = "/update")
    @ResponseBody
    public String update(String oldpassword, String newpassword, String confirmpassword, String id) {
        if (StringUtils.isNotEmpty(id)) {
            User user = userService.get(Integer.valueOf(id));
            if (!(MD5Util.getStrMd5String(oldpassword)).equals(user.getPassword())) {
                return "error";
            }
            user.setPassword(MD5Util.getStrMd5String(newpassword));
            userService.saveOrUpdate(user);
        }
        return "success";
    }

    /**
     * 权限修改
     *
     * @param operete
     * @param id
     * @return
     */
    @RequestMapping(value = "/updateAu")
    @ResponseBody
    public String updateAu(String operete, String id) {
        if (StringUtils.isNotEmpty(id)) {
            User user = userService.get(Integer.valueOf(id));

            Set<Operate> operateSet = new HashSet<Operate>();
            if (StringUtils.isNotEmpty(operete)) {
                for (String op : operete.split(",")) {
                    Operate operate = new Operate();
                    operate.setId(Integer.valueOf(op));
                    operateSet.add(operate);
                }
            }
            user.setOperateSet(operateSet);
            userService.saveOrUpdate(user);
        }
        return "success";
    }

    @RequestMapping(value = "/delete")
    public String delete(String ids) {
        List<Integer> idsList = new ArrayList<Integer>();
        for (String id : ids.split(",")) {
            if (StringUtils.isNotEmpty(id)) {
                idsList.add(Integer.valueOf(id));
            }
        }
        userService.deleteByIds(idsList);
        return "redirect:/usr/list";
    }


    @RequestMapping(value = "/resources/login")
    public String login(HttpServletRequest request, User user) {
        if (StringUtils.isEmpty(user.getUsername()) || StringUtils.isEmpty(user.getPassword())) {
            return "redirect:/";
        }
        User entity = userService.getByHQL("from User where username=?", user.getUsername());
        if (entity == null) {
            return "redirect:/";
        }
        String userPassword = MD5Util.getStrMd5String(user.getPassword());
        if (!userPassword.equals(entity.getPassword())) {
            return "redirect:/";
        }
        HttpSession session = request.getSession();
        session.setAttribute(Constant.CURRENT_USER, entity);
        return "redirect:/usr/appsoft";
    }

    @RequestMapping(value = "/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().removeAttribute(Constant.CURRENT_USER);
        return "redirect:/";
    }

    /**
     * 登陆后默认跳转的页面
     * 初始化应用软件更新包
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/appsoft")
    public ModelAndView appSoft(HttpServletRequest request) {
        ModelMap modelMap = new ModelMap();
        List<Type> typeList = typeService.getListByHQL("from Type order by orderNo");
        modelMap.addAttribute("type", typeList);//查询侧边栏目树
        String tid = request.getParameter("tid");//代表侧边栏目点击的哪一个
        if (StringUtils.isEmpty(tid)) {
            if (typeList != null && typeList.size() > 0) {
                tid = typeList.get(0).getName();
            }
        }
        modelMap.put("tid", tid);

        String fid = request.getParameter("fid");//代表是 应用软件更新包 或者应用软件资源包

        if (fid == null) {
            fid = Constant.APP_SOFT_UPGRADE;
        }
        modelMap.put("fid", fid);

        String hql = "from FileType where sid=? and style=?";
        PageResults<FileType> fileTypePageResults = fileTypeService.findPageByFetchedHql(hql, null, getPagenumber(), getPagesize(), tid, fid);
        modelMap.put("filetype", fileTypePageResults.getResults());
        modelMap.put("pagenumber", getPagenumber());
        modelMap.put("pagecount", fileTypePageResults.getPagecount());
        return new ModelAndView("yyrj_file", modelMap);
    }

}
