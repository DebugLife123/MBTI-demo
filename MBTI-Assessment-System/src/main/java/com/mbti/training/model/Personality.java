package com.mbti.training.model;

public class Personality {
    private Integer id;
    private String typeCode; // 如: INTJ
    private String title;    // 如: 建筑师
    private String description;
    private String careerAdvice;

    // 生成 Getter, Setter 和 构造方法...

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCareerAdvice() {
        return careerAdvice;
    }

    public void setCareerAdvice(String careerAdvice) {
        this.careerAdvice = careerAdvice;
    }
}