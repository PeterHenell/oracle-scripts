abstract class plvtmr { 
/*
/  The Java version of the PL/Vision PLVtmr package.
/	Version 2.0
/
/  Author: Steven Feuerstein
/    Date: 12/28/98
*/ 
   abstract void timeIt ();
   abstract void timeIt (String arg1);
   abstract void timeIt (String arg1, String arg2);
       
   private long Gstart = 0;
   private int Grepeats = 0;

   public void capture () {
      Gstart = System.currentTimeMillis();
   }  
  
   public void showElapsed () {
      p.l ("Elapsed time ", System.currentTimeMillis() - Gstart);
   }  

   public long elapsed () {
      return (System.currentTimeMillis() - Gstart);
   }  

   public void showElapsed (String context) {
      p.l ("Elapsed time for " + context, elapsed());
   }  

   public long repeat0 (int count) {
      capture();
      for (int i = 0; i < count; i++)
         timeIt ();
      long timing = elapsed();
      p.l ("Elapsed time", timing);
      return timing;
	}
   
   public long repeat1 (String arg1, int count) {
      capture();
      for (int i = 0; i < count; i++)
         timeIt (arg1);
      long timing = elapsed();
      p.l (arg1 + " Elapsed time", timing);
      return timing;
	}
} 
