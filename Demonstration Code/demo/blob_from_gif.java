import java.sql.*;
import java.io.*;
import java.util.*;
import oracle.jdbc.driver.*;

//needed for new CLOB and BLOB classes
import oracle.sql.*;

public class ImageManip {

public static void main (String args <>) throws Exception {

// Register the Oracle JDBC driver

try {
DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

// Connect to the database
Connection conn =
DriverManager.getConnection ("jdbc:oracle:thin:@HOSTNAME:PORT:SID",
"scott", "tiger");
System.out.println("Connected");

// This is absolutely necessary in this case and any case where you are doing
// a select for update. Not doing this will result in a ORA-1002

conn.setAutoCommit (false);

BLOB blob = null;

// Create a Statement
Statement stmt = conn.createStatement ();

// Drop the table if it exists
try {
stmt.execute ("drop table ImageTable");
System.out.println("Table droped ...");
}
catch (SQLException e) {
System.out.println("Table does not exist");
}

// Create the table
stmt.execute ("create table ImageTable (count varchar2(20), image BLOB)");
System.out.println("Table created ...");

// create a blob entry in the table
stmt.execute("insert into ImageTable values ('one', empty_blob())");
stmt.execute("commit");
String cmd = "select * from ImageTable for update";
ResultSet rset = stmt.executeQuery(cmd);
while (rset.next())
blob = ((OracleResultSet)rset).getBLOB(2);

readFromFile(blob);
writeToFile(blob);
}

catch (SQLException sqle) {
System.out.println("SQL Exception occured: " + sqle.getMessage());
sqle.printStackTrace();
}

catch(FileNotFoundException e) {
System.out.println("File Not Found");
}

catch (IOException ioe) {
System.out.println("IO Exception" + ioe.getMessage());
}

}

static void readFromFile (BLOB blob) throws Exception {
File binaryFile = new File("TEST.gif"); //insert your file name here.
FileInputStream in = new FileInputStream(binaryFile);
OutputStream out = blob.getBinaryOutputStream();
int chunk = blob.getChunkSize();
System.out.print("The chunk size is " + chunk);
byte<> buffer = new byte;
int length;

while ((length = in.read(buffer)) != -1)
out.write(buffer, 0, length);

in.close();
out.close();
}

static void writeToFile (BLOB blob) throws Exception {
int chunk = blob.getChunkSize();
byte<> buffer = new byte;
int length;

FileOutputStream outFile = null;
outFile = new FileOutputStream("out.gif");
InputStream instream = blob.getBinaryStream();

// Fetch data
while ((length = instream.read(buffer)) != -1) {
outFile.write(buffer, 0, length);
}

// Close input and output streams
instream.close();
outFile.close();
}

} 