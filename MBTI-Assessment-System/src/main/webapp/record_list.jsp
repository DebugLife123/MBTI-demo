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
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">📊 全网测试记录概览</h3>

                <button class="btn btn-primary rounded-pill px-4 shadow-sm fw-bold border-0"
                        style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);"
                        onclick="openAIAnalysisModal()">
                    ✨ AI 团队画像分析
                </button>

                <form action="recordManage" method="get" class="d-flex" style="width: 350px;">
                    <input type="text" name="keyword" value="${requestScope.keyword}" class="form-control rounded-pill me-2 border-primary" placeholder="🔍 搜索账号或真实姓名...">
                    <button type="submit" class="btn btn-primary rounded-pill px-4">搜索</button>
                </form>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4" style="width: 50px;">
                                <input class="form-check-input" type="checkbox" id="selectAll" onclick="toggleAll(this)">
                            </th>
                            <th>序号</th>
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
                                <td class="ps-4">
                                    <input class="form-check-input record-checkbox" type="checkbox" value="${log.resultType}">
                                </td>
                                <td class="text-muted">${(currentPage - 1) * 10 + st.count}</td>
                                <td><code>${log.username}</code></td>
                                <td class="fw-bold">${log.realName}</td>
                                <td class="text-muted"><fmt:formatDate value="${log.testTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <span class="badge bg-success px-3 py-2 fs-6">${log.resultType}</span>
                                </td>
                                <td class="text-muted small">${log.scores}</td>
                                <td class="text-end pe-4">
                                    <a href="recordManage?method=view&id=${log.recordId}" class="btn btn-sm btn-outline-primary me-2">
                                        🔍 查看报告
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-danger"
                                       onclick="confirmAction(event, 'recordManage?method=delete&id=${log.recordId}', '删除此测试记录？', '删除后该学生的此条成绩将从系统中抹除！', '🗑️ 确认删除', '#dc3545')">
                                        🗑️ 删除
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requestScope.logs}">
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">目前暂无学生提交测试记录</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white border-top-0 p-4 rounded-bottom-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted small">
                            共找到 <strong>${totalCount}</strong> 条测评记录，当前第 <strong class="text-primary">${currentPage}</strong> / ${totalPages > 0 ? totalPages : 1} 页
                        </span>

                        <c:if test="${totalPages > 1}">
                            <nav>
                                <ul class="pagination pagination-sm mb-0 shadow-sm">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link px-3" href="recordManage?page=${currentPage - 1}&keyword=${keyword}">上一页</a>
                                    </li>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="recordManage?page=${i}&keyword=${keyword}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link px-3" href="recordManage?page=${currentPage + 1}&keyword=${keyword}">下一页</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="aiAnalysisModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg" style="background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(15px); border-radius: 20px;">

            <div class="modal-header border-0 pb-0 mt-2 px-4">
                <div class="d-flex align-items-center">
                    <div class="me-3 d-flex align-items-center justify-content-center shadow-sm" style="width: 45px; height: 45px; border-radius: 50%; background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%); font-size: 1.4rem; color: white;">✨</div>
                    <div>
                        <h5 class="fw-bold mb-0">AI 团队画像深度分析</h5>
                        <small class="text-muted" id="selectedCountText">已选中 0 份样本</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-4" style="min-height: 300px;">
                <div id="aiLoading" class="text-center mt-5" style="display: none;">
                    <div class="spinner-border text-primary mb-3" role="status" style="width: 3rem; height: 3rem; color: #764ba2 !important;"></div>
                    <h6 class="text-muted fw-bold">AI 正在深度分析样本数据...</h6>
                    <p class="small text-secondary">将为您提供群体倾向、冲突预警及管理建议</p>
                </div>
                <div id="aiReportBox" style="font-size: 0.95rem; line-height: 1.8; color: #333;">
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    /**
     * 原有逻辑：华丽的异步操作确认弹窗
     */
    function confirmAction(event, url, title, text, confirmBtnText, confirmBtnColor) {
        event.preventDefault();
        Swal.fire({
            title: title,
            text: text,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: confirmBtnColor || '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: confirmBtnText || '确定',
            cancelButtonText: '取消',
            background: 'rgba(255, 255, 255, 0.9)',
            backdrop: 'rgba(0,0,0,0.4)',
            borderRadius: '15px'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }

    // 🌟 新增逻辑：全选/反选复选框
    function toggleAll(source) {
        let checkboxes = document.querySelectorAll('.record-checkbox');
        for(let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = source.checked;
        }
    }

    // 🌟 新增逻辑：打开 AI 分析弹窗并请求后端
    function openAIAnalysisModal() {
        // 1. 收集选中的 MBTI 类型
        let selectedTypes = [];
        document.querySelectorAll('.record-checkbox:checked').forEach(cb => {
            if(cb.value && cb.value !== '') selectedTypes.push(cb.value);
        });

        if(selectedTypes.length === 0) {
            Swal.fire('请先勾选', '请在左侧勾选需要进行画像分析的学生记录！', 'info');
            return;
        }

        // 2. 初始化弹窗 UI
        document.getElementById('selectedCountText').innerText = `基于 ${selectedTypes.length} 份有效样本进行分析`;
        document.getElementById('aiLoading').style.display = 'block';
        document.getElementById('aiReportBox').innerHTML = '';

        let aiModal = new bootstrap.Modal(document.getElementById('aiAnalysisModal'));
        aiModal.show();

        // 3. 拼接选中的类型发给后端
        let typesString = selectedTypes.join(",");

        fetch('aiAnalysisServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'types=' + encodeURIComponent(typesString)
        })
            .then(response => response.text())
            .then(data => {
                document.getElementById('aiLoading').style.display = 'none';
                // 解析换行和加粗 Markdown，使排版更漂亮
                let formattedText = data.replace(/\n/g, '<br>').replace(/\*\*(.*?)\*\*/g, '<strong style="color:#764ba2;">$1</strong>');
                document.getElementById('aiReportBox').innerHTML = formattedText;
            })
            .catch(err => {
                document.getElementById('aiLoading').style.display = 'none';
                document.getElementById('aiReportBox').innerHTML = '<span class="text-danger">抱歉，分析过程中网络连接断开了，请稍后再试。</span>';
            });
    }
</script>
</body>
</html>