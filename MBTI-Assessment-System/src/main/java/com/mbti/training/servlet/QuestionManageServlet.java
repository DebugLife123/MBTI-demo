package com.mbti.training.servlet;

import com.mbti.training.dao.QuestionDao;
import com.mbti.training.model.Question;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/questionManage")
public class QuestionManageServlet extends HttpServlet {
    private QuestionDao questionDao = new QuestionDao();

    /**
     * GET 请求：处理查询列表和删除逻辑
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String method = request.getParameter("method");

        if ("delete".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            questionDao.delete(id);
            response.sendRedirect("questionManage");
            return;
        }

        List<Question> list = questionDao.getAllQuestions();
        request.setAttribute("qList", list);
        request.getRequestDispatcher("question_list.jsp").forward(request, response);
    }

    /**
     * POST 请求：处理新增题目逻辑
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 防止中文乱码
        request.setCharacterEncoding("UTF-8");

        // 2. 接收表单参数
        String text = request.getParameter("questionText");
        String optA = request.getParameter("optionA");
        String typeA = request.getParameter("optionAType");
        String optB = request.getParameter("optionB");
        String typeB = request.getParameter("optionBType");

        // 3. 封装为 Question 模型对象
        Question q = new Question();
        q.setQuestionText(text);
        q.setOptionA(optA);
        q.setOptionAType(typeA);
        q.setOptionB(optB);
        q.setOptionBType(typeB);

        // 4. 调用 DAO 写入数据库
        questionDao.add(q);

        // 5. 重定向回管理页面，刷新列表显示新题目
        response.sendRedirect("questionManage");
    }
}