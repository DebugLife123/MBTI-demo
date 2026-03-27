<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - 科技版 MBTI 测评系统</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">

    <style>
        /* 隐藏原有的导航栏背景，让整体更沉浸 */
        .navbar { display: none !important; }

        /* --- 科技感主题专属 CSS --- */
        :root {
            --neon-cyan: #0df;
            --bg-dark: #040814;
            --panel-bg: rgba(10, 20, 40, 0.6);
        }

        body.tech-theme {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: var(--bg-dark);
            /* 模拟网格与霓虹光晕背景 */
            background-image:
                    radial-gradient(circle at 15% 50%, rgba(0, 221, 255, 0.15), transparent 30%),
                    radial-gradient(circle at 85% 30%, rgba(176, 0, 255, 0.15), transparent 30%),
                    linear-gradient(rgba(0, 221, 255, 0.03) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(0, 221, 255, 0.03) 1px, transparent 1px);
            background-size: 100% 100%, 100% 100%, 30px 30px, 30px 30px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #fff;
        }

        .tech-card {
            background: var(--panel-bg);
            width: 400px;
            padding: 40px;
            border-radius: 16px;
            border: 1px solid rgba(0, 221, 255, 0.4);
            box-shadow: 0 0 20px rgba(0, 221, 255, 0.2), inset 0 0 15px rgba(0, 221, 255, 0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
            z-index: 10;
        }

        .tech-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 2px;
            background: linear-gradient(90deg, transparent, var(--neon-cyan), transparent);
        }

        .avatar-glow {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            border: 2px solid var(--neon-cyan);
            box-shadow: 0 0 15px var(--neon-cyan);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 35px;
            color: var(--neon-cyan);
        }

        .tech-card h2 {
            text-align: center;
            color: var(--neon-cyan);
            font-size: 22px;
            letter-spacing: 2px;
            margin-bottom: 30px;
            text-shadow: 0 0 10px var(--neon-cyan);
            text-transform: uppercase;
        }

        .tech-input-group {
            position: relative;
            margin-bottom: 25px;
        }

        .tech-input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--neon-cyan);
            font-size: 16px;
        }

        .tech-input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            box-sizing: border-box;
            background: rgba(0, 0, 0, 0.4);
            border: 1px solid rgba(0, 221, 255, 0.3);
            border-radius: 8px;
            color: #fff;
            font-size: 15px;
            outline: none;
            transition: all 0.3s ease;
        }

        .tech-input::placeholder { color: rgba(255, 255, 255, 0.4); }

        .tech-input:focus {
            border-color: var(--neon-cyan);
            box-shadow: 0 0 10px rgba(0, 221, 255, 0.3), inset 0 0 5px rgba(0, 221, 255, 0.2);
            background: rgba(0, 0, 0, 0.6);
        }

        .tech-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, transparent, rgba(0, 221, 255, 0.15), transparent);
            border: 1px solid var(--neon-cyan);
            border-radius: 8px;
            color: var(--neon-cyan);
            font-size: 16px;
            font-weight: bold;
            letter-spacing: 4px;
            cursor: pointer;
            text-transform: uppercase;
            transition: all 0.3s ease;
            box-shadow: 0 0 10px rgba(0, 221, 255, 0.1);
            margin-bottom: 15px;
        }

        .tech-btn:hover {
            background: var(--neon-cyan);
            color: var(--bg-dark);
            box-shadow: 0 0 20px var(--neon-cyan);
        }

        .tech-links { text-align: right; }
        .tech-links a {
            color: rgba(255, 255, 255, 0.6);
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
        }
        .tech-links a:hover {
            color: var(--neon-cyan);
            text-shadow: 0 0 5px var(--neon-cyan);
        }

        /* 提示信息样式 */
        .msg-success { color: #0f0; text-shadow: 0 0 5px #0f0; font-size: 13px; text-align: center; margin-bottom: 15px; }
        .msg-error { color: #ff3366; text-shadow: 0 0 5px #ff3366; font-size: 13px; text-align: center; margin-bottom: 15px; }
    </style>
</head>
<body class="tech-theme">

<%-- 保留原有 header，里面的 JSTL 环境等可能被其他代码依赖 --%>
<%@ include file="header.jsp" %>

<div class="tech-card">
    <div class="avatar-glow">
        <i class="fas fa-user-astronaut"></i>
    </div>

    <h2>MBTI-职业性格测试</h2>

    <c:if test="${not empty requestScope.successMsg}">
        <div class="msg-success"><i class="fas fa-check-circle"></i> ${requestScope.successMsg}</div>
    </c:if>

    <form action="login" method="post">

        <div class="tech-input-group">
            <i class="fas fa-terminal"></i>
            <input type="text" name="username" class="tech-input" placeholder="Username / 账号" required autocomplete="off">
        </div>

        <div class="tech-input-group">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" class="tech-input" placeholder="Password / 密码" required>
        </div>

        <c:if test="${not empty requestScope.errorMsg}">
            <div class="msg-error"><i class="fas fa-exclamation-triangle"></i> ${requestScope.errorMsg}</div>
        </c:if>

        <button type="submit" class="tech-btn">登 录</button>

        <div class="tech-links">
            <a href="register.jsp">无账号，去注册 <i class="fas fa-arrow-right"></i></a>
        </div>
    </form>
</div>

</body>
</html>