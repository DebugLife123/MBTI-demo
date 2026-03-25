package com.mbti.training.servlet;

import com.mbti.training.dao.AdminDao;
import com.mbti.training.dao.TestRecordDao;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 管理员看板控制器
 * 负责聚合首页所需的统计数据、图表数据及测试记录列表
 */
@WebServlet("/adminManage")
public class AdminDashboardServlet extends HttpServlet {

    private AdminDao adminDao = new AdminDao();
    private TestRecordDao recordDao = new TestRecordDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 安全检查：确保只有管理员能进入
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. 获取表格数据：全校所有学生的测试记录
        List<Map<String, Object>> logs = adminDao.getAllTestLogs();
        request.setAttribute("logs", logs);

        // 3. 获取图表统计数据：计算 8 个维度的全网平均分
        // 调用我们之前在 TestRecordDao 中新增的统计方法
        Map<String, Double> dimAvgs = recordDao.getDimensionAverages();

        // 4. 将统计结果塞进 Request 域，供 ECharts 渲染使用
        if (dimAvgs != null && !dimAvgs.isEmpty()) {
            request.setAttribute("eAvg", dimAvgs.get("e"));
            request.setAttribute("iAvg", dimAvgs.get("i"));
            request.setAttribute("sAvg", dimAvgs.get("s"));
            request.setAttribute("nAvg", dimAvgs.get("n"));
            request.setAttribute("tAvg", dimAvgs.get("t"));
            request.setAttribute("fAvg", dimAvgs.get("f"));
            request.setAttribute("jAvg", dimAvgs.get("j"));
            request.setAttribute("pAvg", dimAvgs.get("p"));
        } else {
            // 如果没有数据，默认给 0，防止 JSP 表达式报错
            request.setAttribute("eAvg", 0.0);
            request.setAttribute("iAvg", 0.0);
            request.setAttribute("sAvg", 0.0);
            request.setAttribute("nAvg", 0.0);
            request.setAttribute("tAvg", 0.0);
            request.setAttribute("fAvg", 0.0);
            request.setAttribute("jAvg", 0.0);
            request.setAttribute("pAvg", 0.0);
        }

        // 5. 转发到管理员看板 JSP 页面
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 通常看板首页只涉及展示，如果有复杂的统计筛选，可以在此处扩展
        doGet(request, response);
    }
}