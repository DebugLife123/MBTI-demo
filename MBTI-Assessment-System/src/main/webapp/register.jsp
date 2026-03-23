<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>注册 - MBTI 测试系统</title>
  <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .navbar { display: none !important; }

    body {
      background: linear-gradient(-45deg, #e66465, #9198e5, #f68084, #a6c0fe);
      background-size: 400% 400%;
      animation: gradientBG 15s ease infinite;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Noto Sans SC', sans-serif;
      margin: 0;
      position: relative;
    }

    @keyframes gradientBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    .floating-header {
      position: absolute;
      top: 30px;
      left: 40px;
      color: white;
      font-size: 1.5rem;
      font-weight: bold;
      text-decoration: none;
      text-shadow: 0 2px 4px rgba(0,0,0,0.2);
      letter-spacing: 1px;
      transition: 0.3s opacity;
    }
    .floating-header:hover { color: white; opacity: 0.8; }

    .glass-card {
      background: rgba(255, 255, 255, 0.15) !important;
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
      border-radius: 20px !important;
      border: 1px solid rgba(255, 255, 255, 0.3) !important;
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2) !important;
      color: white !important;
      width: 100%;
      max-width: 450px;
      padding: 40px 30px;
    }

    .glass-input {
      background: rgba(255, 255, 255, 0.1) !important;
      border: 1px solid rgba(255, 255, 255, 0.4) !important;
      color: white !important;
      border-radius: 10px !important;
      padding: 12px 15px !important;
    }

    .glass-input::placeholder { color: rgba(255, 255, 255, 0.7) !important; }
    .glass-input:focus {
      background: rgba(255, 255, 255, 0.25) !important;
      border-color: white !important;
      box-shadow: none !important;
    }

    .glass-btn {
      background: linear-gradient(to right, #1cc88a, #36b9cc) !important; /* 注册按钮换成清新的青绿色系区分登录 */
      border: none !important;
      border-radius: 10px !important;
      color: white !important;
      font-weight: bold;
      letter-spacing: 2px;
      padding: 12px;
      transition: 0.3s;
    }
    .glass-btn:hover { opacity: 0.9; transform: translateY(-2px); color: white !important; }

    .bottom-link {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      font-size: 0.95rem;
      transition: 0.3s;
      display: inline-block;
    }
    .bottom-link:hover {
      color: white;
      transform: translateX(-3px); /* 注册页是向左返回，所以动效向左偏 */
    }
  </style>
</head>
<body>
<%@ include file="header.jsp" %>

<a href="index.jsp" class="floating-header">🧩 MBTI 测评系统</a>

<div class="card glass-card">
  <div class="text-center mb-4">
    <h3 class="fw-bold" style="letter-spacing: 2px; text-shadow: 0 2px 4px rgba(0,0,0,0.2);">创建新账户</h3>
  </div>

  <form action="register" method="post">
    <div class="mb-4">
      <input type="text" name="username" class="form-control glass-input" placeholder="👤 设置登录账号 (如: lisi)" required>
    </div>
    <div class="mb-4">
      <input type="password" name="password" class="form-control glass-input" placeholder="🔒 设置登录密码" required>
    </div>
    <div class="mb-4">
      <input type="text" name="realName" class="form-control glass-input" placeholder="📝 您的真实姓名 (用于报告)" required>
    </div>

    <c:if test="${not empty requestScope.errorMsg}">
      <div class="alert alert-danger py-2 text-center small bg-danger bg-opacity-25 border-danger text-white">${requestScope.errorMsg}</div>
    </c:if>

    <button type="submit" class="btn glass-btn w-100 mb-4">立即注册</button>

    <div class="text-start">
      <a href="index.jsp" class="bottom-link">
        <span style="color: #1cc88a; font-weight: bold; font-size: 1.1rem; margin-right: 5px;">⬅</span> 已有账号，去登录
      </a>
    </div>
  </form>
</div>
</body>
</html>