<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>测试报名中心 - MBTI系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp"><jsp:param name="active" value="registration"/></jsp:include>
    <div class="main-content">
        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">📢 测试报名大厅</h3>

            <div class="mb-4">
                <a href="testRegistration" class="btn btn-sm ${empty formatFilter ? 'btn-primary' : 'btn-outline-primary'} rounded-pill me-2">全部</a>
                <a href="testRegistration?format=ONLINE" class="btn btn-sm ${formatFilter == 'ONLINE' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill me-2">仅看线上</a>
                <a href="testRegistration?format=OFFLINE" class="btn btn-sm ${formatFilter == 'OFFLINE' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill">仅看线下</a>
            </div>

            <div class="row g-4">
                <c:forEach items="${list}" var="a">
                    <div class="col-md-6 col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100 ${a.registered ? 'border-success border-2' : ''}">
                            <div class="card-body p-4 position-relative">
                                <c:if test="${a.registered}"><span class="position-absolute top-0 end-0 badge bg-success p-2 m-3 shadow-sm">✅ 已报名</span></c:if>
                                <span class="badge ${a.format == 'ONLINE' ? 'bg-primary' : 'bg-warning'} mb-2">${a.format == 'ONLINE' ? '线上测试' : '线下测试'}</span>
                                <h5 class="fw-bold mb-3">${a.title}</h5>
                                <p class="text-muted small mb-2"><strong>⏰ 时间：</strong><fmt:formatDate value="${a.testTime}" pattern="yyyy-MM-dd HH:mm"/></p>
                                <p class="text-muted small mb-3"><strong>📍 地点：</strong>${a.location}</p>
                                <hr class="opacity-25">
                                <p class="text-muted small text-truncate">📝 <strong>目的：</strong>${a.purpose}</p>

                                <div class="mt-4 pt-2">
                                    <c:choose>
                                        <c:when test="${a.registered}">
                                            <a href="#" class="btn btn-outline-danger w-100 rounded-pill" onclick="confirmAction(event, 'testRegistration?method=cancel&id=${a.id}', '取消报名？', '确认取消报名该场测试吗？', '确认取消', '#dc3545')">取消报名</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="#" class="btn btn-success w-100 rounded-pill shadow-sm" onclick="confirmAction(event, 'testRegistration?method=register&id=${a.id}', '确认报名？', '您即将报名参加【${a.title}】', '立即报名', '#198754')">➕ 立即报名</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty list}">
                    <div class="col-12"><div class="p-5 text-center text-muted bg-white rounded-4 shadow-sm">管理员暂未发布任何测试安排哦 🍃</div></div>
                </c:if>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function confirmAction(e, url, title, text, btn, color) {
        e.preventDefault(); Swal.fire({title: title, text: text, icon: 'info', showCancelButton: true, confirmButtonColor: color, confirmButtonText: btn, background: 'rgba(255,255,255,0.95)'}).then((r) => { if(r.isConfirmed) window.location.href = url; });
    }
</script>
</body>
</html>