package com.mbti.training.servlet;

import com.mbti.training.dao.QuestionDao;
import com.mbti.training.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/startTest")
public class TestServlet extends HttpServlet {
    private QuestionDao questionDao = new QuestionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 调用 DAO 获取数据库中所有启用的题目
        List<Question> list = questionDao.getAllQuestions();

        // 2. 核心功能：随机打乱题目顺序
        Collections.shuffle(list);

        // 3. 截取前 36 道题
        // (加入 Math.min 是为了防止总题库不足 36 道时越界报错)
        int limit = Math.min(36, list.size());
        List<Question> randomQuestions = list.subList(0, limit);

        // 4. 将随机抽取后的 36 道题存入 Request 作用域
        request.setAttribute("questionList", randomQuestions);

        // 5. 转发到 test.jsp 页面渲染试卷
        request.getRequestDispatcher("test.jsp").forward(request, response);
    }
}