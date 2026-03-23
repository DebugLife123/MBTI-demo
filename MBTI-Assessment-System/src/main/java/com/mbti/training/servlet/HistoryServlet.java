package com.mbti.training.servlet;

import com.mbti.training.dao.TestRecordDao;
import com.mbti.training.model.SysUser;
import com.mbti.training.model.TestRecord;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.mbti.training.dao.PersonalityDao;
import com.mbti.training.model.Personality;

@WebServlet("/history")
public class HistoryServlet extends HttpServlet {
    private TestRecordDao recordDao = new TestRecordDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 获取当前登录用户
        SysUser loginUser = (SysUser) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. 判断是否是删除请求
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int recordId = Integer.parseInt(request.getParameter("id"));
                // 安全删除：传入记录ID和当前登录用户的ID
                recordDao.deleteUserRecord(recordId, loginUser.getId());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            // 删除完成后，重定向回历史记录列表页
            response.sendRedirect("history");
            return;
        }
        // --- 🌟 2. 新增：处理查看报告逻辑 ---
        else if ("view".equals(action)) {
            try {
                int recordId = Integer.parseInt(request.getParameter("id"));
                // 1) 查出具体的历史记录分数
                TestRecord record = recordDao.getRecordById(recordId, loginUser.getId());

                if (record != null) {
                    // 2) 根据历史记录的 MBTI 类型，查出性格解析详情
                    PersonalityDao personalityDao = new PersonalityDao();
                    Personality personality = personalityDao.getByTypeCode(record.getResultType());

                    // 3) 按照 result.jsp 需要的格式，把数据塞进 Request
                    request.setAttribute("myResult", record.getResultType());
                    request.setAttribute("scores", record);
                    request.setAttribute("personality", personality);

                    // 4) 华丽的复用：直接转发给 result.jsp 展示！
                    request.getRequestDispatcher("result.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            // 如果查不到记录，退回历史列表页
            response.sendRedirect("history");
            return;
        }

        // 3. 默认逻辑：获取历史记录列表
        List<TestRecord> myRecords = recordDao.getRecordsByUserId(loginUser.getId());
        request.setAttribute("records", myRecords);
        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
}