<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>注册 - 科技版 MBTI 测试系统</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link href="static/css/style.css" rel="stylesheet">

  <style>
    .navbar { display: none !important; }

    :root {
      --neon-purple: #b0f;
      --bg-dark: #040814;
      --panel-bg: rgba(10, 20, 40, 0.6);
    }

    body.tech-theme {
      margin: 0; padding: 0; min-height: 100vh;
      display: flex; justify-content: center; align-items: center;
      background-color: var(--bg-dark);
      background-image:
              radial-gradient(circle at 15% 50%, rgba(176, 0, 255, 0.15), transparent 30%),
              radial-gradient(circle at 85% 30%, rgba(0, 221, 255, 0.15), transparent 30%),
              linear-gradient(rgba(176, 0, 255, 0.03) 1px, transparent 1px),
              linear-gradient(90deg, rgba(176, 0, 255, 0.03) 1px, transparent 1px);
      background-size: 100% 100%, 100% 100%, 30px 30px, 30px 30px;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color: #fff;
    }

    .tech-card {
      background: var(--panel-bg);
      width: 420px;
      padding: 35px 40px;
      border-radius: 16px;
      border: 1px solid rgba(176, 0, 255, 0.4);
      box-shadow: 0 0 20px rgba(176, 0, 255, 0.2), inset 0 0 15px rgba(176, 0, 255, 0.1);
      backdrop-filter: blur(10px);
      position: relative;
      z-index: 10;
    }

    .tech-card::before {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
      background: linear-gradient(90deg, transparent, var(--neon-purple), transparent);
    }

    .avatar-glow {
      width: 70px; height: 70px; margin: 0 auto 15px;
      border-radius: 50%;
      border: 2px solid var(--neon-purple);
      box-shadow: 0 0 15px var(--neon-purple);
      display: flex; justify-content: center; align-items: center;
      font-size: 30px; color: var(--neon-purple);
    }

    .tech-card h2 {
      text-align: center; color: var(--neon-purple); font-size: 20px;
      letter-spacing: 2px; margin-bottom: 25px;
      text-shadow: 0 0 10px var(--neon-purple); text-transform: uppercase;
    }

    .tech-input-group { position: relative; margin-bottom: 20px; }
    .tech-input-group i {
      position: absolute; left: 15px; top: 50%; transform: translateY(-50%);
      color: var(--neon-purple); font-size: 16px;
    }

    .tech-input {
      width: 100%; padding: 12px 15px 12px 45px; box-sizing: border-box;
      background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(176, 0, 255, 0.3);
      border-radius: 8px; color: #fff; font-size: 14px; outline: none;
      transition: all 0.3s ease;
    }

    /* 下拉菜单专门处理黑色背景 */
    select.tech-input option { background: #040814; color: #fff; }

    .tech-input::placeholder { color: rgba(255, 255, 255, 0.4); }
    .tech-input:focus {
      border-color: var(--neon-purple);
      box-shadow: 0 0 10px rgba(176, 0, 255, 0.3), inset 0 0 5px rgba(176, 0, 255, 0.2);
      background: rgba(0, 0, 0, 0.6);
    }

    .tech-btn {
      width: 100%; padding: 14px;
      background: linear-gradient(90deg, transparent, rgba(176, 0, 255, 0.15), transparent);
      border: 1px solid var(--neon-purple); border-radius: 8px;
      color: var(--neon-purple); font-size: 16px; font-weight: bold; letter-spacing: 2px;
      cursor: pointer; transition: all 0.3s ease; margin-bottom: 15px;
    }
    .tech-btn:hover { background: var(--neon-purple); color: #fff; box-shadow: 0 0 20px var(--neon-purple); }

    .tech-links { text-align: left; }
    .tech-links a { color: rgba(255, 255, 255, 0.6); text-decoration: none; font-size: 14px; transition: color 0.3s; }
    .tech-links a:hover { color: var(--neon-purple); text-shadow: 0 0 5px var(--neon-purple); }
    .msg-error { color: #ff3366; text-shadow: 0 0 5px #ff3366; font-size: 13px; text-align: center; margin-bottom: 15px; }
  </style>
</head>
<body class="tech-theme">

<%@ include file="header.jsp" %>

<div class="tech-card">
  <div class="avatar-glow">
    <i class="fas fa-fingerprint"></i>
  </div>

  <h2>MBTI-新用户注册</h2>

  <form action="register" method="post">

    <div class="tech-input-group">
      <i class="fas fa-user"></i>
      <input type="text" name="username" class="tech-input" placeholder="设置登录账号 (如: lisi)" required>
    </div>

    <div class="tech-input-group">
      <i class="fas fa-key"></i>
      <input type="password" name="password" class="tech-input" placeholder="设置登录密码" required>
    </div>

    <div class="tech-input-group">
      <i class="fas fa-id-card"></i>
      <input type="text" name="realName" class="tech-input" placeholder="您的真实姓名 (用于报告)" required>
    </div>

    <div class="tech-input-group">
      <i class="fas fa-user-tag"></i>
      <select name="role" class="tech-input" required>
        <option value="" disabled selected>选择您的身份</option>
        <option value="STUDENT">学生</option>
        <option value="TEACHER">教师</option>
      </select>
    </div>

    <c:if test="${not empty requestScope.errorMsg}">
      <div class="msg-error"><i class="fas fa-exclamation-triangle"></i> ${requestScope.errorMsg}</div>
    </c:if>

    <button type="submit" class="tech-btn">立即注册</button>

    <div class="tech-links">
      <a href="index.jsp"><i class="fas fa-arrow-left"></i> 已有账号，去登录</a>
    </div>
  </form>
</div>

</body>
</html>