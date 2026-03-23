<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员控制台 - MBTI 系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="home"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar">
            <div class="text-muted">
                管理员: <strong>${sessionScope.loginUser.realName}</strong>
                <a href="index.jsp" class="btn btn-sm btn-outline-danger ms-3">退出系统</a>
            </div>
        </div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">📊 管理员看板</h3>

            <div class="row mb-4">
                <div class="col-md-6 col-lg-4 mb-3">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                        <div class="d-flex align-items-center">
                            <div class="rounded-circle bg-primary bg-opacity-10 p-3 me-3">
                                <span class="fs-3">📝</span>
                            </div>
                            <div>
                                <h6 class="text-muted mb-1">题库总数</h6>
                                <h4 class="fw-bold mb-0">28 道</h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 mb-3">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                        <div class="d-flex align-items-center">
                            <div class="rounded-circle bg-success bg-opacity-10 p-3 me-3">
                                <span class="fs-3">📈</span>
                            </div>
                            <div>
                                <h6 class="text-muted mb-1">系统测评记录</h6>
                                <h4 class="fw-bold mb-0">${logs != null ? logs.size() : 0} 条</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-5 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-body p-4">
                            <h5 class="fw-bold border-bottom pb-3 mb-4">👤 管理员信息</h5>
                            <div class="d-flex align-items-center mb-4">
                                <%-- 头像逻辑：优先显示上传的头像，否则生成随机头像 --%>
                                <c:set var="avatarSrc" value="${empty sessionScope.loginUser.avatar ? 'https://api.dicebear.com/7.x/adventurer/svg?seed=' += sessionScope.loginUser.username : sessionScope.loginUser.avatar}" />
                                <img src="${avatarSrc}" class="rounded-circle me-3 border shadow-sm" style="width: 70px; height: 70px; object-fit: cover;">
                                <div>
                                    <h5 class="mb-0 fw-bold">${sessionScope.loginUser.realName}</h5>
                                    <span class="badge bg-danger bg-opacity-75 mt-1">系统管理员</span>
                                </div>
                            </div>
                            <div class="space-y-2">
                                <p class="mb-2 text-muted"><strong>管理账号：</strong> ${sessionScope.loginUser.username}</p>
                                <p class="mb-2 text-muted"><strong>注册时间：</strong> <fmt:formatDate value="${sessionScope.loginUser.createTime}" pattern="yyyy-MM-dd"/></p>
                                <p class="mb-0 text-muted small text-primary italic">💡 您拥有最高管理权限，请谨慎操作数据。</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 bg-light">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-4">⚡ 快捷操作区</h5>
                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <div class="p-4 bg-white rounded-4 text-center border">
                                        <div class="fs-2 mb-2">📋</div>
                                        <h6 class="fw-bold">题库维护</h6>
                                        <p class="small text-muted mb-3">更新、添加或删除测试题目</p>
                                        <a href="questionManage" class="btn btn-primary w-100 rounded-pill shadow-sm">进入题库管理</a>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="p-4 bg-white rounded-4 text-center border">
                                        <div class="fs-2 mb-2">📄</div>
                                        <h6 class="fw-bold">成绩报表</h6>
                                        <p class="small text-muted mb-3">查看并分析所有学生测评详情</p>
                                        <button class="btn btn-outline-primary w-100 rounded-pill" onclick="window.print()">导出系统报表</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>