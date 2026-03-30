<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员控制台 - MBTI职业性格测试系统</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/echarts/5.4.3/echarts.min.js"></script>

    <style>
        /* 悬浮机器人容器 */
        .ai-expert-widget {
            position: fixed;
            top: 90px; /* 控制距离顶部的高度 */
            right: 40px; /* 控制距离右侧的宽度 */
            z-index: 1040;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .ai-expert-widget:hover {
            transform: scale(1.1);
        }

        /* 机器人发光背景与浮动动画 */
        .ai-avatar-wrapper {
            position: relative;
            width: 75px;
            height: 75px;
            animation: floatRobot 3.5s ease-in-out infinite;
        }
        .ai-avatar-wrapper::before {
            content: '';
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            width: 100%; height: 100%;
            background: radial-gradient(circle, rgba(118,75,162,0.4) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
            z-index: -1;
            animation: pulseGlow 2s infinite alternate;
        }
        .ai-avatar {
            width: 100%;
            height: 100%;
            filter: drop-shadow(0 10px 15px rgba(0,0,0,0.2));
        }

        /* 提示气泡 */
        .ai-tooltip {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(5px);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 800;
            color: #764ba2;
            box-shadow: 0 4px 15px rgba(118,75,162,0.15);
            border: 2px solid #e0c3fc;
            animation: floatTooltip 3.5s ease-in-out infinite;
            position: relative;
        }
        .ai-tooltip::after {
            content: '';
            position: absolute;
            right: -8px;
            top: 50%;
            transform: translateY(-50%);
            border-width: 6px 0 6px 8px;
            border-style: solid;
            border-color: transparent transparent transparent #e0c3fc;
        }

        /* 动画关键帧 */
        @keyframes floatRobot {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-12px); }
            100% { transform: translateY(0px); }
        }
        @keyframes floatTooltip {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-8px); }
            100% { transform: translateY(0px); }
        }
        @keyframes pulseGlow {
            0% { transform: translate(-50%, -50%) scale(1); opacity: 0.5; }
            100% { transform: translate(-50%, -50%) scale(1.3); opacity: 1; }
        }

        /* 聊天气泡样式 */
        .admin-chat-bubble {
            max-width: 85%; padding: 12px 16px; border-radius: 16px;
            font-size: 0.95rem; line-height: 1.6; word-wrap: break-word; box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .admin-ai-msg { background: #fff; border: 1px solid #eee; border-top-left-radius: 2px; }
        .admin-user-msg { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; border-top-right-radius: 2px; margin-left: auto; }

        /* 侧边栏滚动条美化 */
        #adminChatBox::-webkit-scrollbar { width: 5px; }
        #adminChatBox::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.1); border-radius: 10px; }
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
                管理员: <strong>${sessionScope.loginUser.realName}</strong>
                <a href="index.jsp" class="btn btn-sm btn-outline-danger ms-3">退出系统</a>
            </div>
        </div>

        <div class="ai-expert-widget" onclick="openAdminAIChat()">
            <div class="ai-tooltip">遇到管理难题？<br>点击问问我！</div>
            <div class="ai-avatar-wrapper">
                <img src="https://api.dicebear.com/7.x/bottts/svg?seed=ManagerBot&backgroundColor=transparent&primaryColor=764ba2" alt="AI" class="ai-avatar">
            </div>
        </div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">📊 管理员看板</h3>

            <div class="row mb-4">
                <div class="col-md-6 col-lg-4 mb-3" style="cursor: pointer;" onclick="location.href='questionManage'">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100 border-start border-primary border-4">
                        <div class="d-flex align-items-center">
                            <div class="rounded-circle bg-primary bg-opacity-10 p-3 me-3"><span class="fs-3">📝</span></div>
                            <div>
                                <h6 class="text-muted mb-1">题库总数</h6>
                                <h4 class="fw-bold mb-0">${qCount} 道</h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 mb-3" style="cursor: pointer;" onclick="location.href='recordManage'">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100 border-start border-success border-4">
                        <div class="d-flex align-items-center">
                            <div class="rounded-circle bg-success bg-opacity-10 p-3 me-3"><span class="fs-3">📈</span></div>
                            <div>
                                <h6 class="text-muted mb-1">系统测评记录</h6>
                                <h4 class="fw-bold mb-0">${logs != null ? logs.size() : 0} 条</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-5 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-body p-4">
                            <h5 class="fw-bold border-bottom pb-3 mb-4">👤 管理员信息</h5>
                            <div class="d-flex align-items-center mb-4">
                                <c:set var="avatarSrc" value="${empty sessionScope.loginUser.avatar ? 'https://api.dicebear.com/7.x/adventurer/svg?seed=' += sessionScope.loginUser.username : sessionScope.loginUser.avatar}" />
                                <img src="${avatarSrc}" class="rounded-circle me-3 border shadow-sm" style="width: 70px; height: 70px; object-fit: cover;">
                                <div>
                                    <h5 class="mb-0 fw-bold">${sessionScope.loginUser.realName}</h5>
                                    <span class="badge bg-danger bg-opacity-75 mt-1">系统管理员</span>
                                </div>
                            </div>
                            <div class="space-y-2">
                                <p class="mb-2 text-muted"><strong>管理账号：</strong> ${sessionScope.loginUser.username}</p>
                                <p class="mb-2 text-muted"><strong>注册时间：</strong> <fmt:formatDate value="${sessionScope.loginUser.createTime}" pattern="yyyy-MM-dd"/></p>
                                <p class="mb-0 text-muted small text-primary italic">💡 您拥有最高管理权限，请谨慎操作数据。</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100 bg-light">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-4">⚡ 快捷操作区</h5>
                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <div class="p-4 bg-white rounded-4 text-center border">
                                        <div class="fs-2 mb-2">📋</div>
                                        <h6 class="fw-bold">题库维护</h6>
                                        <p class="small text-muted mb-3">更新、添加或删除测试题目</p>
                                        <a href="questionManage" class="btn btn-primary w-100 rounded-pill shadow-sm">进入题库管理</a>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="p-4 bg-white rounded-4 text-center border">
                                        <div class="fs-2 mb-2">📄</div>
                                        <h6 class="fw-bold">成绩报表</h6>
                                        <p class="small text-muted mb-3">查看并分析所有学生测评详情</p>
                                        <a href="exportExcel" class="btn btn-outline-primary w-100 rounded-pill shadow-sm">
                                            ⬇️ 导出真实 Excel 报表
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4 w-100 m-0 p-0">
                    <div class="col-12 col-xl-5 mb-4 ps-0">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-body p-4">
                                <h5 class="fw-bold mb-4">全网学生性格维度平均分</h5>
                                <div id="dimPieChart" style="width: 100%; height: 400px;"></div>
                                <p class="text-muted small mt-3 text-center">💡 提示：此图表反映了考生的平均性格倾向倾向。</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-xl-7 mb-4 pe-0">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-body p-4">
                                <h5 class="fw-bold mb-4">👑 核心人格 (MBTI) 分布排行</h5>
                                <div id="typeBarChart" style="width: 100%; height: 400px;"></div>
                                <p class="text-muted small mt-3 text-center">💡 提示：按人数降序排列，直观展示本校最高频性格。</p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<div class="offcanvas offcanvas-end shadow-lg" tabindex="-1" id="adminAIChatPanel" style="width: 420px; border-radius: 20px 0 0 20px; border-left: none;">
    <div class="offcanvas-header border-bottom" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
        <div class="d-flex align-items-center">
            <div class="bg-white rounded-circle d-flex align-items-center justify-content-center me-2 shadow-sm" style="width: 35px; height: 35px; font-size: 1.2rem;">🤖</div>
            <h5 class="offcanvas-title fw-bold mb-0">AI 团队管理智囊</h5>
        </div>
        <button type="button" class="btn-close btn-close-white shadow-none" data-bs-dismiss="offcanvas"></button>
    </div>
    <div class="offcanvas-body d-flex flex-column p-3" style="background-color: #f8f9fa;">

        <div id="adminChatBox" class="flex-grow-1 overflow-auto mb-3 pe-2">
            <div class="d-flex w-100 mb-3 justify-content-start">
                <div class="admin-chat-bubble admin-ai-msg">
                    您好，管理员！✨<br><br>
                    我已深度学习了组织行为学与 MBTI 理论体系。关于<strong>排班组合、性格冲突解决、团队领导力评估</strong>，您有任何疑问都可以直接问我！<br>
                    <small class="text-muted mt-2 d-block">💡 试着问：“如何管理一个全是 INTJ 的技术团队？”</small>
                </div>
            </div>
        </div>

        <div id="adminTyping" class="mb-2 ms-2 text-muted small fw-bold" style="display: none;">
            <span class="spinner-grow spinner-grow-sm text-primary me-1" role="status"></span> AI 专家正在思考对策...
        </div>

        <div class="mt-auto bg-white rounded-pill shadow-sm border p-1 d-flex align-items-center">
            <input type="text" id="adminChatInput" class="form-control border-0 shadow-none px-3 bg-transparent"
                   placeholder="描述您遇到的团队管理问题..." onkeypress="handleAdminEnter(event)">
            <button class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm" onclick="sendAdminMsg()" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none;">
                发送
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
    // =========================================================
    // 1. ECharts 渲染逻辑 (完全保持原样)
    // =========================================================
    var myChart = echarts.init(document.getElementById('dimPieChart'));
    var eVal = ${eAvg != null ? eAvg : 0.0};
    var iVal = ${iAvg != null ? iAvg : 0.0};
    var sVal = ${sAvg != null ? sAvg : 0.0};
    var nVal = ${nAvg != null ? nAvg : 0.0};
    var tVal = ${tAvg != null ? tAvg : 0.0};
    var fVal = ${fAvg != null ? fAvg : 0.0};
    var jVal = ${jAvg != null ? jAvg : 0.0};
    var pVal = ${pAvg != null ? pAvg : 0.0};

    var option = {
        tooltip: { trigger: 'item', formatter: '{a} <br/>{b} : {c} 分 ({d}%)' },
        legend: { orient: 'vertical', left: 'left', data: ['E-外倾', 'I-内倾', 'S-感觉', 'N-直觉', 'T-思考', 'F-情感', 'J-判断', 'P-感知'] },
        series: [{
            name: '全网平均分', type: 'pie', radius: '65%', center: ['50%', '60%'],
            data: [
                { value: eVal, name: 'E-外倾' }, { value: iVal, name: 'I-内倾' },
                { value: sVal, name: 'S-感觉' }, { value: nVal, name: 'N-直觉' },
                { value: tVal, name: 'T-思考' }, { value: fVal, name: 'F-情感' },
                { value: jVal, name: 'J-判断' }, { value: pVal, name: 'P-感知' }
            ],
            emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } }
        }],
        responsive: true
    };
    myChart.setOption(option);

    var typeBarChart = echarts.init(document.getElementById('typeBarChart'));
    var barNames = ${typeBarNames != null ? typeBarNames : "[]"};
    var barValues = ${typeBarValues != null ? typeBarValues : "[]"};
    var barOption = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '4%', bottom: '5%', containLabel: true },
        xAxis: { type: 'category', data: barNames, axisLabel: { interval: 0, rotate: 30, fontWeight: 'bold', color: '#555' }, axisTick: { alignWithLabel: true } },
        yAxis: { type: 'value', name: '测试人数 (人)' },
        series: [{
            name: '人数', type: 'bar', barWidth: '55%', data: barValues,
            label: { show: true, position: 'top', color: '#188df0', fontWeight: 'bold' },
            itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                    { offset: 0, color: '#83bff6' }, { offset: 0.5, color: '#188df0' }, { offset: 1, color: '#0b5ed7' }
                ]),
                borderRadius: [6, 6, 0, 0]
            }
        }]
    };
    typeBarChart.setOption(barOption);

    window.addEventListener('resize', function() {
        myChart.resize(); typeBarChart.resize();
    });

    // =========================================================
    // 🌟 2. 新增：AI 管理专家交互逻辑
    // =========================================================
    function openAdminAIChat() {
        var chatPanel = new bootstrap.Offcanvas(document.getElementById('adminAIChatPanel'));
        chatPanel.show();
    }

    function handleAdminEnter(e) { if (e.key === 'Enter') sendAdminMsg(); }

    function sendAdminMsg() {
        var inputObj = document.getElementById('adminChatInput');
        var text = inputObj.value.trim();
        if (!text) return;

        // 1. 渲染用户消息
        appendAdminMsg(text, true);
        inputObj.value = '';
        document.getElementById('adminTyping').style.display = 'block';

        // 为了保证它按照“管理专家”的视角回答，我们在请求时隐式拼接前缀上下文，但不展示给用户
        var contextText = "作为资深团队管理与MBTI专家，请回答管理员的问题：" + text;

        // 2. 发起请求复用已有的 chatServlet
        fetch('chatServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'message=' + encodeURIComponent(contextText)
        })
            .then(response => response.text())
            .then(data => {
                document.getElementById('adminTyping').style.display = 'none';
                // 简单处理 markdown 换行与加粗
                var formatted = data.replace(/\n/g, '<br>').replace(/\*\*(.*?)\*\*/g, '<strong style="color:#764ba2;">$1</strong>');
                appendAdminMsg(formatted, false);
            })
            .catch(err => {
                document.getElementById('adminTyping').style.display = 'none';
                appendAdminMsg("连接神经中枢失败，请检查网络或控制台报错。", false);
            });
    }

    function appendAdminMsg(text, isUser) {
        var box = document.getElementById('adminChatBox');
        var div = document.createElement('div');

        // 使用传统的加号拼接，防止被 JSP 的 EL 表达式当成后端变量吃掉
        var alignClass = isUser ? "justify-content-end" : "justify-content-start";
        div.className = "d-flex w-100 mb-4 " + alignClass;

        var bubbleClass = isUser ? "admin-user-msg" : "admin-ai-msg";
        var bubbleHTML = '<div class="admin-chat-bubble ' + bubbleClass + '">' + text + '</div>';

        // 如果是AI回复，左侧加个小头像
        if (!isUser) {
            var avatarHTML = '<div class="rounded-circle bg-white shadow-sm d-flex align-items-center justify-content-center me-2" style="width: 30px; height: 30px; font-size: 0.9rem; flex-shrink: 0;">🤖</div>';
            bubbleHTML = avatarHTML + bubbleHTML;
        }

        div.innerHTML = bubbleHTML;
        box.appendChild(div);
        box.scrollTop = box.scrollHeight;
    }
</script>

</body>
</html>