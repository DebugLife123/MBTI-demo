<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>测试安排管理 - MBTI系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp"><jsp:param name="active" value="testplanmanage"/></jsp:include>
    <div class="main-content">
        <div class="container-fluid p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">📅 测试安排管理</h3>
                <button class="btn btn-primary rounded-pill shadow-sm" data-bs-toggle="modal" data-bs-target="#createModal">➕ 发布新测试</button>
            </div>
            <div class="card border-0 shadow-sm rounded-4">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr><th>测试主题</th><th>形式</th><th>测试时间</th><th>地点/会议链接</th><th class="text-end pe-4">操作</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${list}" var="a">
                        <tr>
                            <td class="fw-bold ps-3">${a.title}</td>
                            <td><span class="badge ${a.format == 'ONLINE' ? 'bg-success' : 'bg-warning'}">${a.format == 'ONLINE' ? '线上测试' : '线下测试'}</span></td>
                            <td><fmt:formatDate value="${a.testTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>${a.location}</td>
                            <td class="text-end pe-3">
                                <a href="testPlanManage?method=participants&id=${a.id}" class="btn btn-sm btn-outline-info me-1">👥 参测人员</a>
                                <a href="#" class="btn btn-sm btn-outline-danger" onclick="confirmAction(event, 'testPlanManage?method=delete&id=${a.id}', '删除安排？', '将同步清空所有报名记录！', '确认删除', '#dc3545')">🗑️ 删除</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty list}">
                        <tr><td colspan="5" class="text-center py-5 text-muted">暂无任何测试安排数据 🍃</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="createModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content rounded-4 border-0 shadow-lg">
            <form action="testPlanManage?method=create" method="post">
                <div class="modal-header"><h5 class="fw-bold">发布新测试安排</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body p-4 row g-3">
                    <div class="col-12"><label>测试主题</label><input type="text" name="title" class="form-control" required placeholder="如：2026届毕业生职业性格普测"></div>
                    <div class="col-6"><label>测试形式</label><select name="format" class="form-select"><option value="ONLINE">线上测试</option><option value="OFFLINE">线下集中测试</option></select></div>
                    <div class="col-6"><label>测试时间</label><input type="datetime-local" name="testTime" class="form-control" required></div>
                    <div class="col-12"><label>地点/会议链接</label><input type="text" name="location" class="form-control" required placeholder="如：教学楼A栋101 或 腾讯会议号:123456"></div>
                    <div class="col-12"><label>测试目的</label><textarea name="purpose" class="form-control" rows="2" placeholder="填写本次测试的主要目的..."></textarea></div>
                    <div class="col-12"><label>注意事项</label><textarea name="notes" class="form-control" rows="2" placeholder="请提醒学生自带手机或电脑等..."></textarea></div>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary rounded-pill px-4">确认发布</button></div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
    function confirmAction(e, url, title, text, btn, color) {
        e.preventDefault(); Swal.fire({title: title, text: text, icon: 'warning', showCancelButton: true, confirmButtonColor: color, confirmButtonText: btn, background: 'rgba(255,255,255,0.95)'}).then((r) => { if(r.isConfirmed) window.location.href = url; });
    }
</script>
</body>
</html>