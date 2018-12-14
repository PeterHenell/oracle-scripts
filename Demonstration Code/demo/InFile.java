import java.io.*;
import java.util.*;

class InFile { 
/*
/  Author: Steven Feuerstein
/    Date: 12/25/98
*/ 
   public static int numBytes (String filename) 
      //throws IOException
   {
   try
      {
      InputStream in;
      
      if (filename.length() == 0)
         in = System.in;
      else
         in = new FileInputStream (filename);
         
      int total = 0;
      
      while (in.read () != -1)
         total++;
         
      return total;
      }
      catch (IOException e) 
      {
         return -1;
      }
	}

   public static int numBytes2 (String filename) 
      //throws IOException
   {
   try
      {
      FileInputStream in = new FileInputStream (filename);
      
      // Available is good for use with files, since the whole file
      // is generally available.
      return in.available();
      }
      catch (IOException e) 
      {
         return -1;
      }
	}
   
   public static void main (String args[]) {
      int count = Integer.parseInt (args[0]);

      p.l ("Size of " + args[1], numBytes2(args[1]));
      p.l ("Size of " + args[1], numBytes(args[1]));
      
      Tmr myTimer = new Tmr();
      myTimer.capture();
      for (int i = 0; i < count; i++) {
         long fileSize = numBytes(args[1]);
      }
      myTimer.showElapsed();
      
      myTimer.capture();
      for (int i = 0; i < count; i++) {
         long fileSize = numBytes2(args[1]);
      }
      myTimer.showElapsed();
   }
}   