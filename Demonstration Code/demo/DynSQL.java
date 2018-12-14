import java.sql.*;

class DynSQL
{
   private static String musr = "scott";
   private static String mpwd = "tiger";
   
   public static void setConnectInfo (String usr, String pwd) {
      musr = usr;
      mpwd = pwd;
   }
   
   public static int upd (String tab, String col, String val, String whr) 
   {
      String updStatement = 
         "UPDATE " + tab + " SET " + col + " = " + "'" + val + "' WHERE ";
      if (whr.equals (null))
         updStatement = updStatement + "1=1";
      else
         updStatement = updStatement + whr;
      
      try 
      {
          DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
          Connection conn =
            DriverManager.getConnection ("jdbc:oracle:oci8:@beq-local", musr, mpwd);

          Statement stmt = conn.createStatement ();

          int updCount = stmt.executeUpdate (updStatement);
          
          return updCount;
      }
      catch (SQLException e) 
      {
         return -1;
      }
   }
}
