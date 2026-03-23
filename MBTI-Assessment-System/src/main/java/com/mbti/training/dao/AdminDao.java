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
        String sql = "SELECT u.real_name, r.result_type, r.test_time, r.e_score, r.i_score, r.s_score, r.n_score, r.t_score, r.f_score, r.j_score, r.p_score " +
                "FROM test_record r " +
                "JOIN sys_user u ON r.user_id = u.id " +
                "ORDER BY r.test_time DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
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
}