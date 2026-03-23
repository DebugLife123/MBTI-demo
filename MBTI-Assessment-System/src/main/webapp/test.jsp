<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>在线测评 - MBTI</title>
</head>
<body class="bg-light">
<%-- 引用头部 --%>
<%@ include file="header.jsp" %>

<div class="container mt-4">
  <div class="row justify-content-center">
    <div class="col-lg-8">
      <div class="progress mb-5 shadow-sm" style="height: 15px; border-radius: 10px;">
        <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" style="width: 60%;">正在测评中...</div>
      </div>

      <form action="submitAnswer" method="post">
        <%-- 核心：循环生成所有题目 --%>
        <c:forEach items="${requestScope.questionList}" var="q" varStatus="st">
          <div class="card border-0 shadow-sm p-4 rounded-3 mb-4">
            <div class="d-flex align-items-center mb-4 border-bottom pb-3">
              <span class="badge bg-primary rounded-pill px-3 py-2 me-3">第 ${st.count} 题</span>
              <h4 class="mb-0 fw-bold">${q.questionText}</h4>
            </div>

            <div class="row g-3">
              <div class="col-12">
                <input type="radio" name="q${q.id}" id="q${q.id}a" value="${q.optionAType}" class="btn-check" required>
                <label class="btn btn-outline-primary w-100 text-start p-3 rounded-3 shadow-none" for="q${q.id}a">
                  <span class="fw-bold me-2 text-uppercase">A.</span> ${q.optionA}
                </label>
              </div>
              <div class="col-12">
                <input type="radio" name="q${q.id}" id="q${q.id}b" value="${q.optionBType}" class="btn-check">
                <label class="btn btn-outline-primary w-100 text-start p-3 rounded-3 shadow-none" for="q${q.id}b">
                  <span class="fw-bold me-2 text-uppercase">B.</span> ${q.optionB}
                </label>
              </div>
            </div>
          </div>
        </c:forEach>

        <div class="text-center mt-5 mb-5">
          <button type="submit" class="btn btn-primary btn-lg px-5 rounded-pill shadow-lg">提交全部答案，查看结果 →</button>
        </div>
      </form>
    </div>
  </div>
</div>
</body>
</html>