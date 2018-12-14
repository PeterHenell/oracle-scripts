abstract class RunTimer extends Timer { 
/*
/  Provide templates for benchmarking.
/
/  Author: Steven Feuerstein
/    Date: 12/28/98
*/ 
   abstract void timeIt ();
   abstract void timeIt (String arg1);
   abstract void timeIt (String arg1, String arg2);
       
   private void endAndShow (String context, int count)
   {
      super.end();
      showElapsed(context);
      p.l ("   Per iteration elapsed: " + (float)super.elapsed() / (float)count);
   }
   
   private long endShowAndReturn (String context, int count)
   {
      endAndShow (context, count);
      return elapsed();
   }
   
   public long repeat0 (String context, int count) {
      super.start();
      for (int i = 0; i < count; i++)
         timeIt ();
      return endShowAndReturn (context, count);
	}
   
   public long repeat1 (String context, String arg1, int count) {
      super.start();
      for (int i = 0; i < count; i++)
         timeIt (arg1);
      return endShowAndReturn (context, count);
	}
   
   public void repeat1Exec (String context, String arg1, int count) {
      super.start();
      for (int i = 0; i < count; i++)
         timeIt (arg1);
      endAndShow (context, count);
	}
   
   public long repeat2 (
      String context, String arg1, String arg2, int count) 
   {
      super.start();
      for (int i = 0; i < count; i++)
         timeIt (arg1, arg2);
      return endShowAndReturn (context, count);
	}
   
} 
