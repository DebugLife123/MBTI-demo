package com.mbti.training.servlet;

import com.mbti.training.dao.AssessmentDao;
import com.mbti.training.dao.AssessmentRegistrationDao;
import com.mbti.training.dao.UserDao;
import com.mbti.training.model.Assessment;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet("/testPlanManage")
public class TestPlanManageServlet extends HttpServlet {
    private AssessmentDao assessmentDao = new AssessmentDao();
    private AssessmentRegistrationDao regDao = new AssessmentRegistrationDao();
    private UserDao userDao = new UserDao(); // 🌟 引入 UserDao

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp"); return;
        }

        String method = request.getParameter("method");
        if ("delete".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            assessmentDao.delete(id);
            response.sendRedirect("testPlanManage");
        } else if ("participants".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Assessment a = assessmentDao.getById(id);
            List<Map<String, Object>> participants = regDao.getParticipants(id);

            // 🌟 获取全校所有用户，供弹窗选择
            List<SysUser> allUsers = userDao.getAllUsers();

            // 🌟 提取已报名用户的 ID 集合，方便前端做 "置灰" 判断
            Set<Integer> regIds = new HashSet<>();
            for (Map<String, Object> p : participants) {
                regIds.add((Integer) p.get("userId"));
            }

            request.setAttribute("assessment", a);
            request.setAttribute("participants", participants);
            request.setAttribute("allUsers", allUsers); // 传给弹窗
            request.setAttribute("regIds", regIds);     // 传给弹窗判断状态

            request.getRequestDispatcher("participant_list.jsp").forward(request, response);
        } else if ("kick".equals(method)) {
            int aid = Integer.parseInt(request.getParameter("assessmentId"));
            int uid = Integer.parseInt(request.getParameter("userId"));
            regDao.cancelRegistration(aid, uid);
            response.sendRedirect("testPlanManage?method=participants&id=" + aid);
        } else {
            String formatFilter = request.getParameter("format");
            List<Assessment> list = assessmentDao.getAll(formatFilter);
            request.setAttribute("list", list);
            request.setAttribute("formatFilter", formatFilter);
            request.getRequestDispatcher("test_plan_list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String method = request.getParameter("method");

        if ("create".equals(method)) {
            Assessment a = new Assessment();
            a.setTitle(request.getParameter("title"));
            a.setPurpose(request.getParameter("purpose"));
            a.setContent(request.getParameter("content"));
            a.setFormat(request.getParameter("format"));
            a.setLocation(request.getParameter("location"));
            a.setNotes(request.getParameter("notes"));
            try {
                String testTimeStr = request.getParameter("testTime");
                Date testTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(testTimeStr);
                a.setTestTime(testTime);
            } catch (Exception e) { e.printStackTrace(); }

            assessmentDao.create(a);
            response.sendRedirect("testPlanManage");
        }
        // 🌟 新增：处理导入报名人员的请求
        else if ("import".equals(method)) {
            int aid = Integer.parseInt(request.getParameter("assessmentId"));
            String[] userIds = request.getParameterValues("userIds");

            if (userIds != null && userIds.length > 0) {
                for (String uidStr : userIds) {
                    // 调用现有的报名方法，如果是已报名的底层SQL(唯一索引)会自动忽略，很安全
                    regDao.register(aid, Integer.parseInt(uidStr));
                }
            }
            // 处理完跳转回人员名单页
            response.sendRedirect("testPlanManage?method=participants&id=" + aid);
        }
    }
}