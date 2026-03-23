package com.mbti.training.servlet;

import com.mbti.training.dao.AdminDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import com.mbti.training.model.SysUser;

@WebServlet("/adminManage")
public class AdminServlet extends HttpServlet {
    private AdminDao adminDao = new AdminDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 安全检查：防止学生通过直接输入 URL 绕过权限
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. 获取数据并转发到后台页面
        List<Map<String, Object>> logs = adminDao.getAllTestLogs();
        request.setAttribute("logs", logs);
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }
}