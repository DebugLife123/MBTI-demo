<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://lf3-cdn-tos.bytecdntp.com/cdn/expire-1-M/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
<link href="https://gs.jurieo.com/gemini/fonts-googleapis/css2?family=Noto+Sans+SC:wght@300;400;700&display=swap" rel="stylesheet">

<style>
  body {
    font-family: 'Noto Sans SC', sans-serif;
    background-color: #f8f9fa;
  }
  .navbar {
    margin-bottom: 30px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  }
  .navbar-brand {
    font-weight: 700;
    letter-spacing: 1px;
  }
  .user-tag {
    background: rgba(255,255,255,0.2);
    padding: 5px 15px;
    border-radius: 20px;
    font-size: 0.9rem;
  }
</style>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">🧩 MBTI 测评系统</a>

    <div class="ms-auto d-flex align-items-center">
      <%-- 使用 JSTL 或 EL 表达式显示用户名 --%>
      <c:if test="${not empty sessionScope.currUser}">
                <span class="user-tag text-white">
                    👤 当前用户：<strong>${sessionScope.currUser}</strong>
                </span>
        <a href="index.jsp" class="btn btn-sm btn-outline-light ms-3">退出</a>
      </c:if>
    </div>
  </div>
</nav>

<script src="https://lf3-cdn-tos.bytecdntp.com/cdn/expire-1-M/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>