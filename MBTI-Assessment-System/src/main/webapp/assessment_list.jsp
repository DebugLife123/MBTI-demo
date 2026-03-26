<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>考核类型管理 - MBTI 系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp"><jsp:param name="active" value="assessments"/></jsp:include>

    <div class="main-content">
        <div class="topbar"><div class="text-muted">管理员: <strong>${sessionScope.loginUser.realName}</strong></div></div>

        <div class="container-fluid p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">📁 考核类型管理</h3>
                <button class="btn btn-primary rounded-pill px-4 shadow-sm" onclick="openAddModal()">
                    <i class="bi bi-plus-circle me-1"></i> 添加测评类型
                </button>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4">序号</th>
                            <th>类型名称</th>
                            <th>状态</th>
                            <th>费用</th>
                            <th class="text-end pe-4">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.typeList}" var="t" varStatus="st">
                            <tr>
                                <td class="ps-4">${st.count}</td>
                                <td class="fw-bold text-primary">${t.typeName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.status == 1}"><span class="badge bg-success">在用</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">作废</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>¥${t.price}</td>
                                <td class="text-end pe-4">
                                    <button class="btn btn-sm btn-outline-primary me-1"
                                            onclick="openEditModal('${t.id}', '${t.typeName}', '${t.status}', '${t.price}')">
                                        ✏️ 修改
                                    </button>
                                    <a href="assessmentManage?method=delete&id=${t.id}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('警告：确定要彻底删除该测评类型吗？');">
                                        🗑️ 删除
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requestScope.typeList}">
                            <tr><td colspan="5" class="text-center py-4 text-muted">暂无测评类型数据</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="typeModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <form action="assessmentManage" method="post" id="typeForm">
                <input type="hidden" name="id" id="modalTypeId">

                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold" id="modalTitle">🆕 添加测评类型</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small text-muted">类型名称</label>
                        <input type="text" name="typeName" id="modalTypeName" class="form-control" placeholder="如：职业性格测试36题" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small text-muted">费用设定 (¥)</label>
                        <input type="number" step="0.01" name="price" id="modalPrice" class="form-control" placeholder="0.00" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small text-muted">当前状态</label>
                        <select name="status" id="modalStatus" class="form-select">
                            <option value="1">✅ 在用 (前端可选)</option>
                            <option value="0">⛔ 作废 (前端隐藏)</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">保存设置</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
    // 打开【添加】弹窗
    function openAddModal() {
        document.getElementById('modalTitle').innerText = '🆕 添加测评类型';
        document.getElementById('modalTypeId').value = ''; // ID置空
        document.getElementById('typeForm').reset();       // 清空表单以前填的内容
        document.getElementById('modalStatus').value = '1';// 默认选在用
        new bootstrap.Modal(document.getElementById('typeModal')).show();
    }

    // 打开【修改】弹窗，并回填数据
    function openEditModal(id, name, status, price) {
        document.getElementById('modalTitle').innerText = '✏️ 修改测评类型';
        document.getElementById('modalTypeId').value = id;
        document.getElementById('modalTypeName').value = name;
        document.getElementById('modalStatus').value = status;
        document.getElementById('modalPrice').value = price;
        new bootstrap.Modal(document.getElementById('typeModal')).show();
    }
</script>
</body>
</html>