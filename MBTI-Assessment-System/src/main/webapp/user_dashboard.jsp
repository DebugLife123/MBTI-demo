<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的主页 - MBTI</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="home"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar">
            <div class="text-muted">
                欢迎回来, <strong>${sessionScope.loginUser.realName}</strong>
                <a href="index.jsp" class="btn btn-sm btn-outline-danger ms-3">退出登录</a>
            </div>
        </div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">🏠 我的控制台</h3>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-body p-4">
                            <h5 class="fw-bold border-bottom pb-2 mb-3">👤 个人资料</h5>
                            <div class="d-flex align-items-center mb-3">
                                <c:set var="avatarSrc" value="${empty sessionScope.loginUser.avatar ? 'https://api.dicebear.com/7.x/adventurer/svg?seed=' += sessionScope.loginUser.username : sessionScope.loginUser.avatar}" />
                                <img src="${avatarSrc}" class="rounded-circle me-3 border shadow-sm" style="width: 60px; height: 60px; object-fit: cover;">
                                <div>
                                    <h5 class="mb-0 fw-bold">${sessionScope.loginUser.realName}</h5>
                                    <span class="badge bg-secondary">学生</span>
                                </div>
                            </div>
                            <p class="mb-2 text-muted"><strong>登录账号：</strong> ${sessionScope.loginUser.username}</p>
                            <p class="mb-2 text-muted"><strong>真实姓名：</strong> ${sessionScope.loginUser.realName}</p>
                            <p class="mb-2 text-muted"><strong>用户角色：</strong> 学生</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 bg-primary text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;">
                        <div class="card-body p-4 d-flex flex-column justify-content-center align-items-center text-center">
                            <h4 class="fw-bold mb-3">准备好探索你自己了吗？</h4>
                            <p class="mb-4">完成精选测试题，获取深度的职业性格解析报告。</p>
                            <a href="startTest" class="btn btn-light btn-lg rounded-pill px-5 fw-bold text-primary shadow">立即开始测试 🚀</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>