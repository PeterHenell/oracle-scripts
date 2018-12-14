import p;

class MyVehicle4 {

   // Allocate an instance of the System.out.println extender.
   // I only need one for use within this class.
   static p myprint = new p ();
   
   private static void checkIt (Vehicle wheels) {
      if ( wheels.isRegistered() )
         myprint.l (wheels);
      else
         myprint.l ("Unregistered");
	}
      
   public static void main (String[] args) {
      Vehicle mywagon = new Vehicle();
      Vehicle hiswagon = new Vehicle();
      Vehicle yourwagon = mywagon; //now changes to mywagon affect yourwagon.
                                   // and vice versa, as shown below.
      
      // Use accessor methods instead of direct references.
      mywagon.setOwner ("Steven");
      mywagon.setIdNumber (123456);
      
      // Cast a long to an int! No implicit conversions allowed.
      //myprint.l ((int)mywagon.idNumber, (int)hiswagon.idNumber);
      
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