class MyVehicle3 { 
// Reworked by Bill Pribyl

  private static Vehicle mywagon; 
  private static Vehicle hiswagon; 
  private static Vehicle yourwagon; 

  public static void main (String[] args) { 
     mywagon = new Vehicle(); 
     hiswagon = new Vehicle(); 
     yourwagon = mywagon; 

     mywagon.owner = "Steven"; 
     mywagon.idNumber = 123456; 
     checkAll(); 

     yourwagon.owner = "Veva"; 
     checkAll(); 

     hiswagon.Register (778899, "Eli"); 
     checkAll(); 
  } 

  private static void checkIt (Vehicle wheels) { 
     if ( wheels.isRegistered() ) 
        System.out.println (wheels); 
     else 
        System.out.println ("Unregistered"); 
  } 

  private static void checkAll() { 
     checkIt (mywagon); 
     checkIt (yourwagon); 
     checkIt (hiswagon); 
  } 

} 
