package com.mbti.training.servlet;

import com.mbti.training.dao.AssessmentDao;
import com.mbti.training.dao.AssessmentRegistrationDao;
import com.mbti.training.model.Assessment;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/testRegistration")
public class TestRegistrationServlet extends HttpServlet {
    private AssessmentDao assessmentDao = new AssessmentDao();
    private AssessmentRegistrationDao regDao = new AssessmentRegistrationDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        String method = request.getParameter("method");
        if ("register".equals(method)) {
            int aid = Integer.parseInt(request.getParameter("id"));
            regDao.register(aid, user.getId());
            response.sendRedirect("testRegistration");
        } else if ("cancel".equals(method)) {
            int aid = Integer.parseInt(request.getParameter("id"));
            regDao.cancelRegistration(aid, user.getId());
            response.sendRedirect("testRegistration");
        } else {
            String formatFilter = request.getParameter("format");
            List<Assessment> list = assessmentDao.getAll(formatFilter);
            for (Assessment a : list) {
                boolean isReg = regDao.isRegistered(a.getId(), user.getId());
                a.setRegistered(isReg);
            }
            request.setAttribute("list", list);
            request.setAttribute("formatFilter", formatFilter);
            request.getRequestDispatcher("test_registration.jsp").forward(request, response);
        }
    }
}