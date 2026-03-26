package com.mbti.training.servlet;

import com.mbti.training.dao.UserDao;
import com.mbti.training.model.SysUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class ProfileServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        SysUser loginUser = (SysUser) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 1. 处理姓名修改
        String newRealName = request.getParameter("realName");
        if (newRealName != null && !newRealName.trim().isEmpty()) {
            if (userDao.updateRealName(loginUser.getId(), newRealName)) {
                loginUser.setRealName(newRealName);
            }
        }

        // (⚠️ 这里已经删除了 role 角色修改的逻辑，彻底堵死越权修改的漏洞)

        // 2. 处理头像上传
        try {
            Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = request.getServletContext().getRealPath("/static/uploads/avatars/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String submittedFileName = filePart.getSubmittedFileName();
                String ext = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                String newFileName = UUID.randomUUID().toString() + ext;

                filePart.write(uploadPath + File.separator + newFileName);
                String avatarUrl = "static/uploads/avatars/" + newFileName;

                if (userDao.updateAvatar(loginUser.getId(), avatarUrl)) {
                    loginUser.setAvatar(avatarUrl);
                }
            }
        } catch (Exception e) {
            System.out.println("头像处理跳过或异常：" + e.getMessage());
        }

        request.setAttribute("successMsg", "个人资料已同步更新！");
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}