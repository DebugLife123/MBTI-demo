<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>在线测评 - MBTI</title>
  <link href="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <link href="static/css/style.css" rel="stylesheet">
  <style>
    /* 隐藏除了当前题之外的所有题目 */
    .question-card {
      display: none;
      animation: fadeIn 0.4s ease-in-out;
    }
    /* 激活状态的题目显示出来 */
    .question-card.active {
      display: block;
    }
    /* 淡入动画，切换题目时更平滑 */
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
    /* 美化选中状态 */
    .btn-check:checked + .btn-outline-primary {
      background-color: #0d6efd;
      color: #fff;
      transform: scale(1.02);
      box-shadow: 0 4px 15px rgba(13, 110, 253, 0.3);
      border-color: #0d6efd;
    }
    .option-label {
      transition: all 0.2s;
    }
  </style>
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

          <div class="d-flex justify-content-between align-items-end mb-3">
            <h3 class="fw-bold mb-0">📝 MBTI 在线测评</h3>
            <span id="progressText" class="text-muted fw-bold">1 / ${requestScope.questionList.size()}</span>
          </div>

          <div class="progress mb-4 shadow-sm" style="height: 12px; border-radius: 10px;">
            <div id="dynamicProgressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-success" style="width: 0%; transition: width 0.4s ease;"></div>
          </div>

          <form id="testForm" action="submitAnswer" method="post">

            <c:forEach items="${requestScope.questionList}" var="q" varStatus="st">
              <div class="card border-0 shadow-sm p-4 rounded-4 mb-4 question-card ${st.index == 0 ? 'active' : ''}" id="q-card-${st.index}">
                <div class="d-flex align-items-center mb-4 border-bottom pb-3">
                  <span class="badge bg-primary rounded-pill px-3 py-2 me-3 fs-6">第 ${st.count} 题</span>
                  <h5 class="mb-0 fw-bold text-dark">${q.questionText}</h5>
                </div>

                <div class="row g-3">
                  <div class="col-md-6">
                    <input type="radio" name="q${q.id}" id="q${q.id}a" value="${q.optionAType}" class="btn-check option-radio">
                    <label class="btn btn-outline-primary w-100 text-start p-4 rounded-3 shadow-none h-100 option-label fs-6" for="q${q.id}a">
                      <span class="fw-bold me-2 fs-5">A.</span> ${q.optionA}
                    </label>
                  </div>
                  <div class="col-md-6">
                    <input type="radio" name="q${q.id}" id="q${q.id}b" value="${q.optionBType}" class="btn-check option-radio">
                    <label class="btn btn-outline-primary w-100 text-start p-4 rounded-3 shadow-none h-100 option-label fs-6" for="q${q.id}b">
                      <span class="fw-bold me-2 fs-5">B.</span> ${q.optionB}
                    </label>
                  </div>
                </div>
              </div>
            </c:forEach>

            <div class="d-flex justify-content-between mt-5 mb-5 align-items-center">
              <button type="button" id="prevBtn" class="btn btn-outline-secondary btn-lg px-4 rounded-pill" style="display: none;" onclick="navigate(-1)">⬅️ 上一题</button>

              <div class="ms-auto">
                <button type="button" id="nextBtn" class="btn btn-primary btn-lg px-5 rounded-pill shadow" onclick="navigate(1)">下一题 ➡️</button>
                <button type="button" id="submitBtn" class="btn btn-success btn-lg px-5 rounded-pill shadow-lg fw-bold" style="display: none; letter-spacing: 2px;" onclick="submitForm()">✅ 提交答案并生成报告</button>
              </div>
            </div>
          </form>

        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.staticfile.org/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
  let currentTab = 0; // 当前展示的题目索引
  const totalQuestions = ${requestScope.questionList.size()}; // 题目总数
  const cards = document.querySelectorAll('.question-card'); // 所有题目卡片

  // 初始化页面
  updateUI();

  // 核心导航函数：n=1为下一题，n=-1为上一题
  function navigate(n) {
    // 如果是点击下一题，先校验当前题是否已经作答
    if (n === 1 && !validateCurrentQuestion()) {
      alert("请先选择一个选项后再进入下一题哦！");
      return;
    }

    // 隐藏当前题
    cards[currentTab].classList.remove('active');

    // 增加或减少索引
    currentTab = currentTab + n;

    // 显示新的一题
    cards[currentTab].classList.add('active');

    // 更新 UI 界面（进度条和按钮）
    updateUI();
  }

  // 校验当前题目是否选择了答案
  function validateCurrentQuestion() {
    const currentCard = cards[currentTab];
    const radios = currentCard.querySelectorAll('input[type="radio"]');
    for (let radio of radios) {
      if (radio.checked) return true;
    }
    return false;
  }

  // 更新按钮状态和进度条
  function updateUI() {
    // 1. 处理上一题按钮
    if (currentTab === 0) {
      document.getElementById('prevBtn').style.display = 'none';
    } else {
      document.getElementById('prevBtn').style.display = 'inline-block';
    }

    // 2. 处理下一题 / 提交按钮
    if (currentTab === totalQuestions - 1) {
      document.getElementById('nextBtn').style.display = 'none';
      document.getElementById('submitBtn').style.display = 'inline-block';
    } else {
      document.getElementById('nextBtn').style.display = 'inline-block';
      document.getElementById('submitBtn').style.display = 'none';
    }

    // 3. 更新进度条与文本
    const progressPercentage = ((currentTab + 1) / totalQuestions) * 100;
    document.getElementById('dynamicProgressBar').style.width = progressPercentage + '%';
    document.getElementById('dynamicProgressBar').innerText = '已完成 ' + Math.round(progressPercentage) + '%';
    document.getElementById('progressText').innerText = (currentTab + 1) + ' / ' + totalQuestions;
  }

  // 最终提交表单时的校验
  function submitForm() {
    if (!validateCurrentQuestion()) {
      alert("请完成最后一题的选择后再提交！");
      return;
    }

    // 变更按钮状态为防抖
    const sBtn = document.getElementById('submitBtn');
    sBtn.innerHTML = '正在分析您的性格... ⏳';
    sBtn.classList.add('disabled');

    document.getElementById('testForm').submit();
  }

  // 🌟 进阶体验优化：监听所有单选按钮，选中后自动跳转下一题
  document.querySelectorAll('.option-radio').forEach(radio => {
    radio.addEventListener('change', function() {
      // 延迟 0.35 秒跳转，让用户能看到按钮被按下的蓝色高亮反馈
      setTimeout(() => {
        // 如果不是最后一题，就自动进入下一题
        if (currentTab < totalQuestions - 1) {
          navigate(1);
        }
      }, 350);
    });
  });
</script>
</body>
</html>