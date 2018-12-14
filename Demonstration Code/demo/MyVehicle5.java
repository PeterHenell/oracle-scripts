import p;

class MyVehicle5 {

   private static void checkIt (Vehicle wheels) {
      if ( wheels.isRegistered() )
         p.l (wheels);
      else
         p.l ("Unregistered");
	}
      
   public static void main (String[] args) {
      Vehicle mywagon = new Vehicle();
      Vehicle hiswagon = new Vehicle();
      Vehicle yourwagon = mywagon; //now changes to mywagon affect yourwagon.
                                   // and vice versa, as shown below.
      
      // Use accessor methods instead of direct references.
      mywagon.setOwner ("Steven");
      mywagon.setIdNumber (123456);
      
      checkIt (mywagon);
      checkIt (yourwagon);
      checkIt (hiswagon);
      
      //yourwagon.owner = "Veva";

      checkIt (mywagon);
      checkIt (yourwagon);
      checkIt (hiswagon);

      hiswagon.Register (778899, "Eli");

      checkIt (mywagon);
      checkIt (yourwagon);
      checkIt (hiswagon);
      
   }
}