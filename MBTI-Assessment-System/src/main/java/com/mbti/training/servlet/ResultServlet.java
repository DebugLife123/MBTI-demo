package com.mbti.training.servlet;

import com.mbti.training.utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/submitAnswer")
public class ResultServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 获取选中的答案 (q1 的值是 E 或 I)
        String answer = request.getParameter("q1");
        String username = (String) request.getSession().getAttribute("currUser");

        String resultType = "";
        if ("E".equals(answer)) {
            resultType = "外向型 (E)";
        } else {
            resultType = "内向型 (I)";
        }

        // 2. 将结果存入数据库
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "UPDATE users SET personality_type = ? WHERE username = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, resultType);
            pstmt.setString(2, username);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. 把结果塞进 Request，带给结果页面展示
        request.setAttribute("myResult", resultType);
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}