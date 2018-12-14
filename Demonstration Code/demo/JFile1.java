import java.io.File;

public class JFile1 {
 
   public static int canRead (String fileName) {
      File myFile = new File (fileName);
      boolean retval = myFile.canRead();
      if (retval) return 1; else return 0;
      }

   public static int delete (String fileName) {
      File myFile = new File (fileName);
      boolean retval = myFile.delete();
      if (retval) return 1; else return 0;
      }
}