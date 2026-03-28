package com.mbti.training.servlet;

import com.mbti.training.dao.AssessmentDao;
import com.mbti.training.dao.AssessmentRegistrationDao;
import com.mbti.training.model.Assessment;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

// 🌟 核心修改：路径改为 testPlanManage
@WebServlet("/testPlanManage")
public class TestPlanManageServlet extends HttpServlet {
    private AssessmentDao assessmentDao = new AssessmentDao();
    private AssessmentRegistrationDao regDao = new AssessmentRegistrationDao();

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
            response.sendRedirect("testPlanManage"); // 🌟 更新跳转
        } else if ("participants".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Assessment a = assessmentDao.getById(id);
            List<Map<String, Object>> participants = regDao.getParticipants(id);
            request.setAttribute("assessment", a);
            request.setAttribute("participants", participants);
            request.getRequestDispatcher("participant_list.jsp").forward(request, response);
        } else if ("kick".equals(method)) {
            int aid = Integer.parseInt(request.getParameter("assessmentId"));
            int uid = Integer.parseInt(request.getParameter("userId"));
            regDao.cancelRegistration(aid, uid);
            response.sendRedirect("testPlanManage?method=participants&id=" + aid); // 🌟 更新跳转
        } else {
        String formatFilter = request.getParameter("format");
        List<Assessment> list = assessmentDao.getAll(formatFilter);
        request.setAttribute("list", list);
        request.setAttribute("formatFilter", formatFilter);
        // 🌟 核心修改：把 assessment_list.jsp 改成 test_plan_list.jsp
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
            response.sendRedirect("testPlanManage"); // 🌟 更新跳转
        }
    }
}