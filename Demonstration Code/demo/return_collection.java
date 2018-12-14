-- return_collection.java

CREATE TYPE employee_ot AS OBJECT (
   EMPLOYEE_ID NUMBER (4),
   SALARY NUMBER (7,2)
   )
/

CREATE TYPE employee_ntt
    AS TABLE OF employee_ot;
/

CREATE OR REPLACE FUNCTION allrows_by (
   append_to_from_in     IN   VARCHAR2 DEFAULT NULL
 , row_delimiter_in      IN   VARCHAR2 DEFAULT '|'
 , column_delimiter_in   IN   VARCHAR2 DEFAULT '^'
)
   RETURN employee_ntt
IS
   l_employees   employee_ntt;
BEGIN
   -- Retrieve all rows matching the possible where clause
   -- and deposit directly into the collection.
   EXECUTE IMMEDIATE    
     'SELECT
             EMPLOYEE_ID,
             SALARY
        FROM EMPLOYEE'
                     || ' '
                     || append_to_from_in
   BULK COLLECT INTO l_employees;

   RETURN l_employees;
END allrows_by;
/

CREATE or REPLACE JAVA SOURCE NAMED "EMPLOYEE_cl" AS

import java.io.*;
import java.sql.*;
import oracle.jdbc.driver.*;
import oracle.sql.*;

/*
 ** Delete files in specified directories that were last modified before
 ** a specified date
 */
public class EMPLOYEE_cl {

    public static int process_collection (oracle.sql.ARRAY tbl) throws SQLException {
        try {

            // Retrieve the contents of the table/varray as a result set
            ResultSet rs = tbl.getResultSet();

            // Iterate through the rows returned by the result set
            // NOTE: The JDBC 2.0 standard specifies that the ResultSet
            //       contains rows consisting of two columns.
            //
            //       Column 1 stores the element index for the row.
            //       Column 2 stores the actual element value.
            //
            for (int ndx = 0; ndx < tbl.length(); ndx++) \{
                rs.next();

                // Retrieve the array index
                int aryndx = (int)rs.getInt(1);

                // Retrieve the array element (an object returned as type STRUCT)
                STRUCT obj = (STRUCT)rs.getObject(2);

                // Retrieve the attributes for the object
                // as an array of Java Objects
                Object[] attrs = obj.getAttributes();

                // Retrieve the individual attributes, casting the object to the correct type
                java.lang.Float EMPLOYEE_ID = (java.lang.Float)attrs[1];
                java.lang.Float SALARY = (java.lang.Float)attrs[2];

            // Now do what you will with the data...

            }
            // Close the result set
            rs.close();
            return 0;

        } catch (Exception e) \{
            e.printStackTrace();
            return -1;
        }
  }
}
/
