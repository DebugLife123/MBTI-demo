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
 * 支持：全网记录分页/列表展示、查看他人报告、删除异常记录
 */
@WebServlet("/recordManage")
public class RecordManageServlet extends HttpServlet {

    private AdminDao adminDao = new AdminDao();
    private TestRecordDao recordDao = new TestRecordDao();
    private PersonalityDao personalityDao = new PersonalityDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 安全检查：确保只有管理员能操作
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. 获取操作标识 (method)
        String method = request.getParameter("method");

        if ("delete".equals(method)) {
            // --- 功能 A：删除记录 ---
            handleDelete(request, response);
        } else if ("view".equals(method)) {
            // --- 功能 B：查看报告详情 ---
            doViewReport(request, response);
        } else {
            // --- 默认：展示列表首页 ---
            showList(request, response);
        }
    }

    /**
     * 展示全网测试记录列表
     */
    private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取所有用户的测试统计记录 (多表关联查询)
        List<Map<String, Object>> logs = adminDao.getAllTestLogs();
        request.setAttribute("logs", logs);
        // 转发至新创建的概览页面
        request.getRequestDispatcher("record_list.jsp").forward(request, response);
    }

    /**
     * 查看特定测试记录的详细报告 (复用结果页展示逻辑)
     */
    private void doViewReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));

            // 1) 从数据库查出该条记录的具体分数
            // 注意：这里需要调用一个不校验 userId 的查询方法，或者在 DAO 中新增 adminGetRecordById
            TestRecord record = recordDao.getRecordById(recordId);

            if (record != null) {
                // 2) 根据记录的性格代码 (如 INTJ) 获取解析文案
                Personality p = personalityDao.getByTypeCode(record.getResultType());

                // 3) 封装结果并转发至 result.jsp
                // 这样管理员看到的界面和学生看到的一模一样，实现代码高度复用
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

    /**
     * 执行记录删除逻辑
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            // 调用 DAO 执行物理删除 (需要在 TestRecordDao 中补充此方法)
            recordDao.delete(recordId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 删除后刷新列表
        response.sendRedirect("recordManage");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}