<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>测评报告 - MBTI 职业性格测试</title>
</head>
<body class="bg-light">
<%-- 引用统一头部（含 CSS 和 导航栏） --%>
<%@ include file="header.jsp" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="card border-0 shadow-lg rounded-4 text-center p-5 mb-5">
                <div class="mb-4"><span class="display-3 text-success">🏆</span></div>
                <h2 class="fw-bold mb-4">测评分析报告</h2>

                <p class="text-secondary mb-3">亲爱的 <strong>${sessionScope.loginUser.realName}</strong>，根据测评，您的核心人格为：</p>

                <div class="py-4 bg-primary bg-opacity-10 rounded-4 mb-4">
                    <%-- 显示 4 位代码 (如: ESTJ) --%>
                    <h1 class="display-2 fw-bold text-primary mb-0">${requestScope.myResult}</h1>
                    <%-- 显示性格头衔 (如: 总经理) --%>
                    <h3 class="text-secondary mt-2">${requestScope.personality.title}</h3>
                </div>

                <div class="mt-4 mb-5">
                    <h6 class="text-muted mb-3">📊 维度得分详情：</h6>
                    <div class="row g-2 text-center">
                        <div class="col-3"><div class="p-2 bg-white border rounded small">E: ${requestScope.scores.eScore} / I: ${requestScope.scores.iScore}</div></div>
                        <div class="col-3"><div class="p-2 bg-white border rounded small">S: ${requestScope.scores.sScore} / N: ${requestScope.scores.nScore}</div></div>
                        <div class="col-3"><div class="p-2 bg-white border rounded small">T: ${requestScope.scores.tScore} / F: ${requestScope.scores.fScore}</div></div>
                        <div class="col-3"><div class="p-2 bg-white border rounded small">J: ${requestScope.scores.jScore} / P: ${requestScope.scores.pScore}</div></div>
                    </div>
                </div>

                <div class="text-start bg-light p-4 rounded-3 mb-4 border-start border-4 border-primary">
                    <h5 class="fw-bold mb-3">🔍 性格概览</h5>
                    <p class="text-muted leading-relaxed mb-0">
                        ${requestScope.personality.description}
                    </p>
                </div>

                <div class="text-start bg-light p-4 rounded-3 mb-4 border-start border-4 border-success">
                    <h5 class="fw-bold mb-3">💼 职业发展建议</h5>
                    <p class="text-muted leading-relaxed mb-0">
                        ${requestScope.personality.careerAdvice}
                    </p>
                </div>

                <div class="d-grid gap-2 d-md-block mt-5">
                    <a href="startTest" class="btn btn-light btn-lg px-4 me-md-2 border">重新测试</a>
                    <button onclick="window.print()" class="btn btn-primary btn-lg px-4 shadow">保存报告 (PDF)</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>