package com.mbti.training.dao;

import com.mbti.training.model.Personality;
import com.mbti.training.utils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PersonalityDao {
    /**
     * 根据 4 位性格代码（如 INTJ）获取详细解析
     */
    public Personality getByTypeCode(String typeCode) {
        Personality p = null;
        String sql = "SELECT * FROM mbti_personality WHERE type_code = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, typeCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    p = new Personality();
                    p.setId(rs.getInt("id"));
                    p.setTypeCode(rs.getString("type_code"));
                    p.setTitle(rs.getString("title"));
                    p.setDescription(rs.getString("description"));
                    p.setCareerAdvice(rs.getString("career_advice"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
}