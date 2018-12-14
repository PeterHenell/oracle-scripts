public class Temp {
  public static void main(String[] args) {
    for(int i = 1; i <= 100; i++) { // count from 1 to 100
    i++;
switch (i % 2) {
   case 0:
      System.out.println ("Even");
      break;
   case 1:
      System.out.println ("Odd");
      break;
   default:
      System.out.println ("VERY odd");
      break;
   }
    }
  }
}
