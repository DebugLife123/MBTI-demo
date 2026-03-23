package com.mbti.training.filter;

import com.mbti.training.model.SysUser;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// /* 表示拦截项目下的所有请求
@WebFilter("/*")
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String uri = req.getRequestURI();

        // 1. 放行名单：登录页面、登录接口、以及所有的 CSS/JS/图片资源
        if (uri.contains("index.jsp") || uri.contains("login") || uri.contains("register") || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. 检查登录状态
        HttpSession session = req.getSession();
        SysUser loginUser = (SysUser) session.getAttribute("loginUser");

        if (loginUser == null) {
            // 没登录，直接踢回登录页
            resp.sendRedirect("index.jsp");
        } else {
            // 3. 进阶权限检查：如果访问地址包含 admin，必须是管理员角色
            if (uri.contains("admin") && !"ADMIN".equals(loginUser.getRole())) {
                // 如果是学生想偷看管理员页面，给个提示或者跳转
                resp.setContentType("text/html;charset=UTF-8");
                resp.getWriter().write("<script>alert('权限不足，请勿越权操作！');window.location.href='startTest';</script>");
            } else {
                // 检查通过，放行去往目的地
                chain.doFilter(request, response);
            }
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}