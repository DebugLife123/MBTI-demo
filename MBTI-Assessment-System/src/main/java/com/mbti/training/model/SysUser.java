package com.mbti.training.model;
import java.util.Date;

public class SysUser {
    private Integer id;
    private String username;
    private String password;
    private String realName;
    private String role;
    private Date createTime;

    private String avatar;

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
// 💡 导师提示：请在 IDEA 里右键 -> Generate -> Getter and Setter，把所有属性的 get/set 方法生成出来，下同！
    // 也可以顺手 Generate 一个无参构造和一个全参构造。
}