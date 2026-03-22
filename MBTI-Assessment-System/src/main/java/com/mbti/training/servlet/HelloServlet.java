package com.mbti.training.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// 这个注解告诉 Tomcat：如果有人访问 /hello，就交给我处理
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("username");

        // 1. 尝试连接数据库并将名字存进去
        try (java.sql.Connection conn = com.mbti.training.utils.DBUtils.getConnection()) {
            String sql = "INSERT INTO users (username) VALUES (?)";
            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.executeUpdate();
            System.out.println("【数据库通知】：已成功保存用户 " + name + " 到数据库！");
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }

        // 2. 页面反馈
        resp.setContentType("text/html;charset=UTF-8");
        req.getSession().setAttribute("currUser", name); // 把用户名存入 Session（系统缓存），方便后面页面使用
        resp.sendRedirect("test.jsp"); // 重定向到答题页面
    }
}