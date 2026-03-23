package com.mbti.training.dao;

import com.mbti.training.model.Question;
import com.mbti.training.utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class QuestionDao {

    /**
     * 获取所有启用的题目列表
     * @return 包含所有题目的 List 集合
     */
    public List<Question> getAllQuestions() {
        // 创建一个空盒子，用来装马上要从数据库取出的题目
        List<Question> questionList = new ArrayList<>();

        // 只查询 status = 1 (启用状态) 的题目
        String sql = "SELECT * FROM mbti_question WHERE status = 1";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            // rs.next() 就像游标，一行一行往下读
            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionAType(rs.getString("option_a_type"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionBType(rs.getString("option_b_type"));
                q.setStatus(rs.getInt("status"));

                // 把组装好的这道题，扔进盒子里
                questionList.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 把装满题目的盒子交出去
        return questionList;
    }
    // 在 QuestionDao 类中添加以下方法
    public void delete(int id) {
        String sql = "DELETE FROM mbti_question WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void add(Question q) {
        String sql = "INSERT INTO mbti_question (question_text, option_a, option_a_type, option_b, option_b_type) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, q.getQuestionText());
            pstmt.setString(2, q.getOptionA());
            pstmt.setString(3, q.getOptionAType());
            pstmt.setString(4, q.getOptionB());
            pstmt.setString(5, q.getOptionBType());
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}