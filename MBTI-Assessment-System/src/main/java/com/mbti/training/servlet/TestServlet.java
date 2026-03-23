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

@WebServlet("/startTest")
public class TestServlet extends HttpServlet {
    private QuestionDao questionDao = new QuestionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 调用 DAO 获取数据库中所有启用的题目
        List<Question> list = questionDao.getAllQuestions();

        // 2. 将题目列表存入 Request 作用域
        request.setAttribute("questionList", list);

        // 3. 转发到 test.jsp 页面
        request.getRequestDispatcher("test.jsp").forward(request, response);
    }
}