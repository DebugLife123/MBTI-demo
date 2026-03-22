<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MBTI 测试系统 - Demo</title>
    <link href="https://lf3-cdn-tos.bytecdntp.com/cdn/expire-1-M/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://gs.jurieo.com/gemini/fonts-googleapis/css2?family=Noto+Sans+SC:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans SC', sans-serif; background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
        .btn-primary { border-radius: 10px; padding: 10px 25px; }
    </style>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container mt-5 text-center">
    <div class="card shadow-sm p-5">
        <h1 class="text-primary mb-4">🎉 Hello World!</h1>
        <p class="lead">你好，组长！你的 Tomcat 和 Bootstrap 配置成功啦！</p>
        <div class="card shadow-sm p-5 text-center">
            <h1 class="text-primary mb-4">MBTI 测评系统</h1>
            <form action="hello" method="get">
                <div class="mb-3">
                    <input type="text" name="username" class="form-control" placeholder="请输入你的姓名" required>
                </div>
                <button type="submit" class="btn btn-success">进入系统</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>