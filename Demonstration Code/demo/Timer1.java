class Timer { 
/*
/  The Java version of the PL/Vision PLVtmr package.
/	Version 2.0
/
/  Author: Steven Feuerstein
/    Date: 12/28/98
*/ 
   private long mstart = 0;
   private boolean mstart_set = false;

   private long mend = 0;
   private boolean mend_set = false;
   
   private String mcontext;

   private int mrepeats = 0;

   public void start (String context) {
      mstart = System.currentTimeMillis();
      mstart_set = true;
      mend_set = false;
      mcontext = "Elapsed";
      
	   if (context.length() > 0) 
         mcontext = mcontext + " from " + context;
   }  
  
   public void end (String context) {
      if (mstart_set)
      {
	      mend = System.currentTimeMillis();
	      mend_set = true;
	      
	   if (context.length() > 0) 
	      mcontext = mcontext + " to " + context;
      }
      else
         p.l ("You must set the starting point first.");
   }  
  
   public void start () {
      start ("");
   }  
  
   public void end () {
      end ("");
   }  
  
   public long elapsed (String context) {
      if (mend_set == false)
         end(context);
      return (mend - mstart);
   }  

   public long elapsed () 
   {
      return elapsed ("");
   }  

   public void showElapsed () 
   {
      showElapsed("");
   }  

   public void showElapsed (String context) 
   {
      long elapsedVal = elapsed(context);
      
	   if (mcontext.equals("Elapsed") && context.length() > 0)
         mcontext = mcontext + " for " + context;
         
      p.l (mcontext, elapsedVal + " millisecs");
   }  
} 
