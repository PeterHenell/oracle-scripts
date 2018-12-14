class Tmr { 
   private long Gstart = 0;

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
} 
