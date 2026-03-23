package com.mbti.training.dao;

import com.mbti.training.model.TestRecord;
import com.mbti.training.utils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

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
    /**
     * 根据用户 ID 获取其所有的测试记录，按时间倒序排列
     */
    public List<TestRecord> getRecordsByUserId(int userId) {
        List<TestRecord> list = new ArrayList<>();
        // 按照测试时间倒序排列，最新的在最上面
        String sql = "SELECT * FROM test_record WHERE user_id = ? ORDER BY test_time DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    TestRecord tr = new TestRecord();
                    tr.setId(rs.getInt("id"));
                    tr.setUserId(rs.getInt("user_id"));
                    tr.setResultType(rs.getString("result_type"));
                    tr.seteScore(rs.getInt("e_score"));
                    tr.setiScore(rs.getInt("i_score"));
                    tr.setsScore(rs.getInt("s_score"));
                    tr.setnScore(rs.getInt("n_score"));
                    tr.settScore(rs.getInt("t_score"));
                    tr.setfScore(rs.getInt("f_score"));
                    tr.setjScore(rs.getInt("j_score"));
                    tr.setpScore(rs.getInt("p_score"));
                    tr.setTestTime(rs.getTimestamp("test_time"));
                    list.add(tr);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 安全删除记录：必须同时匹配 记录ID 和 用户ID
     */
    public boolean deleteUserRecord(int recordId, int userId) {
        String sql = "DELETE FROM test_record WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, recordId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    /**
     * 安全查询单条记录：根据 记录ID 和 用户ID 获取具体的测试结果
     */
    public TestRecord getRecordById(int recordId, int userId) {
        TestRecord tr = null;
        String sql = "SELECT * FROM test_record WHERE id = ? AND user_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, recordId);
            pstmt.setInt(2, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    tr = new TestRecord();
                    tr.setId(rs.getInt("id"));
                    tr.setUserId(rs.getInt("user_id"));
                    tr.setResultType(rs.getString("result_type"));
                    tr.seteScore(rs.getInt("e_score"));
                    tr.setiScore(rs.getInt("i_score"));
                    tr.setsScore(rs.getInt("s_score"));
                    tr.setnScore(rs.getInt("n_score"));
                    tr.settScore(rs.getInt("t_score"));
                    tr.setfScore(rs.getInt("f_score"));
                    tr.setjScore(rs.getInt("j_score"));
                    tr.setpScore(rs.getInt("p_score"));
                    tr.setTestTime(rs.getTimestamp("test_time"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tr;
    }
}