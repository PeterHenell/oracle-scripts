/*
 * This sample shows how to list all the names from the EMP table
 *
 * It uses the JDBC OCI8 driver.  See the same program in the
 * thin or oci7 samples directories to see how to use the other drivers.
 */

// You need to import the java.sql package to use JDBC
import java.sql.*;

class Employee
{
  public static void main (String args [])
       throws SQLException, ClassNotFoundException
  {
    // Load the Oracle JDBC driver
    //Class.forName ("oracle.jdbc.driver.OracleDriver");
	 DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
    
    // Connect to the database
    // You can put a database name after the @ sign in the connection URL.
    Connection conn =
      DriverManager.getConnection ("jdbc:oracle:oci8:@beq-local", "scott", "tiger");

    // Create a Statement
    Statement stmt = conn.createStatement ();

    // Select the ENAME column from the EMP table
    ResultSet rset = stmt.executeQuery ("select ENAME from EMP");

    // Iterate through the result and print the employee names
    while (rset.next ())
      System.out.println (rset.getString (1));
  }
}
