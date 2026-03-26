package com.mbti.training.dao;

import com.mbti.training.model.SysUser;
import com.mbti.training.utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

public class UserDao {

    /**
     * 用户登录验证方法
     * @param username 账号
     * @param password 密码
     * @return 如果账号密码正确，返回包含用户所有信息的 SysUser 对象；如果错误，返回 null。
     */
    public SysUser login(String username, String password) {
        SysUser user = null;
        String sql = "SELECT * FROM sys_user WHERE username = ? AND password = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // 如果查到了数据，就把数据库里的数据“组装”成 Java 对象
                    user = new SysUser();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRealName(rs.getString("real_name"));
                    user.setRole(rs.getString("role"));
                    user.setCreateTime(rs.getTimestamp("create_time"));
                    user.setAvatar(rs.getString("avatar"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
    /**
     * 检查用户名是否已存在
     */
    public boolean checkUserExists(String username) {
        String sql = "SELECT count(*) FROM sys_user WHERE username = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return true;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * 注册新学生账号 (默认角色为 STUDENT)
     */
    public boolean register(String username, String password, String realName, String role) {
        String sql = "INSERT INTO sys_user (username, password, real_name, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, realName);
            pstmt.setString(4, role); // 🌟 使用传入的角色
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    /**
     * 🌟 新增：更新用户角色
     */
    public boolean updateRole(int userId, String newRole) {
        String sql = "UPDATE sys_user SET role = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newRole);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateAvatar(int userId, String avatarPath) {
        String sql = "UPDATE sys_user SET avatar = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, avatarPath);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    /**
     * 修改用户密码
     * @param userId 用户ID
     * @param oldPwd 旧密码（用于安全验证）
     * @param newPwd 新密码
     * @return 是否修改成功
     */
    public boolean updatePassword(int userId, String oldPwd, String newPwd) {
        // 首先验证旧密码是否正确
        String checkSql = "SELECT count(*) FROM sys_user WHERE id = ? AND password = ?";
        String updateSql = "UPDATE sys_user SET password = ? WHERE id = ?";

        try (Connection conn = DBUtils.getConnection()) {
            // 1. 验证旧密码
            try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                pstmt.setInt(1, userId);
                pstmt.setString(2, oldPwd);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (!(rs.next() && rs.getInt(1) > 0)) {
                        return false; // 旧密码不匹配
                    }
                }
            }
            // 2. 执行更新
            try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                pstmt.setString(1, newPwd);
                pstmt.setInt(2, userId);
                return pstmt.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    /**
     * 仅更新用户的真实姓名
     */
    public boolean updateRealName(int userId, String newRealName) {
        String sql = "UPDATE sys_user SET real_name = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newRealName);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 获取所有用户列表 (管理员专用)
     */
    public List<SysUser> getAllUsers() {
        List<SysUser> list = new ArrayList<>();
        String sql = "SELECT * FROM sys_user ORDER BY create_time DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                SysUser user = new SysUser();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRealName(rs.getString("real_name"));
                user.setRole(rs.getString("role"));
                user.setCreateTime(rs.getTimestamp("create_time"));
                list.add(user);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * 安全物理删除用户：为防止外键约束报错，先删除该用户的测试记录，再删除账号
     */
    public boolean deleteUser(int id) {
        String delRecordSql = "DELETE FROM test_record WHERE user_id = ?";
        String delUserSql = "DELETE FROM sys_user WHERE id = ?";
        try (Connection conn = DBUtils.getConnection()) {
            conn.setAutoCommit(false); // 开启事务
            try (PreparedStatement pstmt1 = conn.prepareStatement(delRecordSql);
                 PreparedStatement pstmt2 = conn.prepareStatement(delUserSql)) {

                pstmt1.setInt(1, id);
                pstmt1.executeUpdate(); // 先删关联的测试记录

                pstmt2.setInt(1, id);
                int rows = pstmt2.executeUpdate(); // 再删用户本体

                conn.commit(); // 提交事务
                return rows > 0;
            } catch (Exception e) {
                conn.rollback(); // 发生异常则回滚
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * 一键重置密码为 123456
     */
    public boolean resetPassword(int id) {
        String sql = "UPDATE sys_user SET password = '123456' WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * 修改用户核心信息
     */
    public boolean updateUser(SysUser user) {
        String sql = "UPDATE sys_user SET username = ?, password = ?, real_name = ?, role = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRealName());
            pstmt.setString(4, user.getRole());
            pstmt.setInt(5, user.getId());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}