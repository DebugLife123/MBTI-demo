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
      <h4 class="fw-bold mb-1">👥 参测人员名单</h4>
      <p class="text-muted mb-4">当前查看的测试主题：<strong class="text-primary">${assessment.title}</strong></p>

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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
  function confirmAction(e, url, title, text, btn, color) {
    e.preventDefault(); Swal.fire({title: title, text: text, icon: 'warning', showCancelButton: true, confirmButtonColor: color, confirmButtonText: btn}).then((r) => { if(r.isConfirmed) window.location.href = url; });
  }
</script>
</body>
</html>