package com.mbti.training.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/aiAnalysisServlet")
public class AIAnalysisServlet extends HttpServlet {

    // 💡 替换为你真实的 API KEY (和 ChatServlet 保持一致)
    private static final String API_KEY = "sk-f03356c848d74b2486cd5b0c80fb6cf9";
    private static final String API_URL = "https://api.deepseek.com/chat/completions";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        // 获取前端传过来的选中的 MBTI 类型字符串 (例如："INTJ,ENFP,ISTJ,ESTP")
        String mbtiTypes = request.getParameter("types");
        if (mbtiTypes == null || mbtiTypes.trim().isEmpty()) {
            response.getWriter().write("未接收到有效的 MBTI 数据，请重新选择。");
            return;
        }

        try {
            // 🌟 核心：专门为“团队分析”定制的 Prompt
            String systemPrompt = "你是一位资深的组织行为学专家和MBTI团队分析顾问。我会给你一批团队成员的MBTI测试结果。请你基于这些数据：1.总结该团队的整体性格倾向和氛围；2.指出潜在的沟通冲突点或短板；3.给出3条切实可行的团队管理与协作建议。排版要求清晰，使用小标题。";
            String userPrompt = "这是本批次选中的参测人员的MBTI类型列表：" + mbtiTypes + "。请为我出具一份团队画像分析报告。";

            String payload = "{\n" +
                    "  \"model\": \"deepseek-chat\",\n" +
                    "  \"messages\": [\n" +
                    "    {\"role\": \"system\", \"content\": \"" + systemPrompt + "\"},\n" +
                    "    {\"role\": \"user\", \"content\": \"" + userPrompt + "\"}\n" +
                    "  ]\n" +
                    "}";

            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.getBytes("UTF-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            InputStream inputStream = (responseCode >= 200 && responseCode < 300) ? conn.getInputStream() : conn.getErrorStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
            StringBuilder respStr = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) { respStr.append(line); }
            String result = respStr.toString();

            if (responseCode != 200) {
                response.getWriter().write("AI 请求失败 (状态码: " + responseCode + ")，请检查控制台。");
                return;
            }

            // 防断层解析逻辑
            String contentMarker = "\"content\":\"";
            int startIndex = result.indexOf(contentMarker);
            if (startIndex == -1) {
                contentMarker = "\"content\": \"";
                startIndex = result.indexOf(contentMarker);
            }

            if (startIndex != -1) {
                startIndex += contentMarker.length();
                int endIndex = startIndex;
                while (endIndex < result.length()) {
                    if (result.charAt(endIndex) == '"' && result.charAt(endIndex - 1) != '\\') break;
                    endIndex++;
                }
                if (endIndex > startIndex) {
                    String finalAnswer = result.substring(startIndex, endIndex)
                            .replace("\\n", "\n")
                            .replace("\\\"", "\"")
                            .replace("\\r", "");
                    response.getWriter().write(finalAnswer);
                } else {
                    response.getWriter().write("解析为空。");
                }
            } else {
                response.getWriter().write("数据格式不匹配。");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("网络连接异常，请检查服务器控制台。");
        }
    }
}