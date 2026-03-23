<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head><title>题库管理 - MBTI 系统</title></head>
<body class="bg-light">
<%@ include file="header.jsp" %>
<div class="container">
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold text-primary">📝 题库内容管理</h5>
            <a href="adminManage" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left"></i> 返回看板
            </a>
        </div>
        <div class="card-body">
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>题目内容</th>
                    <th>选项 A (维度)</th>
                    <th>选项 B (维度)</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${requestScope.qList}" var="q">
                    <tr>
                        <td>${q.id}</td>
                        <td class="text-truncate" style="max-width: 300px;">${q.questionText}</td>
                        <td>${q.optionA} (${q.optionAType})</td>
                        <td>${q.optionB} (${q.optionBType})</td>
                        <td>
                            <a href="questionManage?method=delete&id=${q.id}"
                               class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('确定删除这道题吗？')">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>