<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>选择测试 - MBTI 系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .hover-lift { transition: transform 0.3s, box-shadow 0.3s; }
        .hover-lift:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; cursor: pointer;}
    </style>
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp"><jsp:param name="active" value="test"/></jsp:include>

    <div class="main-content">
        <div class="topbar"><div class="text-muted">当前用户: <strong>${sessionScope.loginUser.realName}</strong></div></div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">🎯 请选择您要进行的考核类型</h3>
            <div class="row">
                <c:forEach items="${requestScope.activeTypes}" var="type">
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift bg-white" onclick="openTestModal('${type.id}', '${type.typeName}')">
                            <div class="card-body p-4 text-center">
                                <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                                    <i class="bi bi-ui-checks-grid fs-3"></i>
                                </div>
                                <h5 class="fw-bold mb-3">${type.typeName}</h5>
                                <p class="text-muted small mb-3">涵盖各大性格维度深度解析，助您洞察自身潜力。</p>
                                <div class="d-flex justify-content-center align-items-center gap-3">
                                    <span class="badge bg-success bg-opacity-25 text-success px-3 py-2 border border-success">状态: 在用</span>
                                    <span class="fw-bold text-danger">¥${type.price}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="testIntroModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <h5 class="fw-bold"><i class="bi bi-journal-text text-primary me-2"></i>测试说明：<span id="modalTypeName" class="text-primary"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 px-md-5">
                <div class="mb-4">
                    <h6 class="fw-bold text-dark mb-2">💡 关于本测试</h6>
                    <p class="text-muted small">本测试将从您的真实作答中，评估您在四大维度的偏好倾向。请根据第一直觉作答。</p>
                </div>
                <div class="mb-4">
                    <h6 class="fw-bold text-dark mb-2">⚠️ 免责声明</h6>
                    <p class="text-muted small">1. 测试结果仅供个人成长及职业规划参考，不具临床诊断效力。<br>2. 结果仅代表当下偏好，不完全代表全部潜能。</p>
                </div>
                <div class="mb-4">
                    <h6 class="fw-bold text-dark mb-2">🔒 隐私保护</h6>
                    <p class="text-muted small">我们承诺：您的作答数据将严格加密存储，绝不泄露给任何第三方。</p>
                </div>
                <div class="form-check mt-4 p-3 bg-light rounded-3 border">
                    <input class="form-check-input ms-1" type="checkbox" id="agreeCheckbox" onchange="toggleTestBtn()">
                    <label class="form-check-label ms-2 fw-bold text-dark" for="agreeCheckbox" style="cursor: pointer; user-select: none;">
                        我已阅读并完全同意以上说明
                    </label>
                </div>
            </div>
            <div class="modal-footer border-0 pb-4 px-4 px-md-5 d-flex justify-content-between">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">暂不测试</button>
                <button type="button" id="startTestBtn" class="btn btn-primary rounded-pill px-5 shadow-sm disabled" onclick="startLoadingTest()">
                    开始测试
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
    let selectedTypeId = null;

    function openTestModal(id, name) {
        selectedTypeId = id;
        document.getElementById('modalTypeName').innerText = name;
        // 重置复选框和按钮
        document.getElementById('agreeCheckbox').checked = false;
        document.getElementById('startTestBtn').classList.add('disabled');
        document.getElementById('startTestBtn').innerHTML = '开始测试';
        new bootstrap.Modal(document.getElementById('testIntroModal')).show();
    }

    function toggleTestBtn() {
        const checkbox = document.getElementById('agreeCheckbox');
        const btn = document.getElementById('startTestBtn');
        if (checkbox.checked) { btn.classList.remove('disabled'); } else { btn.classList.add('disabled'); }
    }

    function startLoadingTest() {
        const btn = document.getElementById('startTestBtn');
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>正在随机生成题库中...';
        btn.classList.add('disabled');

        // 延迟 1.5 秒后携带 typeId 跳转到真实测试接口
        setTimeout(() => {
            window.location.href = 'startTest?typeId=' + selectedTypeId;
        }, 1500);
    }
</script>
</body>
</html>