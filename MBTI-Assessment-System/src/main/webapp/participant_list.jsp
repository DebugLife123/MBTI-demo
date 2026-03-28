<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>参测人员名单 - MBTI系统</title>
  <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <link href="static/css/style.css" rel="stylesheet">
</head>
<body>
<div class="dashboard-wrapper">
  <jsp:include page="sidebar.jsp"><jsp:param name="active" value="assessments"/></jsp:include>
  <div class="main-content">
    <div class="container-fluid p-4 p-md-5">

      <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
          <h4 class="fw-bold mb-1">👥 参测人员名单</h4>
          <p class="text-muted mb-0">当前查看的测试主题：<strong class="text-primary">${assessment.title}</strong></p>
        </div>
        <button class="btn btn-primary rounded-pill shadow-sm px-4" data-bs-toggle="modal" data-bs-target="#importModal">
          📥 导入报名人员
        </button>
      </div>

      <div class="card border-0 shadow-sm rounded-4">
        <table class="table table-hover align-middle mb-0">
          <thead class="table-light">
          <tr><th class="ps-4">序号</th><th>账号</th><th>真实姓名</th><th>身份</th><th>报名时间</th><th class="text-end pe-4">操作</th></tr>
          </thead>
          <tbody>
          <c:forEach items="${participants}" var="p" varStatus="st">
            <tr>
              <td class="ps-4 text-muted">${st.count}</td>
              <td><code>${p.username}</code></td>
              <td class="fw-bold">${p.realName}</td>
              <td><span class="badge ${p.role == 'TEACHER' ? 'bg-info' : 'bg-secondary'}">${p.role == 'TEACHER' ? '教师' : '学生'}</span></td>
              <td class="text-muted"><fmt:formatDate value="${p.registerTime}" pattern="yyyy-MM-dd HH:mm"/></td>
              <td class="text-end pe-4">
                <a href="#" class="btn btn-sm btn-outline-danger" onclick="confirmAction(event, 'testPlanManage?method=kick&assessmentId=${assessment.id}&userId=${p.userId}', '取消资格？', '确定将该用户从本场测试中移除吗？', '确认移除', '#dc3545')">⛔ 移除</a>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty participants}">
            <tr><td colspan="6" class="text-center py-5 text-muted">目前还没有人报名这场测试 🍃</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>
      <a href="testPlanManage" class="btn btn-light mt-4 rounded-pill px-4 border shadow-sm">⬅️ 返回测试安排列表</a>
    </div>
  </div>
</div>

<div class="modal fade" id="importModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content border-0 shadow-lg rounded-4">
      <form action="testPlanManage?method=import" method="post">
        <input type="hidden" name="assessmentId" value="${assessment.id}">

        <div class="modal-header border-0 pb-0">
          <h5 class="fw-bold">📥 批量导入参测人员</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>

        <div class="modal-body p-4">
          <p class="text-muted small mb-3">勾选下方用户将其添加到本次测试中（置灰项表示已报名）。</p>

          <div class="list-group shadow-sm">
            <c:forEach items="${allUsers}" var="u">
              <c:if test="${u.role != 'ADMIN'}">
                <c:set var="isReg" value="${regIds.contains(u.id)}" />

                <label class="list-group-item d-flex align-items-center ${isReg ? 'bg-light' : ''}" style="${isReg ? 'cursor: not-allowed; opacity: 0.6;' : 'cursor: pointer;'}">
                  <input class="form-check-input me-3" type="checkbox" name="userIds" value="${u.id}" ${isReg ? 'disabled checked' : ''}>
                  <div class="flex-grow-1">
                    <span class="fw-bold text-dark">${u.realName}</span>
                    <span class="small text-muted font-monospace ms-1">(${u.username})</span>
                  </div>
                  <span class="badge ${u.role == 'TEACHER' ? 'bg-info text-dark' : 'bg-success'} bg-opacity-75 me-2">${u.role == 'TEACHER' ? '教师' : '学生'}</span>
                  <c:if test="${isReg}"><span class="badge bg-secondary">已报名</span></c:if>
                </label>
              </c:if>
            </c:forEach>
          </div>
        </div>

        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">取消</button>
          <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">确认导入</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
  function confirmAction(e, url, title, text, btn, color) {
    e.preventDefault();
    Swal.fire({
      title: title,
      text: text,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: color,
      confirmButtonText: btn
    }).then((r) => {
      if(r.isConfirmed) window.location.href = url;
    });
  }
</script>
</body>
</html>