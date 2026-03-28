package com.mbti.training.model;

import java.util.Date;

public class Assessment {
    private int id;
    private String title;
    private String purpose;
    private String content;
    private String format; // ONLINE 或 OFFLINE
    private Date testTime;
    private String location;
    private String notes;
    private Date createTime;

    // 辅助字段，用于在用户端展示是否已报名
    private boolean registered;

    // 生成 Getter 和 Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
    public Date getTestTime() { return testTime; }
    public void setTestTime(Date testTime) { this.testTime = testTime; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public boolean isRegistered() { return registered; }
    public void setRegistered(boolean registered) { this.registered = registered; }
}