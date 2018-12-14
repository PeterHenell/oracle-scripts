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
       
   public long repeat0 (String context, int count) {
      super.start();
      for (int i = 0; i < count; i++)
         timeIt ();
      super.end();
      showElapsed(context);
      p.l ("   Per iteration elapsed: " + (float)super.elapsed() / (float)count);
      return elapsed();
	}
   
   public long repeat1 (String context, String arg1, int count) {
      super.start();
      for (int i = 0; i < count; i++)
         timeIt (arg1);
      super.end();
      showElapsed(context);
      p.l ("   Per iteration elapsed: " + (float)super.elapsed() / (float)count);
      return elapsed();
	}
   
} 
