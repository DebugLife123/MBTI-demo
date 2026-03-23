package com.mbti.training.dao;

import com.mbti.training.model.SysUser;
import com.mbti.training.utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
    public boolean register(String username, String password, String realName) {
        String sql = "INSERT INTO sys_user (username, password, real_name, role) VALUES (?, ?, ?, 'STUDENT')";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, realName);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}