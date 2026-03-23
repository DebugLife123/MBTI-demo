package com.mbti.training.model;

public class Question {
    private Integer id;
    private String questionText;
    private String optionA;
    private String optionAType; // 如: E
    private String optionB;
    private String optionBType; // 如: I
    private Integer status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getOptionA() {
        return optionA;
    }

    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }

    public String getOptionAType() {
        return optionAType;
    }

    public void setOptionAType(String optionAType) {
        this.optionAType = optionAType;
    }

    public String getOptionB() {
        return optionB;
    }

    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }

    public String getOptionBType() {
        return optionBType;
    }

    public void setOptionBType(String optionBType) {
        this.optionBType = optionBType;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
// 生成 Getter, Setter 和 构造方法...
}