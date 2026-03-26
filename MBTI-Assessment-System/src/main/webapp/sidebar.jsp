<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 这是一个通用的左侧导航栏组件，支持管理员和学生双角色 --%>
<div class="sidebar">
    <div class="p-4 text-center border-bottom border-secondary mb-3">
        <h4 class="fw-bold mb-0" style="letter-spacing: 1px;">🧩 MBTI 系统</h4>
    </div>

    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <c:set var="homeUrl" value="${sessionScope.loginUser.role == 'ADMIN' ? 'adminManage' : 'user_dashboard.jsp'}" />
            <a href="${homeUrl}" class="nav-link ${param.active == 'home' ? 'active' : ''}">
                🏠 系统首页
            </a>
        </li>

        <c:if test="${sessionScope.loginUser.role == 'ADMIN'}">
            <li class="nav-item mt-2">
                <div class="px-3 small text-uppercase opacity-50 mb-2">管理模块</div>
                <a href="questionManage" class="nav-link ${param.active == 'questions' ? 'active' : ''}">
                    📝 题库管理
                </a>
            </li>
            <li class="nav-item">
                <a href="dimensionManage" class="nav-link ${param.active == 'dimensions' ? 'active' : ''}">
                    🧬 性格维度管理
                </a>
            </li>
            <li class="nav-item">
                <a href="userManage" class="nav-link ${param.active == 'users' ? 'active' : ''}">
                    👥 用户管理
                </a>
            </li>
            <li class="nav-item">
                <a href="recordManage" class="nav-link ${param.active == 'records' ? 'active' : ''}">
                    📊 测试概览
                </a>
            </li>
            <li class="nav-item">
                <a href="#" data-bs-toggle="modal" data-bs-target="#testIntroModal" class="nav-link ${param.active == 'test' ? 'active' : ''}">
                    📝 在线测试
                </a>
            </li>
        </c:if>

        <c:if test="${sessionScope.loginUser.role == 'STUDENT' || sessionScope.loginUser.role == 'TEACHER'}">
            <li class="nav-item">
                <a href="#" data-bs-toggle="modal" data-bs-target="#testIntroModal" class="nav-link ${param.active == 'test' ? 'active' : ''}">
                    📝 在线测试
                </a>
            </li>
            <li class="nav-item">
                <a href="history" class="nav-link ${param.active == 'history' ? 'active' : ''}">
                    📊 历史记录
                </a>
            </li>

            <li class="nav-item mt-2">
                <a href="#settingsCollapse" data-bs-toggle="collapse"
                   class="nav-link d-flex justify-content-between align-items-center ${param.active == 'profile' || param.active == 'security' ? 'active' : 'text-white opacity-75'}">
                    <span>⚙️ 个人设置</span>
                    <small>▼</small>
                </a>
                <div class="collapse ${param.active == 'profile' || param.active == 'security' ? 'show' : ''}" id="settingsCollapse">
                    <ul class="nav flex-column ms-3 mt-2" style="border-left: 2px solid rgba(255,255,255,0.2);">
                        <li class="nav-item">
                            <a href="profile" class="nav-link py-1 text-white ${param.active == 'profile' ? 'fw-bold opacity-100' : 'opacity-75'}">
                                👤 个人资料
                            </a>
                        </li>
                        <li class="nav-item mt-1">
                            <a href="security" class="nav-link py-1 text-white ${param.active == 'security' ? 'fw-bold opacity-100' : 'opacity-75'}">
                                🔒 账号与安全
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
        </c:if>

        <c:if test="${sessionScope.loginUser.role == 'ADMIN'}">
            <li class="nav-item mt-2 border-top border-secondary pt-2">
                <a href="profile" class="nav-link ${param.active == 'profile' ? 'active' : ''}">
                    👤 个人资料
                </a>
            </li>
        </c:if>
    </ul>
</div>

<div class="modal fade" id="testIntroModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <h5 class="fw-bold"><i class="bi bi-journal-text text-primary me-2"></i>MBTI 职业性格测试说明</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 px-md-5">
                <div class="mb-4">
                    <h6 class="fw-bold text-dark mb-2">💡 关于 MBTI 测试</h6>
                    <p class="text-muted small" style="line-height: 1.8;">
                        迈尔斯-布里格斯类型指标（MBTI）旨在表明人们在如何看待世界和做出决定方面的不同心理偏好。
                        本测试将从您的真实作答中，评估您在四大维度（外倾/内倾、感觉/直觉、思考/情感、判断/感知）的偏好倾向。
                    </p>
                </div>

                <div class="mb-4">
                    <h6 class="fw-bold text-dark mb-2">⚠️ 免责声明</h6>
                    <p class="text-muted small" style="line-height: 1.8;">
                        1. 本测试结果仅供个人成长、职业规划及心理探索参考，不具备临床医学或精神病学诊断效力。<br>
                        2. 性格没有绝对的好坏之分，测试结果仅代表您当下的心理偏好，不能完全代表您的全部潜能与未来发展。
                    </p>
                </div>

                <div class="mb-4">
                    <h6 class="fw-bold text-dark mb-2">🔒 隐私与数据安全保护</h6>
                    <p class="text-muted small" style="line-height: 1.8;">
                        我们郑重承诺：您的作答数据及最终生成的性格报告将严格加密存储，仅供您个人查看与系统生成分析使用，绝不会泄露给任何第三方机构。
                    </p>
                </div>

                <div class="form-check mt-4 p-3 bg-light rounded-3 border">
                    <input class="form-check-input ms-1" type="checkbox" id="agreeCheckbox" onchange="toggleTestBtn()">
                    <label class="form-check-label ms-2 fw-bold text-dark" for="agreeCheckbox" style="cursor: pointer; user-select: none;">
                        我已阅读并完全同意以上说明及隐私保护政策
                    </label>
                </div>
            </div>
            <div class="modal-footer border-0 pb-4 px-4 px-md-5 d-flex justify-content-between">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">暂不测试</button>
                <button type="button" id="startTestBtn" class="btn btn-primary rounded-pill px-5 shadow-sm disabled" onclick="startLoadingTest()">
                    开始测试
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // 监听复选框，控制按钮的点亮与禁用
    function toggleTestBtn() {
        const checkbox = document.getElementById('agreeCheckbox');
        const btn = document.getElementById('startTestBtn');
        if (checkbox.checked) {
            btn.classList.remove('disabled');
        } else {
            btn.classList.add('disabled');
        }
    }

    // 点击开始测试后的加载动效与跳转
    function startLoadingTest() {
        const btn = document.getElementById('startTestBtn');
        // 改变按钮状态和文字，呈现“加载中”动效
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>正在随机生成题库中...';
        btn.classList.add('disabled');

        // 延迟 1.5 秒后跳转到后端的真实测试接口 (startTest)
        setTimeout(() => {
            window.location.href = 'startTest';
        }, 1500);
    }
</script>