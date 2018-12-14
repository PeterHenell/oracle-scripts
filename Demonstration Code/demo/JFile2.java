CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "JFile2" AS
import java.io.File;
public class JFile2 {
 
   public static long length (String fileName) {
      File myFile = new File (fileName);
      System.out.println (fileName);
      return myFile.length();
      }
      
   public static void main (String args[]) {
      System.out.println (length ("d:/demo/JFile2.java"));
   }
}
/

