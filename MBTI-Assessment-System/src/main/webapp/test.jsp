<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>MBTI 在线测评</title>
  <link href="https://lf3-cdn-tos.bytecdntp.com/cdn/expire-1-M/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://gs.jurieo.com/gemini/fonts-googleapis/css2?family=Noto+Sans+SC:wght@300;400;700&display=swap" rel="stylesheet">

  <style>
    body { font-family: 'Noto Sans SC', sans-serif; background-color: #f4f7f6; }
    .card { border: none; border-radius: 15px; transition: 0.3s; }
    .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
    .btn-primary { border-radius: 10px; padding: 10px 25px; }
  </style>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>
<div class="container">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="progress mb-4" style="height: 10px;">
        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 25%;"></div>
      </div>

      <div class="card shadow-sm p-4">
        <div class="d-flex align-items-center mb-4">
          <span class="badge bg-primary me-2">Q1</span>
          <h4 class="mb-0">在社交聚会上，你通常是：</h4>
        </div>

        <form action="submitAnswer" method="post">
          <div class="list-group">
            <label class="list-group-item list-group-item-action d-flex align-items-center py-3">
              <input class="form-check-input me-3" type="radio" name="q1" value="E" required>
              <span>A. 与许多人交流，包括陌生人</span>
            </label>
            <label class="list-group-item list-group-item-action d-flex align-items-center py-3 mt-2">
              <input class="form-check-input me-3" type="radio" name="q1" value="I">
              <span>B. 只与少数熟人交流</span>
            </label>
          </div>
          <div class="text-end mt-4">
            <button type="submit" class="btn btn-primary px-5 shadow">提交答案，查看结果 →</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
</body>
</html>