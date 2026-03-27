<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>测评报告 - MBTI 职业性格测试</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/echarts/5.4.3/echarts.min.js"></script>
</head>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="test"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar">
            <div class="text-muted">
                当前用户: <strong>${sessionScope.loginUser.realName}</strong>
                <a href="index.jsp" class="btn btn-sm btn-outline-danger ms-3">退出</a>
            </div>
        </div>

        <div class="container-fluid p-4 p-md-5">
            <div class="row justify-content-center">
                <div class="col-md-10 col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 text-center p-5 mb-5">
                        <div class="mb-4"><span class="display-3 text-success">🏆</span></div>
                        <h3 class="fw-bold mb-4">测评分析报告</h3>

                        <p class="text-secondary mb-3">根据您的作答，您的核心人格为：</p>

                        <div class="py-4 bg-primary bg-opacity-10 rounded-4 mb-4">
                            <h1 class="display-2 fw-bold text-primary mb-0">${requestScope.myResult}</h1>
                            <h4 class="text-secondary mt-2">${requestScope.personality.title}</h4>
                        </div>

                        <div class="mt-4 mb-4">
                            <div id="radarChart" style="width: 100%; height: 400px;"></div>
                        </div>

                        <div class="mt-2 mb-5">
                            <h6 class="text-muted mb-3">📊 维度得分详情：</h6>
                            <div class="row g-2 text-center">
                                <div class="col-3"><div class="p-2 bg-light border rounded small">E: ${requestScope.scores.eScore} / I: ${requestScope.scores.iScore}</div></div>
                                <div class="col-3"><div class="p-2 bg-light border rounded small">S: ${requestScope.scores.sScore} / N: ${requestScope.scores.nScore}</div></div>
                                <div class="col-3"><div class="p-2 bg-light border rounded small">T: ${requestScope.scores.tScore} / F: ${requestScope.scores.fScore}</div></div>
                                <div class="col-3"><div class="p-2 bg-light border rounded small">J: ${requestScope.scores.jScore} / P: ${requestScope.scores.pScore}</div></div>
                            </div>
                        </div>

                        <div class="text-start bg-light p-4 rounded-3 mb-4 border-start border-4 border-primary">
                            <h5 class="fw-bold mb-3">🔍 性格概览</h5>
                            <p class="text-muted leading-relaxed mb-0">${requestScope.personality.description}</p>
                        </div>

                        <div class="text-start bg-light p-4 rounded-3 mb-4 border-start border-4 border-success">
                            <h5 class="fw-bold mb-3">💼 职业发展建议</h5>
                            <p class="text-muted leading-relaxed mb-0">${requestScope.personality.careerAdvice}</p>
                        </div>

                        <div class="mt-4">
                            <button onclick="window.print()" class="btn btn-primary px-4 shadow-sm me-2">保存报告 (PDF)</button>
                            <a href="history" class="btn btn-outline-secondary px-4">查看历史记录</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function() {
        // 初始化 ECharts 实例
        var radarChart = echarts.init(document.getElementById('radarChart'));

        // 接收后端传来的个人分数 (如果为空则默认为0)
        var scores = [
            ${requestScope.scores.eScore != null ? requestScope.scores.eScore : 0},
            ${requestScope.scores.sScore != null ? requestScope.scores.sScore : 0},
            ${requestScope.scores.tScore != null ? requestScope.scores.tScore : 0},
            ${requestScope.scores.jScore != null ? requestScope.scores.jScore : 0},
            ${requestScope.scores.iScore != null ? requestScope.scores.iScore : 0},
            ${requestScope.scores.nScore != null ? requestScope.scores.nScore : 0},
            ${requestScope.scores.fScore != null ? requestScope.scores.fScore : 0},
            ${requestScope.scores.pScore != null ? requestScope.scores.pScore : 0}
        ];

        // 图表配置项
        var option = {
            title: {
                text: '八大维度倾向分析雷达',
                left: 'center',
                textStyle: { color: '#495057', fontSize: 16 }
            },
            tooltip: {
                trigger: 'item',
                backgroundColor: 'rgba(255, 255, 255, 0.9)',
                borderColor: '#ccc',
                borderWidth: 1,
                textStyle: { color: '#333' }
            },
            radar: {
                // 每组题最多 7 分，设置最大值为 7 保证图表比例饱满且准确
                indicator: [
                    { name: '外倾 (E)', max: 7 },
                    { name: '感觉 (S)', max: 7 },
                    { name: '思考 (T)', max: 7 },
                    { name: '判断 (J)', max: 7 },
                    { name: '内倾 (I)', max: 7 },
                    { name: '直觉 (N)', max: 7 },
                    { name: '情感 (F)', max: 7 },
                    { name: '感知 (P)', max: 7 }
                ],
                shape: 'polygon', // 多边形外观
                splitNumber: 4,
                axisName: {
                    color: '#fff',
                    backgroundColor: '#6c757d',
                    borderRadius: 3,
                    padding: [3, 6],
                    fontWeight: 'bold'
                },
                splitArea: {
                    areaStyle: {
                        color: ['rgba(250,250,250,0.3)', 'rgba(200,200,200,0.1)']
                    }
                },
                axisLine: { lineStyle: { color: 'rgba(0, 0, 0, 0.1)' } },
                splitLine: { lineStyle: { color: 'rgba(0, 0, 0, 0.1)' } }
            },
            series: [{
                name: '个人维度得分',
                type: 'radar',
                data: [{
                    value: scores,
                    name: '得分详情',
                    itemStyle: { color: '#4e73df' }, // 漂亮的渐变蓝
                    lineStyle: { width: 3 },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(78, 115, 223, 0.6)' },
                            { offset: 1, color: 'rgba(78, 115, 223, 0.1)' }
                        ])
                    }
                }]
            }]
        };

        // 渲染图表
        radarChart.setOption(option);

        // 窗口缩放时自适应
        window.addEventListener('resize', function() {
            radarChart.resize();
        });
    });
</script>
</body>
</html>