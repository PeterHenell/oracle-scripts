import java.util.*;

class p { 
/*
/  The Java version of the PL/Vision p package.
/	Version 2.0
/
/  Author: Steven Feuerstein
/    Date: 12/25/98
*/   
  // Delimiter used between data elements.
  private static String Gdelim = " - ";

  // Get and Set for delimiter
  
  public static void setDelim (String newDelim) {
     Gdelim = newDelim;
  }  
  
  public static String delim () {
     return Gdelim;
  }
  
  // Overloading for general Object
  
  public static void l (Object obj) {
     System.out.println (obj);
  } 
  
  // Overloading for primitive types

  public static void l (int val) {
     System.out.println (val);
  }
  
  public static void l (long val) {
     System.out.println (val);
  }
  
  public static void l (boolean val) {
     System.out.println (val);
  }
  
  public static void l (float val) {
     System.out.println (val);
  }
  
  // Combinations of types and objects
  
  public static void l (int val1, int val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
  public static void l (long val1, long val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
  public static void l (boolean val1, boolean val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
  public static void l (Date val1, Date val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
  public static void l (String val1, String val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
  public static void l (String val1, int val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
  public static void l (String val1, long val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
  public static void l (String val1, Date val2) {
     System.out.println (val1 + Gdelim + val2);
  }
  
} 
