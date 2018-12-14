class Vehicle {
   // Constant hidden from public use.
   private static String noName = "No Name";
   
   //
   public static long idNumber = 0;
   
   // Accessible fields of the object.
   public int speed;
   public int direction;
   public String owner;
   
   // Override of default constructor makes sure that
   // any Vehicle object's default name is noName.
   public Vehicle () {
      owner = noName;
   }
   
   // Automatically (by using the toString name) provides a String
   // representation of the object when that object is referenced
   // in a call to System.out.println.
   public String toString () {
      return ("Owned by " + owner + " with ID " + idNumber);
   }

   // Public method associating an owner name and vehicle number.
   public void Register (long idNum, String ownername) {
      owner = ownername;
      idNumber = idNum;
   }

   // Boolean function checks name of owner to see if registered.
   // Uses the String equals method to check contents, instead of
   // object reference.
   public boolean isRegistered () {
      if (owner.equals (noName) )
         return false;
      else
         return true;
   }
}
