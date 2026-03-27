package com.mbti.training.servlet;

import com.mbti.training.dao.UserDao;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/userManage")
public class UserManageServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 安全校验：只允许管理员访问
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String method = request.getParameter("method");

        // 2. 根据 method 路由不同功能
        if ("delete".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDao.deleteUser(id); // 删除数据库中的账号，被删除的用户将彻底无法登录
            response.sendRedirect("userManage");
        } else if ("resetPwd".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDao.resetPassword(id); // 重置后，旧密码失效，必须输入 123456 才能进
            response.sendRedirect("userManage");
        } else {
            // --- 🌟 分页与搜索核心逻辑 ---
            String keyword = request.getParameter("keyword");
            String pageStr = request.getParameter("page");

            int page = 1;
            int pageSize = 10; // 规定每页显示 10 条数据

            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }

            // 计算 SQL 查询的起始位置 (offset)
            int offset = (page - 1) * pageSize;

            // 查询总人数，计算总页数
            int totalCount = userDao.getUserCount(keyword);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            // 获取当前页的数据集合
            List<SysUser> users = userDao.getUsersByPage(keyword, offset, pageSize);

            // 将所有变量打包塞进 request，准备发给 JSP 渲染
            request.setAttribute("userList", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword == null ? "" : keyword); // 回显搜索词
            request.setAttribute("totalCount", totalCount);

            request.getRequestDispatcher("user_list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String method = request.getParameter("method");

        if ("update".equals(method)) {
            // 封装表单提交的修改数据
            SysUser u = new SysUser();
            u.setId(Integer.parseInt(request.getParameter("id")));
            u.setUsername(request.getParameter("username"));
            u.setPassword(request.getParameter("password"));
            u.setRealName(request.getParameter("realName"));
            u.setRole(request.getParameter("role"));

            userDao.updateUser(u);
            response.sendRedirect("userManage");
        }
    }
}