package com.mbti.training.servlet;

import com.mbti.training.dao.UserDao;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // 实例化咱们刚才写的 DAO 采购员
    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 设置编码，防止中文乱码
        request.setCharacterEncoding("UTF-8");

        // 2. 接收表单传来的账号密码
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        // 3. 呼叫 DAO 去数据库查人
        SysUser user = userDao.login(u, p);

        // 4. 判断结果并进行页面跳转
        if (user != null) {
            request.getSession().setAttribute("loginUser", user);

            // 权限分流逻辑
            if ("ADMIN".equals(user.getRole())) {
                // 如果是管理员，跳转到管理员专用的 Servlet
                response.sendRedirect("adminManage");
            } else {
                // 如果是学生，跳转到首页
                response.sendRedirect("user_dashboard.jsp");
            }
        } else {
            // 登录失败！带着错误信息回首页
            request.setAttribute("errorMsg", "账号或密码错误，请重试！");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}