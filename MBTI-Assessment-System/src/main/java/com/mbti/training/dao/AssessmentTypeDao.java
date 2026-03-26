package com.mbti.training.dao;

import com.mbti.training.model.AssessmentType;
import com.mbti.training.utils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AssessmentTypeDao {
    // 获取所有考核类型 (管理端用)
    public List<AssessmentType> getAll() {
        List<AssessmentType> list = new ArrayList<>();
        String sql = "SELECT * FROM mbti_assessment_type ORDER BY id ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                AssessmentType type = new AssessmentType();
                type.setId(rs.getInt("id"));
                type.setTypeName(rs.getString("type_name"));
                type.setStatus(rs.getInt("status"));
                type.setPrice(rs.getDouble("price"));
                list.add(type);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 获取所有在用的考核类型 (用户端用)
    public List<AssessmentType> getActive() {
        List<AssessmentType> list = new ArrayList<>();
        String sql = "SELECT * FROM mbti_assessment_type WHERE status = 1 ORDER BY id ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                AssessmentType type = new AssessmentType();
                type.setId(rs.getInt("id"));
                type.setTypeName(rs.getString("type_name"));
                type.setStatus(rs.getInt("status"));
                type.setPrice(rs.getDouble("price"));
                list.add(type);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ========== 新增：添加、修改、删除功能 ==========

    // 添加新的考核类型
    public void add(AssessmentType type) {
        String sql = "INSERT INTO mbti_assessment_type (type_name, status, price) VALUES (?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, type.getTypeName());
            pstmt.setInt(2, type.getStatus());
            pstmt.setDouble(3, type.getPrice());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 修改考核类型
    public void update(AssessmentType type) {
        String sql = "UPDATE mbti_assessment_type SET type_name = ?, status = ?, price = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, type.getTypeName());
            pstmt.setInt(2, type.getStatus());
            pstmt.setDouble(3, type.getPrice());
            pstmt.setInt(4, type.getId());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 删除指定的考核类型
    public void delete(int id) {
        String sql = "DELETE FROM mbti_assessment_type WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
