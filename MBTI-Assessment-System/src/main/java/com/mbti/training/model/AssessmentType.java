package com.mbti.training.model;

public class AssessmentType {
    private Integer id;
    private String typeName;
    private Integer status; // 1:在用 0:作废
    private Double price;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
}