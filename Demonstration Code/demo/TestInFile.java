// Example of use of abstract class to do timing.

import java.io.*;

class TestInFile extends RunTimer {

   // I provide my own implementation of these programs.
   // These are the things whose performance I want to measure.
   // I have to implement all to be able to extend the abstract
   // class.
   
   void timeIt () {
      int result
         = Infile.numBytes2 ("c:\\temp\\te_employee.tps");
   }
   
   void timeIt (String arg1) { 
      int result
         = Infile.numBytes2 (arg1);
   }
   
   void timeIt (String arg1, String arg2) { p.l (arg1); };
   
   public static void main (String[] args) {
      // Convert string value to int.
      int count = Integer.parseInt (args[0]);
      
      // Perform the two timings by calling the methods
      // defined in the abstract class. 
      
      long withfilename = new TestInFile().repeat0("Count Bytes in File", count);
      
      long passfilename = 
         new TestInFile().repeat1("Avail Bytes in File", "c:\\temp\\te_employee.tps", count);
         
      // Now I will use a void method from an abstract class!
      TestInFile mytester = new TestInFile();
      mytester.repeat1Exec("Avail Bytes in File", "c:\\temp\\te_employee.tps", count);
   }
}