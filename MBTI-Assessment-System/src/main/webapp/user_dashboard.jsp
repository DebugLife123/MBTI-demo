<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.mbti.training.dao.TestRecordDao" %>
<%@ page import="com.mbti.training.model.TestRecord" %>
<%@ page import="com.mbti.training.model.SysUser" %>
<%@ page import="java.util.List" %>
<%
    // 页面加载时，自动查询当前用户的最新一条测试记录
    SysUser loginUser = (SysUser) session.getAttribute("loginUser");
    if (loginUser != null) {
        TestRecordDao recordDao = new TestRecordDao();
        List<TestRecord> records = recordDao.getRecordsByUserId(loginUser.getId());
        if (records != null && !records.isEmpty()) {
            request.setAttribute("latestRecord", records.get(0));
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的主页 - MBTI</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        /* 提升页面高级感的微交互动画 */
        .hover-lift {
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 1rem 3rem rgba(0,0,0,.1) !important;
        }
        .type-icon {
            width: 48px; height: 48px;
            font-weight: 800; letter-spacing: 1px;
        }
        .data-card::before {
            content: ''; position: absolute; top: -50px; right: -50px;
            width: 150px; height: 150px; border-radius: 50%;
            background: rgba(79, 172, 254, 0.3); filter: blur(40px); z-index: 0;
        }
        .data-card::after {
            content: ''; position: absolute; bottom: -50px; left: -50px;
            width: 150px; height: 150px; border-radius: 50%;
            background: rgba(0, 242, 254, 0.2); filter: blur(40px); z-index: 0;
        }
    </style>
</head>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="home"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar">
            <div class="text-muted">
                欢迎回来, <strong>${sessionScope.loginUser.realName}</strong>
                <a href="index.jsp" class="btn btn-sm btn-outline-danger ms-3">退出登录</a>
            </div>
        </div>

        <div class="container-fluid p-4 p-md-5">

            <div class="mb-4 p-4 p-md-5 rounded-4 text-white shadow-sm hover-lift" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <h2 class="fw-bold mb-3">✨ 探索真实自我，遇见更好的未来</h2>
                <p class="fs-6 opacity-75 mb-0" style="max-width: 600px;">
                    MBTI 职业性格测试系统，帮助你深层次了解自己的性格偏好，挖掘潜在优势，为您未来的职业规划与人际交往提供科学参考。
                </p>
            </div>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift">
                        <div class="card-body p-4 p-md-5">
                            <h5 class="fw-bold border-bottom pb-3 mb-4">👤 个人资料</h5>
                            <div class="d-flex align-items-center mb-4">
                                <c:set var="avatarSrc" value="${empty sessionScope.loginUser.avatar ? 'https://api.dicebear.com/7.x/adventurer/svg?seed=' += sessionScope.loginUser.username : sessionScope.loginUser.avatar}" />
                                <img src="${avatarSrc}" class="rounded-circle me-3 border shadow-sm" style="width: 65px; height: 65px; object-fit: cover;">
                                <div>
                                    <h5 class="mb-0 fw-bold">${sessionScope.loginUser.realName}</h5>
                                    <span class="badge bg-secondary mt-1">${sessionScope.loginUser.role == 'TEACHER' ? '教师' : '学生'}</span>
                                </div>
                            </div>
                            <p class="mb-2 text-muted"><strong>登录账号：</strong> ${sessionScope.loginUser.username}</p>
                            <p class="mb-2 text-muted"><strong>真实姓名：</strong> ${sessionScope.loginUser.realName}</p>

                            <hr class="my-4 opacity-25">

                            <h6 class="fw-bold mb-3 text-secondary">🏷️ 最近一次测试结果</h6>
                            <c:choose>
                                <c:when test="${not empty latestRecord}">
                                    <div class="p-3 bg-light rounded-3 border-start border-4 border-success d-flex justify-content-between align-items-center transition-all hover-lift">
                                        <div>
                                            <span class="badge bg-success fs-6 mb-1">${latestRecord.resultType}</span>
                                            <div class="small text-muted">时间: <fmt:formatDate value="${latestRecord.testTime}" pattern="yyyy-MM-dd"/></div>
                                        </div>
                                        <a href="history?action=view&id=${latestRecord.id}" class="btn btn-sm btn-outline-success rounded-pill px-3">查看报告</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="p-3 bg-light rounded-3 text-center text-muted border border-dashed">
                                        <p class="mb-0 small">暂无测试记录，快去测一测吧！🏃</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 bg-primary text-white position-relative hover-lift" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important; overflow: hidden;">
                        <div class="position-absolute top-0 end-0 translate-middle-y rounded-circle bg-white opacity-10" style="width: 200px; height: 200px; margin-right: -50px;"></div>
                        <div class="card-body p-4 p-md-5 d-flex flex-column z-1">
                            <div class="text-center mt-3 mb-5">
                                <h3 class="fw-bold mb-3">准备好探索你自己了吗？</h3>
                                <p class="mb-0 opacity-75">完成精选测试题，获取深度的职业性格解析报告。</p>
                            </div>
                            <div class="text-center mb-5">
                                <a href="#" data-bs-toggle="modal" data-bs-target="#testIntroModal" class="btn btn-light btn-lg rounded-pill px-5 py-3 fw-bold text-primary shadow-lg hover-lift" style="letter-spacing: 2px;">
                                    立即开始测试 🚀
                                </a>
                            </div>
                            <div class="mt-auto border-top border-light border-opacity-25 pt-4">
                                <div class="row text-center">
                                    <div class="col-6 mb-3"><div class="small opacity-75"><i class="bi bi-ui-checks"></i> ✅ 36 道专业题目</div></div>
                                    <div class="col-6 mb-3"><div class="small opacity-75"><i class="bi bi-pie-chart-fill"></i> 📊 精准维度分析</div></div>
                                    <div class="col-6"><div class="small opacity-75"><i class="bi bi-file-earmark-person"></i> 📝 专属职业报告</div></div>
                                    <div class="col-6"><div class="small opacity-75"><i class="bi bi-shield-check"></i> 🔒 数据隐私保护</div></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-2">

                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift bg-white">
                        <div class="card-body p-4 p-md-4">
                            <h6 class="fw-bold mb-4 text-dark"><i class="bi bi-fire text-danger fs-5 me-2"></i> 热门人格图鉴</h6>

                            <div class="d-flex align-items-center mb-3 p-3 rounded-4" style="background: #f8f9fa;">
                                <div class="bg-primary text-white rounded-circle d-flex justify-content-center align-items-center me-3 type-icon shadow-sm">INTJ</div>
                                <div>
                                    <h6 class="mb-1 fw-bold text-dark">建筑师</h6>
                                    <p class="mb-0 small text-muted">富有想象力和战略性的思想家</p>
                                </div>
                            </div>

                            <div class="d-flex align-items-center p-3 rounded-4" style="background: #f8f9fa;">
                                <div class="bg-success text-white rounded-circle d-flex justify-content-center align-items-center me-3 type-icon shadow-sm">ENFP</div>
                                <div>
                                    <h6 class="mb-1 fw-bold text-dark">竞选者</h6>
                                    <p class="mb-0 small text-muted">热情、有创造力、爱交际的自由灵魂</p>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift data-card position-relative overflow-hidden" style="background-color: #1a1c23;">
                        <div class="card-body p-4 p-md-4 position-relative z-1 d-flex flex-column justify-content-between">
                            <h6 class="fw-bold mb-4 text-white opacity-75"><i class="bi bi-activity text-info fs-5 me-2"></i> 平台运行数据</h6>

                            <div class="row text-center mt-3 flex-grow-1 align-items-center">
                                <div class="col-6 mb-4">
                                    <h2 class="fw-bold mb-1" style="color: #4facfe;">10W+</h2>
                                    <span class="small text-white opacity-50">全网测评总数</span>
                                </div>
                                <div class="col-6 mb-4">
                                    <h2 class="fw-bold mb-1" style="color: #00f2fe;">16</h2>
                                    <span class="small text-white opacity-50">覆盖人格类型</span>
                                </div>
                                <div class="col-6">
                                    <h2 class="fw-bold mb-1" style="color: #a18cd1;">36</h2>
                                    <span class="small text-white opacity-50">标准自测题目</span>
                                </div>
                                <div class="col-6">
                                    <h2 class="fw-bold mb-1" style="color: #fbc2eb;">99%</h2>
                                    <span class="small text-white opacity-50">用户好评率</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift bg-white border-top border-4 border-warning">
                        <div class="card-body p-4 p-md-4 d-flex flex-column">
                            <h6 class="fw-bold mb-3 text-dark"><i class="bi bi-lightbulb text-warning fs-5 me-2"></i> 每日成长箴言</h6>

                            <div class="flex-grow-1 d-flex flex-column justify-content-center px-2">
                                <i class="bi bi-quote fs-1 text-warning opacity-50" style="line-height: 0.5;"></i>
                                <p class="fs-6 text-secondary fst-italic mt-2 mb-4" style="line-height: 1.8; text-indent: 1em;">
                                    认识自己是改变的第一步。不必被性格标签所限制，MBTI 是帮助你理解自我偏好的工具，而非束缚潜能的枷锁。去发掘优势，接纳不足，成为更好的自己。
                                </p>
                            </div>

                            <div class="text-end border-top pt-3 border-light">
                                <span class="badge bg-warning bg-opacity-25 text-dark rounded-pill px-3 py-2 border border-warning border-opacity-50">🌱 持续自我探索</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>