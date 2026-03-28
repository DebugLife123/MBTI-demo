package com.mbti.training.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/chatServlet")
public class ChatServlet extends HttpServlet {

    // 💡 替换为你申请的 API KEY (推荐去 DeepSeek 申请，便宜且好用)
    private static final String API_KEY = "sk-f03356c848d74b2486cd5b0c80fb6cf9";
    // DeepSeek 的接口地址
    private static final String API_URL = "https://api.deepseek.com/chat/completions";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.getWriter().write("请说点什么吧~");
            return;
        }

        try {
            // 1. 构造发给大模型的 JSON 数据 (手动拼凑，不引入额外依赖，保持纯净)
            // 设定了 System Prompt，让 AI 扮演专业的 MBTI 咨询师
            String payload = "{\n" +
                    "  \"model\": \"deepseek-chat\",\n" +
                    "  \"messages\": [\n" +
                    "    {\"role\": \"system\", \"content\": \"你是一位资深的MBTI性格分析师与职业规划师。请用专业、温暖、客观的语气回答问题，不要啰嗦，给出实用的建议。\"},\n" +
                    "    {\"role\": \"user\", \"content\": \"" + userMessage.replace("\"", "\\\"").replace("\n", " ") + "\"}\n" +
                    "  ]\n" +
                    "}";

            // 2. 发起 HTTP 请求
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

            // 3. 读取 AI 的回复
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder respStr = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                respStr.append(line);
            }

            // 4. 极简提取内容：用土办法截取 JSON 里的 content 字段，避免引入复杂的 JSON 库
            String result = respStr.toString();
            String contentMarker = "\"content\":\"";
            int startIndex = result.indexOf(contentMarker);
            if (startIndex != -1) {
                startIndex += contentMarker.length();
                int endIndex = result.indexOf("\"", startIndex);
                // 找到 content 后，处理一下转义字符（比如 \n 和 \"）
                String finalAnswer = result.substring(startIndex, endIndex)
                        .replace("\\n", "\n")
                        .replace("\\\"", "\"");
                response.getWriter().write(finalAnswer);
            } else {
                response.getWriter().write("AI 暂时短路了，没听懂我的指令。");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("抱歉，我的网络连接似乎出了点问题。");
        }
    }
}