package com.mbti.training.model;

public class Question {
    private String content; // 题目内容
    private String optionA; // 选项A
    private String optionB; // 选项B

    public Question(String content, String optionA, String optionB) {
        this.content = content;
        this.optionA = optionA;
        this.optionB = optionB;
    }
    // 同样生成 Getter 方法...
    public String getContent() { return content; }
    public String getOptionA() { return optionA; }
    public String getOptionB() { return optionB; }
}