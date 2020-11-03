package com.azuresqlsamples;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.DriverManager;

public class App {
    public static void main(String[] args) {
        //Update connection string information
        String connectionUrl = 
        "jdbc:sqlserver://<servername>.database.windows.net:1433;"
        + "database=WideWorldImporters-Full;user=<username>@<servername>;"
        + "password=<password>;loginTimeout=30;";

        try {
            try (Connection connection = 
                DriverManager.getConnection(connectionUrl)) {

                String sql = "SELECT @@VERSION;";
                try (Statement statement = 
                    connection.createStatement();
                        ResultSet resultSet = 
                            statement.executeQuery(sql)) {
                    while (resultSet.next()) {
                        System.out.println(
                                resultSet.getString(1));
                    }
                }
                connection.close();
            }
        } catch (Exception e) {
            System.out.println();
            e.printStackTrace();
        }
    }
}