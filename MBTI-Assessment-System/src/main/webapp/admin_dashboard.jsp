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
                                <%-- 头像逻辑：优先显示上传的头像，否则生成随机头像 --%>
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

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
    // =========================================================
    // 1. 初始化左侧：MBTI 维度全网平均倾向 (饼图)
    // =========================================================
    var myChart = echarts.init(document.getElementById('dimPieChart'));

    // 接收后端传来的维度平均分数据
    var eVal = ${eAvg != null ? eAvg : 0.0};
    var iVal = ${iAvg != null ? iAvg : 0.0};
    var sVal = ${sAvg != null ? sAvg : 0.0};
    var nVal = ${nAvg != null ? nAvg : 0.0};
    var tVal = ${tAvg != null ? tAvg : 0.0};
    var fVal = ${fAvg != null ? fAvg : 0.0};
    var jVal = ${jAvg != null ? jAvg : 0.0};
    var pVal = ${pAvg != null ? pAvg : 0.0};

    var option = {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b} : {c} 分 ({d}%)'
        },
        legend: {
            orient: 'vertical',
            left: 'left',
            data: ['E-外倾', 'I-内倾', 'S-感觉', 'N-直觉', 'T-思考', 'F-情感', 'J-判断', 'P-感知']
        },
        series: [
            {
                name: '全网平均分',
                type: 'pie',
                radius: '65%',
                center: ['50%', '60%'],
                data: [
                    { value: eVal, name: 'E-外倾' },
                    { value: iVal, name: 'I-内倾' },
                    { value: sVal, name: 'S-感觉' },
                    { value: nVal, name: 'N-直觉' },
                    { value: tVal, name: 'T-思考' },
                    { value: fVal, name: 'F-情感' },
                    { value: jVal, name: 'J-判断' },
                    { value: pVal, name: 'P-感知' }
                ],
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }
        ],
        responsive: true
    };
    myChart.setOption(option);

    // =========================================================
    // 2. 初始化右侧：人群分布排行 (高级柱状图)
    // =========================================================
    var typeBarChart = echarts.init(document.getElementById('typeBarChart'));

    // 接收后端生成的 JSON 数组字符串 (如没有数据，则渲染空数组 [])
    var barNames = ${typeBarNames != null ? typeBarNames : "[]"};
    var barValues = ${typeBarValues != null ? typeBarValues : "[]"};

    var barOption = {
        tooltip: {
            trigger: 'axis',
            axisPointer: { type: 'shadow' } // 鼠标移入显示阴影
        },
        grid: { left: '3%', right: '4%', bottom: '5%', containLabel: true },
        xAxis: {
            type: 'category',
            data: barNames,
            axisLabel: {
                interval: 0,
                rotate: 30, // 标签倾斜，防止 16 个类型文字重叠
                fontWeight: 'bold',
                color: '#555'
            },
            axisTick: { alignWithLabel: true }
        },
        yAxis: { type: 'value', name: '测试人数 (人)' },
        series: [{
            name: '人数',
            type: 'bar',
            barWidth: '55%',
            data: barValues,
            label: {
                show: true, // 在柱子顶部显示数字
                position: 'top',
                color: '#188df0',
                fontWeight: 'bold'
            },
            itemStyle: {
                // 设置炫酷的渐变蓝柱子
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                    { offset: 0, color: '#83bff6' },
                    { offset: 0.5, color: '#188df0' },
                    { offset: 1, color: '#0b5ed7' }
                ]),
                borderRadius: [6, 6, 0, 0] // 顶部圆角
            }
        }]
    };
    typeBarChart.setOption(barOption);

    // =========================================================
    // 3. 监听浏览器窗口调整，使两个图表都实现自适应重绘
    // =========================================================
    window.addEventListener('resize', function() {
        myChart.resize();
        typeBarChart.resize();
    });
</script>

</body>
</html>