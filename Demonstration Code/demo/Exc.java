import java.io.File;

class Exc {
    public static void main (String args[]) {
       try {
          if (args[0].equals(""))
             throw new Exception ("Filename is NULL");

          File myFile = new File (args[0]);
          System.out.println (myFile.length());
   }
      catch (SecurityException e) {
         System.out.println ("File problem");             }
      catch (Exception e) {
             System.out.println (e.toString());
             }
    }
}    