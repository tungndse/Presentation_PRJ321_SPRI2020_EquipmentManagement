package db;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnector implements Serializable {

    public static Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection
                ("jdbc:sqlserver://localhost;databaseName=EquipmentDB;user=sa;password=tung1101ttt@");
    }


}
