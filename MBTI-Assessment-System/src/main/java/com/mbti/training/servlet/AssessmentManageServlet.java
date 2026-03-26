package com.mbti.training.servlet;

import com.mbti.training.dao.AssessmentTypeDao;
import com.mbti.training.model.AssessmentType;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/assessmentManage")
public class AssessmentManageServlet extends HttpServlet {
    private AssessmentTypeDao dao = new AssessmentTypeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String method = request.getParameter("method");

        // --- 删除逻辑 ---
        if ("delete".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
            response.sendRedirect("assessmentManage"); // 删除后刷新列表
            return;
        }

        // --- 默认：展示列表 ---
        request.setAttribute("typeList", dao.getAll());
        request.getRequestDispatcher("assessment_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String typeName = request.getParameter("typeName");
        String statusStr = request.getParameter("status");
        String priceStr = request.getParameter("price");

        AssessmentType type = new AssessmentType();
        type.setTypeName(typeName);
        type.setStatus(Integer.parseInt(statusStr));
        type.setPrice(Double.parseDouble(priceStr));

        // 如果传过来的 ID 是空的，说明是“新增”；如果有 ID，说明是“修改”
        if (idStr == null || idStr.trim().isEmpty()) {
            dao.add(type);
        } else {
            type.setId(Integer.parseInt(idStr));
            dao.update(type);
        }

        // 处理完数据后，重定向回列表页刷新显示
        response.sendRedirect("assessmentManage");
    }
}