<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>性格维度管理 - MBTI 系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp"><jsp:param name="active" value="dimensions"/></jsp:include>

    <div class="main-content">
        <div class="topbar"><div class="text-muted">管理员: <strong>${sessionScope.loginUser.realName}</strong></div></div>

        <div class="container-fluid p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">🧬 性格维度管理</h3>
                <div>
                    <a href="dimensionManage" class="btn btn-outline-secondary rounded-pill px-4 me-2">查看性格维度</a>
                    <button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#dimModal">添加性格维度</button>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4">维度序号</th>
                            <th>性格维度名称</th>
                            <th>性格维度说明</th>
                            <th class="text-end pe-4">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.dimList}" var="d" varStatus="st">
                            <tr>
                                <td class="ps-4">${st.count}</td>
                                <td class="fw-bold text-primary">${d.dimName}</td>
                                <td class="text-muted small" style="max-width: 500px;">${d.description}</td>
                                <td class="text-end pe-4">
                                    <button class="btn btn-sm btn-outline-primary me-1"
                                            onclick="editDim('${d.id}', '${d.dimName}', '${d.description}')">修改</button>
                                    <a href="dimensionManage?method=delete&id=${d.id}"
                                       class="btn btn-sm btn-outline-danger" onclick="return confirm('确定删除吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="dimModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <form action="dimensionManage" method="post">
                <input type="hidden" name="id" id="dimId">
                <div class="modal-header border-0"><h5 class="fw-bold" id="modalTitle">🆕 添加性格维度</h5></div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small text-muted">维度名称 (如: 外倾(E)-内倾(I))</label>
                        <input type="text" name="dimName" id="dimNameInput" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small text-muted">维度详细说明</label>
                        <textarea name="description" id="dimDescInput" class="form-control" rows="5" required></textarea>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-primary rounded-pill px-4">保存设置</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
    function editDim(id, name, desc) {
        document.getElementById('dimId').value = id;
        document.getElementById('dimNameInput').value = name;
        document.getElementById('dimDescInput').value = desc;
        document.getElementById('modalTitle').innerText = "✏️ 修改性格维度";
        new bootstrap.Modal(document.getElementById('dimModal')).show();
    }
</script>
</body>
</html>