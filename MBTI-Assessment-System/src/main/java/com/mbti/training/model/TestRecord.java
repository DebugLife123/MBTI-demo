package com.mbti.training.model;
import java.util.Date;

public class TestRecord {
    private Integer id;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getResultType() {
        return resultType;
    }

    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    public Integer geteScore() {
        return eScore;
    }

    public void seteScore(Integer eScore) {
        this.eScore = eScore;
    }

    public Integer getiScore() {
        return iScore;
    }

    public void setiScore(Integer iScore) {
        this.iScore = iScore;
    }

    public Integer getsScore() {
        return sScore;
    }

    public void setsScore(Integer sScore) {
        this.sScore = sScore;
    }

    public Integer getnScore() {
        return nScore;
    }

    public void setnScore(Integer nScore) {
        this.nScore = nScore;
    }

    public Integer gettScore() {
        return tScore;
    }

    public void settScore(Integer tScore) {
        this.tScore = tScore;
    }

    public Integer getfScore() {
        return fScore;
    }

    public void setfScore(Integer fScore) {
        this.fScore = fScore;
    }

    public Integer getjScore() {
        return jScore;
    }

    public void setjScore(Integer jScore) {
        this.jScore = jScore;
    }

    public Integer getpScore() {
        return pScore;
    }

    public void setpScore(Integer pScore) {
        this.pScore = pScore;
    }

    public Date getTestTime() {
        return testTime;
    }

    public void setTestTime(Date testTime) {
        this.testTime = testTime;
    }

    private Integer userId;
    private String resultType;
    private Integer eScore, iScore, sScore, nScore, tScore, fScore, jScore, pScore;
    private Date testTime;

    // 生成 Getter, Setter 和 构造方法...
}