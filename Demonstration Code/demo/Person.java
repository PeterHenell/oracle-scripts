import java.util.Date;

class Person {
   String name;
   long weight;
   Date dob;
   
   void showHeader () {
      System.out.println (" ");
      System.out.println (
         "-------Suppose " + this.name + " Was Convicted of a Crime.-------");
      System.out.println (" ");
      System.out.println (this);
   }
   
   // My wife has been reading Milton's Paradise Lost, so:
   void showPunishment () {System.out.println ("Leave Garden of Eden");};    
    
   // Here is an example of an abstract method: all the header,
   // none of the body. Every extended class from Person must
   // implement this method.
   void showPoliticalPower () {};  
   
}

class Citizen extends Person {
   String nation;
   String politicalPreference;
   
   // non-default Constructor method
   public Citizen (String Pname, String Pnation, String Ppref) {
      name = Pname;
      nation = Pnation;
      politicalPreference = Ppref; 
   }
    
   // the "special" object-to-string method
   public String toString () {
      return name + " is a citizen of " + nation +
         " whose politics are " + politicalPreference;
   }
   
   // Override of generic method.
   void showPunishment (){
      showHeader ();
      System.out.println (
         "Punishment? Go to jail, do not pass Go, do not survive.");
   }
   
   // implementation of abstract method
   void showPoliticalPower () {System.out.println ("One vote");};  
   
}

class Corporation extends Person {

// Very unfortunately, in this country corporations have received
// inappropriate legal recognition as a PERSON.

   long layoffs;
   long CEOCompensation;

   // Constructor method
   public Corporation (String Pname, long Playoffs, long PceoComp) {
      name = Pname;
      layoffs = Playoffs;
      CEOCompensation = PceoComp;
   }
   
   // Special method applicable only to corporations
   void maximizeProfits () {
      // same as layoffs = layoffs * 2;
      layoffs *= 2;
      
      CEOCompensation *= 10;
   }
   
   // the "special" object-to-string method
   public String toString () {
      return name + " is a transnational entity with " + layoffs +
         " laid-off employees, paying its Chief Executive Officer " + CEOCompensation;
   }
   
   // Override of generic method.
   void showPunishment (){
      showHeader ();
      System.out.println ("Punishment? Increase political contribution.");
   }

   // implementation of abstract method
   void showPoliticalPower () {System.out.println ("Virtually Unlimited");};  
}

class WarCriminal extends Citizen {
   long numberMurdered;
   String victimNation;

   // Constructor 
   public WarCriminal (
      String Pname, String Pnation, String PvictimNation, long Pvictims) {
      super (Pname, Pnation, "I Am Above the Law");
      numberMurdered = Pvictims;
      victimNation = PvictimNation;
   }
   
   // Override of generic method.
   void showPunishment (){
      showHeader ();
      System.out.println (name + " killed " + numberMurdered + 
         "  in " + victimNation);
      System.out.println ("Punishment? Win Nobel Peace Prize.");
   }

   // implementation of abstract method
   void showPoliticalPower () {System.out.println ("Filling of Vacuum");};  
}

class Progress {

   // So let's examine the progress persons have made over the years.

   public static void main (String[] args) {
   
      // The original person
	  Person Eve = new Person ();
	  System.out.println (Eve);

      // A very lowly citizen
      Citizen OnDeathRow = 
         new Citizen ("Mumia Abul Jamal", "USA", "Radical");
         
      // A very scary company
      Corporation TheGlobalMonster = 
         new Corporation ("Northrup-Ford-Mattel-Yahoo-ATT", 5000000, 50000000);
         
      // An even scarier human being
      WarCriminal WiseMan = 
         new WarCriminal ("Henry Kissinger", "USA", "Vietnam & Cambodia", 1000000);
      
      // Don't forget to take care of business
      TheGlobalMonster.maximizeProfits();
      
      // Declare an array of persons (the most general kind of object in this
      // hierarchy. Then populate that array with objects of subclasses.
      
      Person[] bigHappyFamily = {Eve, OnDeathRow, TheGlobalMonster, WiseMan};   
      
      // Here comes the beauty of dynamic polymorphism. Even though I am 
      // now looping through an array of Persons, when I call the 
      // showPunishment method, it will not call Person.showPunishment,
      // but instead call the showPunishment method for the subclass.
      // It "does the right thing".
      
      for (int persIndx = 0; persIndx < bigHappyFamily.length; persIndx++)
         bigHappyFamily[persIndx].showPunishment();
   }
}   


