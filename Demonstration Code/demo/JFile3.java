CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "JFile3" AS
import java.io.File;
public class JFile3 {
   public static int canRead (String fileName) {
      File myFile = new File (fileName);
      boolean retval = myFile.canRead();
      if (retval) return 1; else return 0; }
}
/

