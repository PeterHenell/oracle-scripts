/*
 * It demonstrates how to use OracleRef 
 *
 * This class is used in RefClient.java
 * Please use jdk1.2 or later version and classes12.zip
 */

import oracle.sql.REF;
import oracle.sql.StructDescriptor;
import java.sql.Connection;
import java.sql.SQLException;
import oracle.jdbc.OracleRef;
import java.sql.*;
public class GenREF 
{
  String typeName;
  byte[] bytes;
  //Object attributes[];

  public GenREF (oracle.jdbc.OracleRef ref) throws SQLException {
    this.typeName = ref.getBaseTypeName ();
    this.bytes = ((REF)ref).getBytes ();
  }

  public OracleRef getREF (Connection conn) throws SQLException {
    // Struct s = conn.createStruct( typeName, attributes );
    // return (OracleRef)s;
     return new  REF (new StructDescriptor (typeName, conn),
                    conn,
                    bytes);
  }
}
