package com.mbti.training.servlet;

import com.mbti.training.dao.QuestionDao;
import com.mbti.training.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/questionManage")
public class QuestionManageServlet extends HttpServlet {
    private QuestionDao questionDao = new QuestionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String method = request.getParameter("method");

        // 处理删除逻辑
        if ("delete".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            questionDao.delete(id);
            response.sendRedirect("questionManage"); // 删除后刷新页面
            return;
        }

        // 默认展示列表
        List<Question> list = questionDao.getAllQuestions();
        request.setAttribute("qList", list);
        request.getRequestDispatcher("question_list.jsp").forward(request, response);
    }
}