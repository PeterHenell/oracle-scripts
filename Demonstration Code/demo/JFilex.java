import java.io.File;

public class JFile2 {
   public static long length (String fileName) {
      File myFile = new File (fileName);
      return myFile.length();
      }
}

public class JFile3 {
   public static int canRead (String fileName) {
      File myFile = new File (fileName);
      boolean retval = myFile.canRead();
      if (retval) return 1; else return 0; }
}
public class JFile4 {
   public static int tVal () { return 1; };
   public static int fVal () { return 0; };   
   public static int canRead (String fileName) {
      File myFile = new File (fileName);
      boolean retval = myFile.canRead();
      if (retval) return tVal(); else return fVal();
      }          
}