package com.mbti.training.dao;

import com.mbti.training.utils.DBUtils;
import java.sql.*;
import java.util.*;

public class AssessmentRegistrationDao {

    // 报名测试
    public boolean register(int assessmentId, int userId) {
        String sql = "INSERT INTO assessment_registration (assessment_id, user_id) VALUES (?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, assessmentId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            // 捕获唯一索引冲突（重复报名），静默返回 false
            return false;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 取消报名 (用户自己取消，或管理员踢人)
    public boolean cancelRegistration(int assessmentId, int userId) {
        String sql = "DELETE FROM assessment_registration WHERE assessment_id = ? AND user_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, assessmentId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 检查用户是否已报名某场测试
    public boolean isRegistered(int assessmentId, int userId) {
        String sql = "SELECT 1 FROM assessment_registration WHERE assessment_id = ? AND user_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, assessmentId);
            pstmt.setInt(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 获取某场测试的所有参测人员 (管理员端用)
    public List<Map<String, Object>> getParticipants(int assessmentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.real_name, u.role, r.register_time " +
                "FROM assessment_registration r " +
                "JOIN sys_user u ON r.user_id = u.id " +
                "WHERE r.assessment_id = ? ORDER BY r.register_time DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, assessmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("userId", rs.getInt("id"));
                    map.put("username", rs.getString("username"));
                    map.put("realName", rs.getString("real_name"));
                    map.put("role", rs.getString("role"));
                    map.put("registerTime", rs.getTimestamp("register_time"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}