package com.mbti.training.dao;

import com.mbti.training.model.Dimension;
import com.mbti.training.utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DimensionDao {

    /**
     * 获取所有性格维度列表
     */
    public List<Dimension> getAllDimensions() {
        List<Dimension> list = new ArrayList<>();
        String sql = "SELECT * FROM mbti_dimension ORDER BY id ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Dimension d = new Dimension();
                d.setId(rs.getInt("id"));
                d.setDimName(rs.getString("dim_name"));
                d.setDescription(rs.getString("description"));
                d.setStatus(rs.getInt("status"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 添加新的性格维度
     */
    public void add(Dimension d) {
        String sql = "INSERT INTO mbti_dimension (dim_name, description, status) VALUES (?, ?, 1)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, d.getDimName());
            pstmt.setString(2, d.getDescription());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 更新现有的性格维度信息
     */
    public void update(Dimension d) {
        String sql = "UPDATE mbti_dimension SET dim_name = ?, description = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, d.getDimName());
            pstmt.setString(2, d.getDescription());
            pstmt.setInt(3, d.getId());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除指定的性格维度
     */
    public void delete(int id) {
        String sql = "DELETE FROM mbti_dimension WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}