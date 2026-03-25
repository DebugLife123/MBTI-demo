package com.mbti.training.servlet;

import com.mbti.training.dao.UserDao;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 用户登录控制器
 * 负责接收登录表单、验证身份并进行角色分流跳转
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // 实例化数据访问对象 (DAO)
    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 设置编码，防止中文乱码
        request.setCharacterEncoding("UTF-8");

        // 2. 接收表单传来的账号密码
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        // 3. 呼叫 DAO 去数据库查询用户信息
        SysUser user = userDao.login(u, p);

        // 4. 判断结果并进行页面跳转
        if (user != null) {
            // 登录成功，将用户信息存入 Session 缓存
            request.getSession().setAttribute("loginUser", user);

            // 权限分流逻辑
            if ("ADMIN".equals(user.getRole())) {
                // 🛠️ 管理员：跳转到管理员看板 Servlet
                response.sendRedirect("adminManage");
            } else {
                // 🚀 学生：跳转到“我的主页” (Dashboard)，而不是直接开始测试
                // 这是我们在第二阶段优化的核心跳转逻辑
                response.sendRedirect("user_dashboard.jsp");
            }
        } else {
            // 登录失败！带着错误提示信息返回首页
            request.setAttribute("errorMsg", "账号或密码错误，请重试！");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}