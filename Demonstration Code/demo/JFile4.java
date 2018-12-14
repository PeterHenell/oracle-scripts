CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "JFile4" AS
import java.io.File;
public class JFile4 {
   public static int tVal () { return 10009; };
   
   public static int fVal () { return -18703; };   
   
   public static int canRead (String fileName) {
      File myFile = new File (fileName);
      boolean retval = myFile.canRead();
      if (retval) return tVal(); else return fVal();
      }          
}
/
