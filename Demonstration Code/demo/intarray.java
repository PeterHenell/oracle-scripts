class Fib2 {
   static final int max_index = 10;
    
   public static void main (String[] args) {
      int lo=1,hi=1;
      String mark;
      int[] fullList = new int[20];
      
      System.out.println ("1: " + lo);
      for (int i = max_index; i > 1; i--) {
         if (hi % 2 == 0)
            mark = " *";
         else
            mark = "";
         System.out.println (i + ": " + hi + mark);
         fullList[i] = hi;
         hi = lo + hi;
         lo = hi - lo;
      }
      for (int i = 0; i<=fullList.length; i++) {
         System.out.println (fullList[i+20]);
      }
   }
}