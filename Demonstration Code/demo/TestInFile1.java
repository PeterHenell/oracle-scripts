// Example of use of abstract class to do timing.

import java.io.*;

class TestInFile extends plvtmr {

   // I provide my own implementation of these programs.
   // These are the things whose performance I want to measure.
   // I have to implement all to be able to extend the abstract
   // class.
   
   void timeIt () {
   try {
      int result;
      result = Infile.numBytes2 ("c:\\temp\\te_employee.tps");
   }
      catch (IOException e) {
         p.l ("Error " + e);
      }
   }
   
   void timeIt (String arg1) { 
   try {
      int result;
      result = Infile.numBytes2 (arg1);
   }
      catch (IOException e) {
         p.l ("Error " + e);
      }
   }
   
   void timeIt (String arg1, String arg2) { p.l (arg1); };
   
   public static void main (String[] args) {
   
      int count = Integer.parseInt (args[0]);
      long withfilename = new TestInFile().repeat0(count);
      long passfilename = new TestInFile().repeat1("c:\\temp\\te_employee.tps", count);
      
      p.l ("With File", withfilename);
      p.l ("Pass File", passfilename);
      
      /*
      try {
         int result;	
	      sf_timer.start_timer();
	      for (int i = 0; i < count; i++) {
	         result = Infile.numBytes2 (args[1]);
            if (i == 0) p.l (result);
            }
	      plvtmr.showElapsed ("Available");
	   
	      sf_timer.start_timer();
	      for (int i = 0; i < count; i++) {
	         result = Infile.numBytes (args[1]);
            if (i == 0) p.l (result);
            }
	      plvtmr.showElapsed ("Countem");
      }
      catch (IOException e) {
         p.l ("Error " + e);
      }
      */
   }
}