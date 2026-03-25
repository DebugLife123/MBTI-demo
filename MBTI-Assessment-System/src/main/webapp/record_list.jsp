<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>测试概览 - MBTI系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="records"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar">
            <div class="text-muted">管理员: <strong>${sessionScope.loginUser.realName}</strong></div>
        </div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">📊 全网测试记录概览</h3>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4">序号</th>
                            <th>用户名 (账号)</th>
                            <th>真实姓名</th>
                            <th>测试时间</th>
                            <th>性格类型</th>
                            <th>维度得分明细</th>
                            <th class="text-end pe-4">操作方式</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.logs}" var="log" varStatus="st">
                            <tr>
                                <td class="ps-4 text-muted">${st.count}</td>
                                <td><code>${log.username}</code></td>
                                <td class="fw-bold">${log.realName}</td>
                                <td class="text-muted"><fmt:formatDate value="${log.testTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <span class="badge bg-success px-3 py-2 fs-6">${log.resultType}</span>
                                </td>

                                <td class="text-muted small">${log.scores}</td>
                                <td class="text-end pe-4"> <a href="recordManage?method=view&id=${log.recordId}" class="btn btn-sm btn-outline-primary me-2">
                                    🔍 查看报告
                                </a>
                                    <a href="recordManage?method=delete&id=${log.recordId}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('确定要删除该用户的这条测试记录吗？')">
                                        🗑️ 删除
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requestScope.logs}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">目前暂无学生提交测试记录</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>