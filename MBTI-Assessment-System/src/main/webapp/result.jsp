<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>测评结果</title>
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
<div class="container text-center">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-top border-5 border-success p-5 shadow">
                <div class="mb-4">
                    <div class="display-1 text-success">🎯</div>
                </div>
                <h2 class="fw-bold mb-3">测评报告</h2>
                <p class="text-muted">亲爱的 <strong>${sessionScope.currUser}</strong>，您的核心性格倾向为：</p>

                <div class="py-4 bg-light rounded-3 my-4">
                    <h1 class="display-4 fw-bold text-primary">${requestScope.myResult}</h1>
                </div>

                <div class="text-start mb-4">
                    <h6>💡 性格简述：</h6>
                    <p class="small text-secondary">
                        ${requestScope.myResult.contains('E') ?
                                '你是一个充满活力的人，喜欢在人群中汲取能量。' :
                                '你是一个内省且深刻的人，更喜欢在安静中思考。'}
                    </p>
                </div>

                <a href="index.jsp" class="btn btn-outline-secondary">返回首页</a>
                <button onclick="window.print()" class="btn btn-primary ms-2">下载报告 (PDF)</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>