package com.afra.bloom;

import java.io.*;
import java.sql.*;
import java.util.Properties;

public class DatabaseConnection {
    public static Connection getConnection() throws IOException, SQLException {
        // The local setup script writes these settings. No password is kept in source code.
        Properties settings = new Properties();
        String file = System.getProperty("app.config",
                System.getProperty("user.home") + "/.ead/bloomdesk/database.properties");
        try (FileInputStream input = new FileInputStream(file)) {
            settings.load(input);
        }
        String url = "jdbc:mysql://" + settings.getProperty("host", "127.0.0.1")
                + ":" + settings.getProperty("port", "3306")
                + "/" + settings.getProperty("database", "afra_bloom")
                + "?allowPublicKeyRetrieval=true&connectTimeout=5000&socketTimeout=15000";
        return DriverManager.getConnection(url, settings.getProperty("user"), settings.getProperty("password"));
    }
}
