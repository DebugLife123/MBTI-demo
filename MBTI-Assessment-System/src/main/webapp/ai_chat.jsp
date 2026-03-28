<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>问问 AI - MBTI 专属咨询师</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
    <style>
        .chat-container { height: 65vh; overflow-y: auto; padding: 20px; background: rgba(255,255,255,0.5); border-radius: 15px; }
        .chat-bubble { max-width: 80%; padding: 12px 18px; border-radius: 20px; margin-bottom: 15px; line-height: 1.5; }
        .user-msg { background-color: #0d6efd; color: white; border-bottom-right-radius: 2px; margin-left: auto; }
        .ai-msg { background-color: #f8f9fa; border: 1px solid #e9ecef; color: #333; border-bottom-left-radius: 2px; margin-right: auto; }
        .typing-indicator { display: none; font-size: 0.9rem; color: #6c757d; margin-bottom: 15px; }
    </style>
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp"><jsp:param name="active" value="aichat"/></jsp:include>

    <div class="main-content">
        <div class="container-fluid p-4 p-md-5">
            <h4 class="fw-bold mb-1">🤖 问问 AI</h4>
            <p class="text-muted mb-4">你的私人 MBTI 心理与职业咨询师。试试问：“作为 INTJ，我该如何缓解社交疲劳？”</p>

            <div class="card border-0 shadow-sm rounded-4 mb-3">
                <div class="chat-container shadow-inner" id="chatBox">
                    <div class="chat-bubble ai-msg shadow-sm">
                        你好！我是你的 MBTI 专属 AI 助手。关于性格解析、职业规划、人际交往，你有什么想问我的吗？
                    </div>
                </div>
            </div>

            <div class="d-flex gap-2">
                <input type="text" id="userInput" class="form-control form-control-lg rounded-pill shadow-sm px-4"
                       placeholder="输入你的问题，按回车发送..." onkeypress="handleEnter(event)">
                <button class="btn btn-primary rounded-pill px-4 shadow-sm" onclick="sendMessage()">
                    发送 🚀
                </button>
            </div>
            <div class="typing-indicator ms-3 mt-2" id="typing">AI 正在飞速思考中... 🤔</div>

        </div>
    </div>
</div>

<script>
    const chatBox = document.getElementById('chatBox');
    const userInput = document.getElementById('userInput');
    const typing = document.getElementById('typing');

    function handleEnter(e) { if (e.key === 'Enter') sendMessage(); }

    function sendMessage() {
        const text = userInput.value.trim();
        if (!text) return;

        // 1. 把用户的话加到界面上
        appendMessage(text, 'user-msg');
        userInput.value = '';
        typing.style.display = 'block'; // 显示思考中
        scrollToBottom();

        // 2. 发送请求给后端 Servlet
        fetch('chatServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'message=' + encodeURIComponent(text)
        })
            .then(response => response.text())
            .then(data => {
                typing.style.display = 'none'; // 隐藏思考中
                appendMessage(data, 'ai-msg'); // 把AI的话加到界面上
                scrollToBottom();
            })
            .catch(err => {
                typing.style.display = 'none';
                appendMessage("哎呀，网络开小差了，请稍后再试！", 'ai-msg text-danger');
            });
    }

    function appendMessage(text, className) {
        const div = document.createElement('div');
        div.className = 'chat-bubble shadow-sm ' + className;
        // 简单处理一下换行符
        div.innerHTML = text.replace(/\n/g, '<br>');
        chatBox.appendChild(div);
    }

    function scrollToBottom() {
        chatBox.scrollTop = chatBox.scrollHeight;
    }
</script>
</body>
</html>