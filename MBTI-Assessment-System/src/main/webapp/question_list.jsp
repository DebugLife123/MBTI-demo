<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>题库管理 - MBTI职业性格测试系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="questions"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar">
            <div class="text-muted">管理员: <strong>${sessionScope.loginUser.realName}</strong></div>
        </div>

        <div class="container-fluid p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">📝 题库内容管理</h3>
                <button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                    <i class="bi bi-plus-circle"></i> 新增测试题目
                </button>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>题目内容</th>
                            <th>选项 A (维度)</th>
                            <th>选项 B (维度)</th>
                            <th class="text-end pe-4">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.qList}" var="q">
                            <tr>
                                <td class="ps-4 text-muted">${q.id}</td>
                                <td class="fw-bold">${q.questionText}</td>
                                <td>${q.optionA} <span class="badge bg-light text-dark">${q.optionAType}</span></td>
                                <td>${q.optionB} <span class="badge bg-light text-dark">${q.optionBType}</span></td>
                                <td class="text-end pe-4">
                                    <a href="#" class="btn btn-sm btn-outline-danger"
                                       onclick="confirmAction(event, 'questionManage?method=delete&id=${q.id}', '确定要删除这道题吗？', '删除后该题目数据将彻底从题库中移除！', '🗑️ 确认删除', '#dc3545')">
                                        🗑️ 删除
                                    </a>
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

<div class="modal fade" id="addQuestionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <form action="questionManage" method="post">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold">🆕 添加测评题目</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small text-muted">题目正文</label>
                        <textarea name="questionText" class="form-control" rows="2" placeholder="例如：在社交场合中，你通常：" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-8">
                            <label class="form-label small text-muted">选项 A 内容</label>
                            <input type="text" name="optionA" class="form-control" placeholder="感精力充沛..." required>
                        </div>
                        <div class="col-4">
                            <label class="form-label small text-muted">对应维度</label>
                            <select name="optionAType" class="form-select">
                                <option value="E">E</option><option value="S">S</option><option value="T">T</option><option value="J">J</option>
                                <option value="I">I</option><option value="N">N</option><option value="F">F</option><option value="P">P</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-8">
                            <label class="form-label small text-muted">选项 B 内容</label>
                            <input type="text" name="optionB" class="form-control" placeholder="感疲惫，渴望..." required>
                        </div>
                        <div class="col-4">
                            <label class="form-label small text-muted">对应维度</label>
                            <select name="optionBType" class="form-select">
                                <option value="I">I</option><option value="N">N</option><option value="F">F</option><option value="P">P</option>
                                <option value="E">E</option><option value="S">S</option><option value="T">T</option><option value="J">J</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">保存题目</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function confirmAction(event, url, title, text, confirmBtnText, confirmBtnColor) {
        event.preventDefault();
        Swal.fire({
            title: title,
            text: text,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: confirmBtnColor || '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: confirmBtnText || '确定',
            cancelButtonText: '取消',
            background: 'rgba(255, 255, 255, 0.9)',
            backdrop: 'rgba(0,0,0,0.4)',
            borderRadius: '15px'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }
</script>
</body>
</html>