import java.sql.*;
import java.io.*;
import oracle.sql.*;
import oracle.jdbc.driver.*;
import java.math.*;

public class UnionBuster {

  public static void wageStrategy (STRUCT e)
    throws java.sql.SQLException {
    // Get the attributes of the labor_source object.
    Object[] attribs = e.getAttributes();

    // Access individual attributes by array index, 
    // starting with 0
    String laborType = (String)(attribs[0]);  
    BigDecimal hourly_rate = (BigDecimal)(attribs[1]); 
    
    System.out.println (
       "Pay " + laborType + " $" + 
       hourly_rate + " per hour");
  }
}


