<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>个人资料 - MBTI</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp"><jsp:param name="active" value="profile"/></jsp:include>

    <div class="main-content">
        <div class="topbar"><div class="text-muted">当前用户: <strong>${sessionScope.loginUser.realName}</strong></div></div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">👤 个人资料管理</h3>

            <c:if test="${not empty requestScope.successMsg}">
                <div class="alert alert-success">${requestScope.successMsg}</div>
            </c:if>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <form action="profile" method="post" enctype="multipart/form-data">
                        <div class="row">
                            <div class="col-md-4 text-center border-end">
                                <c:set var="avatarSrc" value="${empty sessionScope.loginUser.avatar ? 'https://api.dicebear.com/7.x/adventurer/svg?seed=' += sessionScope.loginUser.username : sessionScope.loginUser.avatar}" />
                                <img src="${avatarSrc}" class="rounded-circle mb-3 border shadow-sm" style="width: 150px; height: 150px; object-fit: cover;">

                                <div class="mb-3">
                                    <label class="form-label small text-muted">更换头像 (可选)</label>
                                    <input class="form-control form-control-sm" type="file" name="avatarFile" accept="image/*">
                                </div>
                            </div>

                            <div class="col-md-8 ps-md-5">
                                <h5 class="fw-bold mb-4">基本信息</h5>
                                <div class="mb-3">
                                    <label class="form-label text-muted">登录账号 (不可修改)</label>
                                    <input type="text" class="form-control" value="${sessionScope.loginUser.username}" readonly style="background: #f8f9fa; cursor: not-allowed;">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">真实姓名</label>
                                    <input type="text" name="realName" class="form-control" value="${sessionScope.loginUser.realName}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">系统角色 (不可修改)</label>
                                    <c:choose>
                                        <c:when test="${sessionScope.loginUser.role == 'ADMIN'}"><c:set var="roleName" value="管理员"/></c:when>
                                        <c:when test="${sessionScope.loginUser.role == 'TEACHER'}"><c:set var="roleName" value="教师"/></c:when>
                                        <c:otherwise><c:set var="roleName" value="学生"/></c:otherwise>
                                    </c:choose>
                                    <input type="text" class="form-control" value="${roleName}" readonly style="background: #f8f9fa; cursor: not-allowed;">
                                </div>

                                <div class="mt-5">
                                    <button type="submit" class="btn btn-primary rounded-pill px-5 shadow-sm">💾 保存所有修改</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>