package com.mbti.training.servlet;

import com.mbti.training.dao.DimensionDao;
import com.mbti.training.model.Question;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.mbti.training.model.Dimension;

@WebServlet("/dimensionManage")
public class DimensionManageServlet extends HttpServlet {
    private DimensionDao dimDao = new DimensionDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String method = req.getParameter("method");
        if ("delete".equals(method)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dimDao.delete(id);
            resp.sendRedirect("dimensionManage");
            return;
        }
        // 默认展示列表
        req.setAttribute("dimList", dimDao.getAllDimensions());
        req.getRequestDispatcher("dimension_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id"); // 用于区分是新增还是修改

        Dimension d = new Dimension();
        d.setDimName(req.getParameter("dimName"));
        d.setDescription(req.getParameter("description"));

        if (idStr == null || idStr.isEmpty()) {
            dimDao.add(d); // 新增
        } else {
            d.setId(Integer.parseInt(idStr));
            dimDao.update(d); // 修改
        }
        resp.sendRedirect("dimensionManage");
    }
}