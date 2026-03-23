package com.mbti.training.servlet;

import com.mbti.training.dao.UserDao;
import com.mbti.training.model.SysUser;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/security")
public class SecurityServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 展示修改页面
        request.getRequestDispatcher("security.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        SysUser loginUser = (SysUser) request.getSession().getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String oldPwd = request.getParameter("oldPassword");
        String newPwd = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");

        // 1. 后端二次校验：新密码与确认密码是否一致
        if (!newPwd.equals(confirmPwd)) {
            request.setAttribute("errorMsg", "两次输入的新密码不一致！");
            request.getRequestDispatcher("security.jsp").forward(request, response);
            return;
        }

        // 2. 调用 DAO 修改密码
        boolean success = userDao.updatePassword(loginUser.getId(), oldPwd, newPwd);

        if (success) {
            request.setAttribute("successMsg", "密码修改成功，请记住您的新密码！");
        } else {
            request.setAttribute("errorMsg", "修改失败：原密码输入错误。");
        }

        request.getRequestDispatcher("security.jsp").forward(request, response);
    }
}