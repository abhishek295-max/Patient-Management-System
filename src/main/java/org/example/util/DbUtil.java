package org.example.util;

import java.sql.Connection;
import java.sql.DriverManager;

public final class DbUtil {
    private DbUtil() {
    }

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = "jdbc:mysql://kodama.proxy.rlwy.net:44328/railway?useSSL=false&allowPublicKeyRetrieval=true";
        }

        String user = System.getenv("DB_USER");
        if (user == null || user.trim().isEmpty()) {
            user = "root";
        }

        String password = System.getenv("DB_PASSWORD");
        if (password == null) {
            password = "zwuCzqUaKLOPdTrDoPWBIUjvHyiJHgja";
        }

        return DriverManager.getConnection(url, user, password);
    }
}
