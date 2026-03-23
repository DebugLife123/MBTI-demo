package com.mbti.training.model;

/**
 * 性格维度实体类
 */
public class Dimension {
    private Integer id;
    private String dimName;      // 维度名称，如：外倾 (E) - 内倾 (I)
    private String description;  // 维度详细说明
    private Integer status;      // 状态：1-启用，0-禁用

    // 无参构造方法
    public Dimension() {
    }

    // 全参构造方法
    public Dimension(Integer id, String dimName, String description, Integer status) {
        this.id = id;
        this.dimName = dimName;
        this.description = description;
        this.status = status;
    }

    // Getter 和 Setter 方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDimName() {
        return dimName;
    }

    public void setDimName(String dimName) {
        this.dimName = dimName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}