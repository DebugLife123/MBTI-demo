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
                <a href="recordManage" class="nav-link ${param.active == 'records' ? 'active' : ''}">
                    📊 测试概览
                </a>
            </li>
            <li class="nav-item">
                <a href="startTest" class="nav-link ${param.active == 'test' ? 'active' : ''}">
                    📝 在线测试
                </a>
            </li>
        </c:if>

        <c:if test="${sessionScope.loginUser.role == 'STUDENT'}">
            <li class="nav-item">
                <a href="startTest" class="nav-link ${param.active == 'test' ? 'active' : ''}">
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