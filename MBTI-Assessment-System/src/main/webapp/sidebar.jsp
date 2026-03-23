<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 这是一个通用的左侧导航栏组件 --%>
<div class="sidebar">
    <div class="p-4 text-center border-bottom border-secondary mb-3">
        <h4 class="fw-bold mb-0" style="letter-spacing: 1px;">🧩 MBTI 系统</h4>
    </div>

    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="user_dashboard.jsp" class="nav-link ${param.active == 'home' ? 'active' : ''}">
                🏠 我的主页
            </a>
        </li>
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
    </ul>
</div>
