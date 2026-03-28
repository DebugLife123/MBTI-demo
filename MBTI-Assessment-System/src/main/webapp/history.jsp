<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>历史记录 - MBTI</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/style.css" rel="stylesheet">
</head>
<body>

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="history"/>
    </jsp:include>

    <div class="main-content">
        <div class="topbar">
            <div class="text-muted">
                当前用户: <strong>${sessionScope.loginUser.realName}</strong>
            </div>
        </div>

        <div class="container-fluid p-4 p-md-5">
            <h3 class="fw-bold mb-4">📊 我的测试记录</h3>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4">序号</th>
                            <th>测试时间</th>
                            <th>人格类型</th>
                            <th>维度得分 (E/I-S/N-T/F-J/P)</th>
                            <th class="text-end pe-4">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty requestScope.records}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">您还没有进行过测试，快去测一测吧！</td>
                            </tr>
                        </c:if>

                        <c:forEach items="${requestScope.records}" var="record" varStatus="st">
                            <tr>
                                <td class="ps-4">${st.count}</td>
                                <td><fmt:formatDate value="${record.testTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <span class="badge bg-primary px-3 py-2 fs-6">${record.resultType}</span>
                                </td>
                                <td class="text-muted small">
                                    E:${record.eScore}/I:${record.iScore} | S:${record.sScore}/N:${record.nScore} | T:${record.tScore}/F:${record.fScore} | J:${record.jScore}/P:${record.pScore}
                                </td>
                                <td class="text-end pe-4">
                                    <a href="history?action=view&id=${record.id}"
                                       class="btn btn-sm btn-outline-primary me-2">
                                        📄 查看报告
                                    </a>

                                    <a href="#" class="btn btn-sm btn-outline-danger"
                                       onclick="confirmAction(event, 'history?action=delete&id=${record.id}', '删除这条记录？', '删除后将无法查看此份报告，操作不可恢复。', '🗑️ 确认删除', '#dc3545')">
                                        🗑️ 删除
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    /**
     * 华丽的异步操作确认弹窗
     * @param event 鼠标点击事件
     * @param url 确认后要跳转的后端地址
     * @param title 弹窗标题
     * @param text 弹窗提示正文
     * @param confirmBtnText 确认按钮的文字
     * @param confirmBtnColor 确认按钮的颜色 (支持16进制)
     */
    function confirmAction(event, url, title, text, confirmBtnText, confirmBtnColor) {
        // 🌟 1. 阻止 <a> 标签的默认直接跳转行为
        event.preventDefault();

        // 🌟 2. 呼出 SweetAlert2 弹窗
        Swal.fire({
            title: title,
            text: text,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: confirmBtnColor || '#d33', // 默认红色
            cancelButtonColor: '#6c757d', // 默认灰色
            confirmButtonText: confirmBtnText || '确定',
            cancelButtonText: '取消',
            background: 'rgba(255, 255, 255, 0.9)', // 配合你的毛玻璃 UI 微调背景
            backdrop: 'rgba(0,0,0,0.4)',
            borderRadius: '15px'
        }).then((result) => {
            // 🌟 3. 如果用户点击了确认，通过 JS 执行跳转
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }
</script>
</body>
</html>