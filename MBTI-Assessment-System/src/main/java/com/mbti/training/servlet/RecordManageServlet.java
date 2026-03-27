package com.mbti.training.servlet;

import com.mbti.training.dao.AdminDao;
import com.mbti.training.dao.PersonalityDao;
import com.mbti.training.dao.TestRecordDao;
import com.mbti.training.model.Personality;
import com.mbti.training.model.SysUser;
import com.mbti.training.model.TestRecord;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 管理员 - 测试记录管理控制器
 * 支持：全网记录分页/列表展示、模糊搜索、查看他人报告、删除异常记录
 */
@WebServlet("/recordManage")
public class RecordManageServlet extends HttpServlet {

    private AdminDao adminDao = new AdminDao();
    private TestRecordDao recordDao = new TestRecordDao();
    private PersonalityDao personalityDao = new PersonalityDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String method = request.getParameter("method");

        if ("delete".equals(method)) {
            handleDelete(request, response);
        } else if ("view".equals(method)) {
            doViewReport(request, response);
        } else {
            showList(request, response);
        }
    }

    /**
     * 🌟 展示全网测试记录列表 (含搜索与分页)
     */
    private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String pageStr = request.getParameter("page");

        int page = 1;
        int pageSize = 10; // 每页显示 10 条记录

        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }

        int offset = (page - 1) * pageSize;

        // 1. 获取总记录数和计算总页数
        int totalCount = adminDao.getTestLogCount(keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // 2. 获取当前页的数据
        List<Map<String, Object>> logs = adminDao.getTestLogsByPage(keyword, offset, pageSize);

        // 3. 将数据放入 request 作用域
        request.setAttribute("logs", logs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("totalCount", totalCount);

        request.getRequestDispatcher("record_list.jsp").forward(request, response);
    }

    private void doViewReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            TestRecord record = recordDao.getRecordById(recordId);

            if (record != null) {
                Personality p = personalityDao.getByTypeCode(record.getResultType());
                request.setAttribute("myResult", record.getResultType());
                request.setAttribute("scores", record);
                request.setAttribute("personality", p);
                request.getRequestDispatcher("result.jsp").forward(request, response);
            } else {
                response.sendRedirect("recordManage");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("recordManage");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            recordDao.delete(recordId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("recordManage");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}