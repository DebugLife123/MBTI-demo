<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 必须在第一行或第二行加入这个声明，否则 <c:if> 等标签无法生效 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { font-family: 'Noto Sans SC', sans-serif; background-color: #f8f9fa; }
    .navbar { box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
    .user-tag { background: rgba(255,255,255,0.2); padding: 5px 15px; border-radius: 20px; font-size: 0.9rem; border: 1px solid rgba(255,255,255,0.3); }
</style>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">🧩 MBTI职业性格测评系统</a>

        <div class="ms-auto d-flex align-items-center">
            <c:if test="${not empty sessionScope.loginUser}">
                <div class="user-tag text-white">
                    👤 欢迎：<strong>${sessionScope.loginUser.realName}</strong>
                    <span class="badge bg-light text-dark ms-1">
                        <c:choose>
                            <c:when test="${sessionScope.loginUser.role == 'ADMIN'}">管理员</c:when>
                            <c:when test="${sessionScope.loginUser.role == 'TEACHER'}">教师</c:when>
                            <c:otherwise>学生</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <a href="index.jsp" class="btn btn-sm btn-outline-light ms-3">退出</a>
            </c:if>
        </div>
    </div>
</nav>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>