import java.sql.*;
import oracle.jdbc.driver.*;

public class ForPLSQL {
  public static String Emp (int empNo) 
    throws SQLException, ClassNotFoundException {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = new OracleDriver().defaultConnection();

    PreparedStatement ps = 
       con.prepareStatement("SELECT ename FROM emp "
                            + "WHERE empno=?");
     ps.setInt(1, empNo);
     ResultSet rs = ps.executeQuery();

     String jename = "";
     while (rs.next()) {
       jename = rs.getString("ENAME");
     }

     ps.close();
     return jename;
  }
}
