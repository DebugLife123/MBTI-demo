package com.mbti.training.servlet;

import com.mbti.training.dao.QuestionDao;
import com.mbti.training.dao.TestRecordDao;
import com.mbti.training.dao.PersonalityDao;
import com.mbti.training.model.Question;
import com.mbti.training.model.SysUser;
import com.mbti.training.model.TestRecord;
import com.mbti.training.model.Personality;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/submitAnswer")
public class ResultServlet extends HttpServlet {
    private QuestionDao questionDao = new QuestionDao();
    private TestRecordDao recordDao = new TestRecordDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. 获取当前登录用户
        SysUser loginUser = (SysUser) request.getSession().getAttribute("loginUser");

        // 2. 初始化 8 个维度的计数器
        int E=0, I=0, S=0, N=0, T=0, F=0, J=0, P=0;

        // 3. 获取所有题目，遍历对比用户提交的答案
        List<Question> questions = questionDao.getAllQuestions();
        for (Question q : questions) {
            // 拿到页面上 name="q1", "q2" 等对应的 value (E/I/S/N...)
            String answer = request.getParameter("q" + q.getId());
            if (answer != null) {
                switch (answer) {
                    case "E": E++; break; case "I": I++; break;
                    case "S": S++; break; case "N": N++; break;
                    case "T": T++; break; case "F": F++; break;
                    case "J": J++; break; case "P": P++; break;
                }
            }
        }

        // 4. 拼凑 4 位性格代码 (胜者为王逻辑)
        String type = "";
        type += (E >= I) ? "E" : "I";
        type += (S >= N) ? "S" : "N";
        type += (T >= F) ? "T" : "F";
        type += (J >= P) ? "J" : "P";

        // 5. 封装记录并存入数据库
        TestRecord record = new TestRecord();
        record.setUserId(loginUser.getId());
        record.setResultType(type);
        record.seteScore(E); record.setiScore(I);
        record.setsScore(S); record.setnScore(N);
        record.settScore(T); record.setfScore(F);
        record.setjScore(J); record.setpScore(P);
        recordDao.save(record);

        // 1. 实例化 DAO
        PersonalityDao personalityDao = new PersonalityDao();
// 2. 根据算出的 type (如 "ESTJ") 查询解析
        Personality personality = personalityDao.getByTypeCode(type);

// 3. 把结果塞进 Request
        request.setAttribute("myResult", type);
        request.setAttribute("scores", record);
        request.setAttribute("personality", personality); // 新增：把整个解析对象传过去

// 4. 跳转到结果页
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}