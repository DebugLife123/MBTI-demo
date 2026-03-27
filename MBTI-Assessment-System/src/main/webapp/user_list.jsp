<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户管理 - MBTI 系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="users"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar"><div class="text-muted">管理员: <strong>${sessionScope.loginUser.realName}</strong></div></div>

        <div class="container-fluid p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">👥 系统用户管理</h3>
                <form action="userManage" method="get" class="d-flex" style="width: 350px;">
                    <input type="text" name="keyword" value="${requestScope.keyword}" class="form-control rounded-pill me-2 border-primary" placeholder="🔍 搜索账号或真实姓名...">
                    <button type="submit" class="btn btn-primary rounded-pill px-4">搜索</button>
                </form>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4">序号</th>
                            <th>用户名</th>
                            <th>密码</th>
                            <th>真实姓名</th>
                            <th>身份角色</th>
                            <th class="text-end pe-4">操作管理</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.userList}" var="u" varStatus="st">
                            <tr>
                                <td class="ps-4 text-muted">${(currentPage - 1) * 10 + st.count}</td>
                                <td class="fw-bold">${u.username}</td>
                                <td><span class="text-muted font-monospace">${u.password}</span></td>
                                <td>${u.realName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 'ADMIN'}"><span class="badge bg-danger">管理员</span></c:when>
                                        <c:when test="${u.role == 'TEACHER'}"><span class="badge bg-info text-dark">教师</span></c:when>
                                        <c:otherwise><span class="badge bg-success">学生</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-4">
                                    <button class="btn btn-sm btn-outline-primary me-1"
                                            onclick="editUser('${u.id}', '${u.username}', '${u.password}', '${u.realName}', '${u.role}')">
                                        ✏️ 修改
                                    </button>
                                    <a href="userManage?method=resetPwd&id=${u.id}" class="btn btn-sm btn-outline-warning me-1"
                                       onclick="return confirm('确定要将该用户的密码重置为 123456 吗？');">
                                        🔄 重置密码
                                    </a>
                                    <a href="userManage?method=delete&id=${u.id}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('【危险】确认删除该用户吗？这会同时清空他的所有测试记录！');">
                                        🗑️ 删除
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer bg-white border-top-0 p-4 rounded-bottom-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted small">
                            共找到 <strong>${totalCount}</strong> 名用户，当前第 <strong class="text-primary">${currentPage}</strong> / ${totalPages > 0 ? totalPages : 1} 页
                        </span>

                        <c:if test="${totalPages > 1}">
                            <nav>
                                <ul class="pagination pagination-sm mb-0 shadow-sm">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link px-3" href="userManage?page=${currentPage - 1}&keyword=${keyword}">上一页</a>
                                    </li>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="userManage?page=${i}&keyword=${keyword}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link px-3" href="userManage?page=${currentPage + 1}&keyword=${keyword}">下一页</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editUserModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <form action="userManage?method=update" method="post">
                <input type="hidden" name="id" id="modalUserId">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold">✏️ 修改用户信息</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small text-muted">登录账号</label>
                        <input type="text" name="username" id="modalUsername" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small text-muted">登录密码</label>
                        <input type="text" name="password" id="modalPassword" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small text-muted">真实姓名</label>
                        <input type="text" name="realName" id="modalRealName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small text-muted">身份角色</label>
                        <select name="role" id="modalRole" class="form-select">
                            <option value="STUDENT">STUDENT (学生)</option>
                            <option value="TEACHER">TEACHER (教师)</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">保存修改</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
    // 点击修改按钮时，自动把该行的数据填充进表单弹窗里
    function editUser(id, username, password, realName, role) {
        document.getElementById('modalUserId').value = id;
        document.getElementById('modalUsername').value = username;
        document.getElementById('modalPassword').value = password;
        document.getElementById('modalRealName').value = realName;
        document.getElementById('modalRole').value = role;
        new bootstrap.Modal(document.getElementById('editUserModal')).show();
    }
</script>
</body>
</html>