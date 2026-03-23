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
// 🌟 必须加这个注解才能处理文件上传！
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 限制最大 5MB
public class ProfileServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // GET 请求：直接跳转到个人资料页面
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        SysUser loginUser = (SysUser) request.getSession().getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("index.jsp"); return; }

        // 1. 处理姓名修改
        String newRealName = request.getParameter("realName");
        if (newRealName != null && !newRealName.trim().isEmpty()) {
            if (userDao.updateRealName(loginUser.getId(), newRealName)) {
                loginUser.setRealName(newRealName); // 更新 Session
            }
        }

        // 2. 处理头像上传 (只有当选择了文件时才处理)
        try {
            Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = request.getServletContext().getRealPath("/static/uploads/avatars/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String submittedFileName = filePart.getSubmittedFileName();
                String ext = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                String newFileName = java.util.UUID.randomUUID().toString() + ext;

                filePart.write(uploadPath + File.separator + newFileName);
                String avatarUrl = "static/uploads/avatars/" + newFileName;

                if (userDao.updateAvatar(loginUser.getId(), avatarUrl)) {
                    loginUser.setAvatar(avatarUrl); // 更新 Session
                }
            }
        } catch (Exception e) {
            System.out.println("头像处理跳过或异常：" + e.getMessage());
        }

        request.setAttribute("successMsg", "个人资料已同步更新！");
        request.getRequestDispatcher("profile.jsp").forward(request, response);


        // 1. 获取上传的文件 Part
        Part filePart = request.getPart("avatarFile");
        if (filePart != null && filePart.getSize() > 0) {
            // 2. 获取项目运行时的绝对路径，存放在 static/uploads/avatars 目录下
            String uploadPath = request.getServletContext().getRealPath("/static/uploads/avatars/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs(); // 目录不存在则创建

            // 3. 生成唯一文件名防止覆盖 (UUID + 原文件后缀)
            String submittedFileName = filePart.getSubmittedFileName();
            String ext = submittedFileName.substring(submittedFileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + ext;

            // 4. 将文件写入服务器磁盘
            filePart.write(uploadPath + File.separator + newFileName);

            // 5. 更新数据库和当前 Session
            String avatarUrl = "static/uploads/avatars/" + newFileName;
            if (userDao.updateAvatar(loginUser.getId(), avatarUrl)) {
                loginUser.setAvatar(avatarUrl); // 同步更新 Session，这样页面才会立刻刷新出新头像
                request.setAttribute("successMsg", "头像上传成功！");
            } else {
                request.setAttribute("errorMsg", "头像保存失败数据库异常！");
            }
        }
        // 回到资料页
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}