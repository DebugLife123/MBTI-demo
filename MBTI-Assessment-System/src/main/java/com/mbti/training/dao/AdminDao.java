package com.mbti.training.dao;

import com.mbti.training.utils.DBUtils;
import java.sql.*;
import java.util.*;

public class AdminDao {
    /**
     * 获取所有用户的测试统计记录 (多表关联)
     */
    public List<Map<String, Object>> getAllTestLogs() {
        List<Map<String, Object>> list = new ArrayList<>();
        // 关键 SQL：通过 user_id 关联查询真实姓名
        String sql = "SELECT r.id, u.username, u.real_name, r.result_type, r.test_time, r.e_score, r.i_score, r.s_score, r.n_score, r.t_score, r.f_score, r.j_score, r.p_score " +
                "FROM test_record r " +
                "JOIN sys_user u ON r.user_id = u.id " +
                "ORDER BY r.test_time DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("recordId", rs.getInt("id")); // 🌟 核心修改：存入记录 ID
                map.put("username", rs.getString("username")); // 🌟 新增：存入用户名
                map.put("realName", rs.getString("real_name"));
                map.put("resultType", rs.getString("result_type"));
                map.put("testTime", rs.getTimestamp("test_time"));
                map.put("scores", String.format("E:%d I:%d S:%d N:%d T:%d F:%d J:%d P:%d",
                        rs.getInt("e_score"), rs.getInt("i_score"), rs.getInt("s_score"),
                        rs.getInt("n_score"), rs.getInt("t_score"), rs.getInt("f_score"),
                        rs.getInt("j_score"), rs.getInt("p_score")));
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    /**
     * 获取全网 MBTI 人格类型分布情况 (用于生成分布图)
     */
    public List<Map<String, Object>> getPersonalityTypeDistribution() {
        List<Map<String, Object>> list = new ArrayList<>();
        // 核心 SQL: 分组统计每种性格的人数，并按人数降序排列
        String sql = "SELECT result_type, COUNT(*) as count FROM test_record GROUP BY result_type ORDER BY count DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", rs.getString("result_type"));
                map.put("value", rs.getInt("count"));
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * 🌟 1. 获取测试记录总数 (支持按用户名或真实姓名模糊查询)
     */
    public int getTestLogCount(String keyword) {
        int count = 0;
        // 联表查询，方便用 u.username 或 u.real_name 搜索
        String sql = "SELECT COUNT(*) FROM test_record r JOIN sys_user u ON r.user_id = u.id";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE u.username LIKE ? OR u.real_name LIKE ?";
        }

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (keyword != null && !keyword.trim().isEmpty()) {
                String likeKw = "%" + keyword.trim() + "%";
                pstmt.setString(1, likeKw);
                pstmt.setString(2, likeKw);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    /**
     * 🌟 2. 分页查询测试记录列表 (支持模糊查询)
     */
    public List<Map<String, Object>> getTestLogsByPage(String keyword, int offset, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        // 包含查出 r.id，方便查看详情和删除
        String sql = "SELECT r.id, u.username, u.real_name, r.result_type, r.test_time, " +
                "r.e_score, r.i_score, r.s_score, r.n_score, r.t_score, r.f_score, r.j_score, r.p_score " +
                "FROM test_record r JOIN sys_user u ON r.user_id = u.id";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE u.username LIKE ? OR u.real_name LIKE ?";
        }
        // 按时间倒序，并追加 LIMIT 截断
        sql += " ORDER BY r.test_time DESC LIMIT ?, ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String likeKw = "%" + keyword.trim() + "%";
                pstmt.setString(paramIndex++, likeKw);
                pstmt.setString(paramIndex++, likeKw);
            }
            pstmt.setInt(paramIndex++, offset); // 跳过多少条
            pstmt.setInt(paramIndex, limit);    // 取多少条

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("recordId", rs.getInt("id")); // 必须有 ID，前端才能跳转详情和删除
                    map.put("username", rs.getString("username"));
                    map.put("realName", rs.getString("real_name"));
                    map.put("resultType", rs.getString("result_type"));
                    map.put("testTime", rs.getTimestamp("test_time"));
                    map.put("scores", String.format("E:%d I:%d S:%d N:%d T:%d F:%d J:%d P:%d",
                            rs.getInt("e_score"), rs.getInt("i_score"), rs.getInt("s_score"),
                            rs.getInt("n_score"), rs.getInt("t_score"), rs.getInt("f_score"),
                            rs.getInt("j_score"), rs.getInt("p_score")));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}