import java.sql.*;
import java.io.*;
import oracle.jdbc.driver.*;
 
public class DropAny {
  public static void object (String object_type, String object_name)
  throws SQLException {
  
    // Connect to Oracle using JDBC driver
    Connection conn = new OracleDriver().defaultConnection();
    
    // Build SQL statement
    String sql = "DROP " + object_type + " " + object_name;
    
    //try {
    
      Statement stmt = conn.createStatement();
      stmt.executeUpdate(sql);
      stmt.close();
    
    //} catch (SQLException e) {System.err.println(e.getMessage());}
    
  }
}