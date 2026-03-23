<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>在线测评 - MBTI</title>
  <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <link href="static/css/style.css" rel="stylesheet">
</head>
<body>

<div class="dashboard-wrapper">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="test"/>
  </jsp:include>

  <div class="main-content">
    <div class="topbar">
      <div class="text-muted">
        考生: <strong>${sessionScope.loginUser.realName}</strong>
        <a href="index.jsp" class="btn btn-sm btn-outline-danger ms-3">退出</a>
      </div>
    </div>

    <div class="container-fluid p-4 p-md-5">
      <div class="row justify-content-center">
        <div class="col-lg-10 col-xl-8">
          <h3 class="fw-bold mb-4">📝 MBTI 在线测评</h3>

          <div class="progress mb-4 shadow-sm" style="height: 12px; border-radius: 10px;">
            <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" style="width: 100%;">请认真作答每一道题</div>
          </div>

          <form action="submitAnswer" method="post">
            <c:forEach items="${requestScope.questionList}" var="q" varStatus="st">
              <div class="card border-0 shadow-sm p-4 rounded-4 mb-4">
                <div class="d-flex align-items-center mb-4 border-bottom pb-3">
                  <span class="badge bg-primary rounded-pill px-3 py-2 me-3 fs-6">第 ${st.count} 题</span>
                  <h5 class="mb-0 fw-bold text-dark">${q.questionText}</h5>
                </div>

                <div class="row g-3">
                  <div class="col-md-6">
                    <input type="radio" name="q${q.id}" id="q${q.id}a" value="${q.optionAType}" class="btn-check" required>
                    <label class="btn btn-outline-primary w-100 text-start p-3 rounded-3 shadow-none h-100" for="q${q.id}a">
                      <span class="fw-bold me-2">A.</span> ${q.optionA}
                    </label>
                  </div>
                  <div class="col-md-6">
                    <input type="radio" name="q${q.id}" id="q${q.id}b" value="${q.optionBType}" class="btn-check">
                    <label class="btn btn-outline-primary w-100 text-start p-3 rounded-3 shadow-none h-100" for="q${q.id}b">
                      <span class="fw-bold me-2">B.</span> ${q.optionB}
                    </label>
                  </div>
                </div>
              </div>
            </c:forEach>

            <div class="text-center mt-5 mb-5">
              <button type="submit" class="btn btn-primary btn-lg px-5 py-3 rounded-pill shadow-lg fw-bold" style="letter-spacing: 2px;">✅ 提交答案并生成报告</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>