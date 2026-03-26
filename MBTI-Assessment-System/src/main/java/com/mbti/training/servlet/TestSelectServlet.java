package com.mbti.training.servlet;

import com.mbti.training.dao.AssessmentTypeDao;
import com.mbti.training.model.AssessmentType;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/testSelect")
public class TestSelectServlet extends HttpServlet {
    private AssessmentTypeDao dao = new AssessmentTypeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 查询所有状态为“在用 (1)”的考核类型
        List<AssessmentType> activeTypes = dao.getActive();
        request.setAttribute("activeTypes", activeTypes);
        request.getRequestDispatcher("test_select.jsp").forward(request, response);
    }
}