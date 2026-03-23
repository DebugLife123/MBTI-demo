package com.mbti.training.dao;

import com.mbti.training.model.TestRecord;
import com.mbti.training.utils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class TestRecordDao {
    public void save(TestRecord record) {
        String sql = "INSERT INTO test_record (user_id, result_type, e_score, i_score, s_score, n_score, t_score, f_score, j_score, p_score) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, record.getUserId());
            pstmt.setString(2, record.getResultType());
            pstmt.setInt(3, record.geteScore());
            pstmt.setInt(4, record.getiScore());
            pstmt.setInt(5, record.getsScore());
            pstmt.setInt(6, record.getnScore());
            pstmt.setInt(7, record.gettScore());
            pstmt.setInt(8, record.getfScore());
            pstmt.setInt(9, record.getjScore());
            pstmt.setInt(10, record.getpScore());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}