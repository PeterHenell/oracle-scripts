class p { 
/*
/  The Java version of the PL/Vision p package.
/	Version 2.0
/
/  Author: Steven Feuerstein
/    Date: 12/25/98
*/   
  char delim = ' - ';
  
  /* Wow! Due to the wonders of inheritance, I don't 
     have to provide overloadings for different
     classes. Just one for the generic Object class
     will do...?
  public static void l (String str) {
     System.out.println (str);
  }*/
  
  // Support for common primitive types
  public static void l (Object obj) {
     System.out.println (obj);
  }
  
  public static void l (int intval) {
     System.out.println (intval);
  }
  
  public static void l (boolean bool) {
     System.out.println (bool);
  }
  
  public static void l (float buoy) {
     System.out.println (buoy);
  }
  
  // Combinations of primitives
  
  public static void l (int intval1, int intval2) {
     System.out.println (intval1 + delim + intval2);
  }
  
  public static void l (boolean bool1, boolean bool2) {
     System.out.println (bool1 + delim + bool2);
  }
  
} 
