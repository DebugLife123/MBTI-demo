<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head><title>管理后台 - MBTI 系统</title></head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">📊 全校测试结果概览</h2>
        <div>
            <a href="questionManage" class="btn btn-primary me-2 shadow-sm">
                <i class="bi bi-pencil-square"></i> 题库管理
            </a>
            <button class="btn btn-success shadow-sm" onclick="window.print()">
                <i class="bi bi-download"></i> 导出报表
            </button>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-primary">
                <tr>
                    <th class="ps-4">学生姓名</th>
                    <th>测评结果</th>
                    <th>具体维度得分</th>
                    <th>测评时间</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${requestScope.logs}" var="log">
                    <tr>
                        <td class="ps-4 fw-bold text-dark">${log.realName}</td>
                        <td><span class="badge bg-info text-dark">${log.resultType}</span></td>
                        <td class="small text-muted">${log.scores}</td>
                        <td class="text-secondary">${log.testTime}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>