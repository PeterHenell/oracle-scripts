class Vehicle {
   // Constant hidden from public use.
   private static String noName = "No Name";
   
   // Privatized fields of the object.
   private long GidNumber = 0;
   private int Gspeed;
   private int Gdirection;
   private String Gowner;
   
   // Get methods for the fields
   public long idNumber () { return GidNumber; }
   public int speed () { return Gspeed; }
   public int direction () { return Gdirection; }
   public String owner () { return Gowner; }
   
   // Set methods for the fields
	public void setIdNumber (long idNumber) { GidNumber = idNumber; }
	public void setSpeed (int speed) { Gspeed = speed; }
	public void setDirection (int direction) { Gdirection = direction; }
	public void setOwner (String owner) { Gowner = owner; }
   public void stop (int spd) { Gspeed = 0; }
   
   // Public method associating an owner name and vehicle number.
   public void Register (long idNum, String ownername) {
      Gowner = ownername;
      GidNumber = idNum;
   }

   // Override of default constructor makes sure that
   // any Vehicle object's default name is noName.
   public Vehicle () {
      Gowner = noName;
   }
   
   public String toString () {
      return ("Owned by " + owner () + " with ID " + idNumber () + " traveling at " + Gspeed);
   }

   // Boolean function checks name of owner to see if registered.
   // Uses the String equals method to check contents, instead of
   // object reference.
   public boolean isRegistered () {
      if (Gowner.equals (noName) )
         return false;
      else
         return true;
   }
}
