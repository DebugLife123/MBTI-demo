package com.mbti.training.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {
    // 数据库连接配置
    private static final String URL = "jdbc:mysql://localhost:3306/mbti_db?useSSL=false&serverTimezone=Asia/Shanghai";
    private static final String USER = "root"; // 你的数据库用户名
    private static final String PASSWORD = "230011"; // 你的数据库密码

    static {
        try {
            // 加载驱动（这行代码在 8.0 驱动里可以省略，但写上更稳妥）
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}