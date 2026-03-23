package com.mbti.training.servlet;

import com.mbti.training.dao.UserDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String rName = request.getParameter("realName");

        // 1. 检查账号是否被占用
        if (userDao.checkUserExists(u)) {
            request.setAttribute("errorMsg", "该账号已被注册，请换一个！");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 2. 执行注册
        boolean success = userDao.register(u, p, rName);
        if (success) {
            // 注册成功，带着成功提示去登录页
            request.setAttribute("successMsg", "注册成功！请登录。");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMsg", "系统繁忙，注册失败请重试。");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}