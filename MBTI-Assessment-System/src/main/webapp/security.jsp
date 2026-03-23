<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>账号与安全 - MBTI</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="security"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar"><div class="text-muted">安全中心</div></div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">🔒 账号与安全</h3>

            <div class="row">
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-4">修改登录密码</h5>

                            <c:if test="${not empty requestScope.successMsg}">
                                <div class="alert alert-success">${requestScope.successMsg}</div>
                            </c:if>
                            <c:if test="${not empty requestScope.errorMsg}">
                                <div class="alert alert-danger">${requestScope.errorMsg}</div>
                            </c:if>

                            <form action="security" method="post" id="pwdForm">
                                <div class="mb-3">
                                    <label class="form-label text-muted small">当前旧密码</label>
                                    <input type="password" name="oldPassword" class="form-control" placeholder="请输入旧密码验证身份" required>
                                </div>
                                <hr class="my-4 opacity-25">
                                <div class="mb-3">
                                    <label class="form-label text-muted small">设置新密码</label>
                                    <input type="password" name="newPassword" id="newPassword" class="form-control" placeholder="请输入新密码" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label text-muted small">确认新密码</label>
                                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="请再次输入新密码" required>
                                    <div id="pwdCheckMsg" class="form-text mt-2"></div>
                                </div>

                                <button type="submit" class="btn btn-primary rounded-pill px-5 shadow-sm">保存修改</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5 offset-lg-1">
                    <div class="alert bg-white border-0 shadow-sm rounded-4 p-4">
                        <h6 class="fw-bold text-primary"><i class="bi bi-shield-lock"></i> 安全提示</h6>
                        <ul class="small text-muted mb-0 mt-3">
                            <li class="mb-2">定期修改密码有助于保护您的测评隐私。</li>
                            <li class="mb-2">建议使用字母、数字及特殊符号的组合。</li>
                            <li>如果忘记原密码，请联系管理员重置。</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
    // JS 实时校验：两次密码是否一致
    const newPwd = document.getElementById('newPassword');
    const confPwd = document.getElementById('confirmPassword');
    const msg = document.getElementById('pwdCheckMsg');

    confPwd.oninput = function() {
        if (newPwd.value !== confPwd.value) {
            msg.innerHTML = "❌ 两次输入的密码不一致";
            msg.className = "form-text text-danger";
        } else {
            msg.innerHTML = "✅ 密码匹配一致";
            msg.className = "form-text text-success";
        }
    };
</script>
</body>
</html>