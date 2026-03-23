<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>注册 - MBTI 测试系统</title>
  <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <link href="static/css/style.css" rel="stylesheet">

  <style>
    .navbar { display: none !important; }

    .glass-input {
      background: rgba(255, 255, 255, 0.2) !important;
      border: 1px solid rgba(255, 255, 255, 0.4) !important;
      color: #333 !important;
      border-radius: 10px !important;
      padding: 12px 15px !important;
    }
    .glass-input::placeholder { color: rgba(50, 50, 50, 0.6) !important; }
    .glass-input:focus {
      background: rgba(255, 255, 255, 0.4) !important;
      border-color: #fff !important;
      box-shadow: 0 0 10px rgba(255, 255, 255, 0.5) !important;
    }

    .bottom-link {
      color: rgba(50, 50, 50, 0.8);
      text-decoration: none;
      font-size: 0.95rem;
      transition: 0.3s;
      display: inline-block;
    }
    .bottom-link:hover {
      color: #000;
      transform: translateX(-3px); /* 返回登录是向左箭头，所以悬停向左微移 */
    }
  </style>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="dynamic-fluid-bg"></div>

<div class="container m-0 p-0" style="max-width: 100%;">
  <div class="row min-vh-100 align-items-center justify-content-center m-0">
    <div class="col-12 col-sm-8 col-md-6 col-lg-4">

      <div class="text-center mb-4">
        <a href="index.jsp" class="text-decoration-none fs-4 fw-bold" style="color: #333; text-shadow: 0 2px 4px rgba(255,255,255,0.5);">🧩 MBTI 测评系统</a>
      </div>

      <div class="glass-form-card">
        <div class="text-center mb-4">
          <h3 class="fw-bold" style="letter-spacing: 2px; color: #333;">创建新账户</h3>
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
            <div class="alert alert-danger py-2 text-center small bg-danger bg-opacity-25 border-danger">${requestScope.errorMsg}</div>
          </c:if>

          <button type="submit" class="btn btn-primary w-100 mb-4 shadow" style="border-radius: 10px; padding: 12px; font-weight: bold; letter-spacing: 2px;">立即注册</button>

          <div class="text-start">
            <a href="index.jsp" class="bottom-link">
              <span style="font-weight: bold; font-size: 1.1rem; margin-right: 5px; color: #1cc88a;">⬅</span> 已有账号，去登录
            </a>
          </div>
        </form>
      </div>

    </div>
  </div>
</div>
</body>
</html>