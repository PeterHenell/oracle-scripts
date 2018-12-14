import p;
import java.util.*;

class ptest {

   public static void main (String[] args) {
      short s = -134;
      byte b = (byte)s;
      int i1=1,i2=2;
      Date d1 = new Date ();
      Date d2 = new Date ();
      Vehicle veh = new Vehicle();
      Vehicle veh2 = new Vehicle();
      p.l (args[0]);
      p.l ("hello");
      p.l (veh);
      p.l (veh2);
      p.l (d1, d2);
   }
}