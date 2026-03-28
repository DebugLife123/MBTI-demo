package com.mbti.training.dao;

import com.mbti.training.model.Assessment;
import com.mbti.training.utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssessmentDao {

    // 创建测试安排
    public boolean create(Assessment a) {
        String sql = "INSERT INTO assessment_info (title, purpose, content, format, test_time, location, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, a.getTitle());
            pstmt.setString(2, a.getPurpose());
            pstmt.setString(3, a.getContent());
            pstmt.setString(4, a.getFormat());
            pstmt.setTimestamp(5, new Timestamp(a.getTestTime().getTime()));
            pstmt.setString(6, a.getLocation());
            pstmt.setString(7, a.getNotes());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 查询所有测试安排 (支持按形式 ONLINE/OFFLINE 筛选)
    public List<Assessment> getAll(String formatFilter) {
        List<Assessment> list = new ArrayList<>();
        String sql = "SELECT * FROM assessment_info";
        if (formatFilter != null && !formatFilter.isEmpty()) {
            sql += " WHERE format = ?";
        }
        sql += " ORDER BY create_time DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (formatFilter != null && !formatFilter.isEmpty()) {
                pstmt.setString(1, formatFilter);
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Assessment a = new Assessment();
                    a.setId(rs.getInt("id"));
                    a.setTitle(rs.getString("title"));
                    a.setPurpose(rs.getString("purpose"));
                    a.setContent(rs.getString("content"));
                    a.setFormat(rs.getString("format"));
                    a.setTestTime(rs.getTimestamp("test_time"));
                    a.setLocation(rs.getString("location"));
                    a.setNotes(rs.getString("notes"));
                    a.setCreateTime(rs.getTimestamp("create_time"));
                    list.add(a);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 根据ID获取详情
    public Assessment getById(int id) {
        String sql = "SELECT * FROM assessment_info WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Assessment a = new Assessment();
                    a.setId(rs.getInt("id"));
                    a.setTitle(rs.getString("title"));
                    a.setPurpose(rs.getString("purpose"));
                    a.setContent(rs.getString("content"));
                    a.setFormat(rs.getString("format"));
                    a.setTestTime(rs.getTimestamp("test_time"));
                    a.setLocation(rs.getString("location"));
                    a.setNotes(rs.getString("notes"));
                    a.setCreateTime(rs.getTimestamp("create_time"));
                    return a;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 修改与级联删除...
    public boolean delete(int id) {
        // 先删除报名表中的关联记录，防止外键报错
        String sql1 = "DELETE FROM assessment_registration WHERE assessment_id = ?";
        String sql2 = "DELETE FROM assessment_info WHERE id = ?";
        try (Connection conn = DBUtils.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement p1 = conn.prepareStatement(sql1);
                 PreparedStatement p2 = conn.prepareStatement(sql2)) {
                p1.setInt(1, id); p1.executeUpdate();
                p2.setInt(1, id); p2.executeUpdate();
                conn.commit();
                return true;
            } catch (Exception e) { conn.rollback(); e.printStackTrace(); }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}