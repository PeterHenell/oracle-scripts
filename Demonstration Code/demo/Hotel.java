/**
* @author : Umesh Kulkarni (ukulkarn.in)
* @Version 1.0
*
* Development Environment     : JDeveloper 2.0
*
* Name of the Application     : hotel.java
*
* Creation / Modification History
*    ukulkarn.in           Creation        18-Mar-1999
*
* Overview of the Application
*   The hotel.java file consists of a set of Java Methods. These Java Methods
*   are used to demonstrate following features.
*   ---------------------------------------------------------------------------
*     Feature Demonstrated                 Method Used For Demonstration
*   ---------------------------------------------------------------------------
*   1) Java Stored Procedure                   getRoomDetails()
*   2) Java Stored Function                    getLocalRate()
*   3) Java Stored Trigger                     updateAvailableRoomData()
*   4) Java Method in Specification of
*         Oracle 8 Object                      getHotelDetails()
*   5) Java Method in Body of Oracle 8 Object  getRoomDetails()
*   6) Java Stored Procedure Calling PL/SQL    getBestHotels()
*   7) PL/SQL Stored Procedure Calling Java    getRoomDetails()
*   8) Java CALL from Anonymous Block          getHotelDetails()
*
**/

import java.util.*;

import java.sql.*; // Package containing JDBC classes

//Package for Oracle Extensions to JDBC
import oracle.sql.*;
import oracle.jdbc.driver.*;


public class hotel {

  /**
  * This method finds out the Hotel Details namely HotelName, HotelAddress, Hotel
  * City, Hotel Country, and all the Facilities Available for a given Hotel.
  * Note: 1) Input Parameter to this method is HotelId where as Rest all are
  *           output parameters.
  *       2) Corresponding to IN OUT or OUT parameters from PL/SQL procedures,
  *          the Java Methods must have parameters that are a one-element array.
  **/
  public static void getHotelDetails(String HotelId, String[] HotelName,
  String[] HotelAddress, String HotelCity[], String HotelCountry[],
  String[] HotelFacilities) {
    Connection l_connection; //Database Connection Object
    try {
      // Get a Default Database Connection using Server Side JDBC Driver. Note :
      // This class will be loaded on the Database Server and hence use a Server
      // Side JDBC Driver to get default Connection to Database
      l_connection = new OracleDriver().defaultConnection();

      // Query to find Out Name, Address and City Id of the given Hotel
      PreparedStatement l_stmt =
          l_connection.prepareStatement("SELECT NAME, ADDRESS,  CTY_ID " +
          " FROM HOTELS WHERE ID = TO_NUMBER(?) ");

      l_stmt.setString(1,HotelId); // Bind the Input Parameter
      ResultSet l_rset = l_stmt.executeQuery(); // Execute Query and Get Result Set

      String  l_cityId = "";

      // Loop through the Result Set and fetch the values
      while (l_rset.next()) {
        HotelName[0] = l_rset.getString(1);
        HotelAddress[0] = l_rset.getString(2);
        l_cityId  = l_rset.getString(3);
      }
      // Close Result Set and Statement
      l_rset.close();
      l_stmt.close();

      // Query to find out City Name and Country Name from the fetched City ID
      l_stmt = l_connection.prepareStatement("SELECT a.NAME, b.NAME " +
       " FROM CITIES a, COUNTRIES b WHERE a.ID = TO_NUMBER(?) AND a.CON_ID = b.ID");

      l_stmt.setString(1,l_cityId); // Bind the CityID Parameter
      l_rset = l_stmt.executeQuery();// Execute Query and Get Result Set

      // Loop through the Result Set and fetch the values
      while (l_rset.next()) {
        HotelCity[0] = l_rset.getString(1);
        HotelCountry[0] = l_rset.getString(2);
      }

      // Close Result Set and Statement
      l_stmt.close();
      l_rset.close();

      // Query to Find out different facilities available with the given Hotel
      l_stmt = l_connection.prepareStatement("SELECT DISTINCT(FACILITY_TYPE_NAME)" +
        " FROM HOTEL_FACILITIES " + " WHERE HOT_ID = TO_NUMBER(?)");

      l_stmt.setString(1,HotelId); // Bind the HotelId Parameter
      l_rset = l_stmt.executeQuery();// Execute Query and Get Result Set

      boolean l_firstRecord = true;

      // Loop through the Result Set and Get all the facilities.
      // Note :If there are 3 facilities f1,f2,f3 then all three facilities
      // are concatenated with ## as in 'f1##f2##f3' and returned back as String
      while (l_rset.next()) {
        String l_facilityType = l_rset.getString(1);
        if (l_firstRecord) {
          HotelFacilities[0] = l_rset.getString(1);
          l_firstRecord = false;
        }else
           HotelFacilities[0] = HotelFacilities[0] + "##" + l_rset.getString(1);
      }

      // Close Result Set and Statement
      l_rset.close();
      l_stmt.close();

    } catch(SQLException ex){ //Trap SQL errors
      System.err.println(
          "Error in Executing getHotelDetails Method "+'\n'+ex.toString());
   }
  }

  /**
  * This method finds out the Room Details namely Number Of Rooms Available and
  * standard Room Rate for a given Hotel and Room Type
  *
  * Note: 1) Input Parameters to this method are HotelId and RoomType where as
  *          numRoomsAvailable and standardRoomRate are output parameters.
  *       2) Corresponding to IN OUT or OUT parameters of PL/SQL procedures,
  *          the Java Methods must have parameters that are a one-element array.
  **/
  public static void getRoomDetails(String HotelId, String RoomType,
  int[] numRoomsAvailable, float[] standardRoomRate) {
    Connection l_connection; //Database Connection Object
    try {
      // Get a Default Database Connection using Server Side JDBC Driver. Note :
      // This class will be loaded on the Database Server and hence use a Server
      // Side JDBC Driver to get default Connection to Database
      l_connection = new OracleDriver().defaultConnection();

      if (RoomType.equals("ORCL")) RoomType = "OTHR";

      // Query to find out Standard Room Rate for a given Hotel and Room Type
      PreparedStatement l_stmt = l_connection.prepareStatement("SELECT STANDARD_RATE " +
      " FROM AVAILABLE_ROOM_TYPES WHERE HOT_ID = TO_NUMBER(?) AND ROOM_TYPE = ? ");

      l_stmt.setString(1,HotelId); // Bind the HotelId Input parameter
      l_stmt.setString(2,RoomType); // Bind the RoomType Input Parameter

      ResultSet l_rset = l_stmt.executeQuery(); // Execute the Query and Get Result Set
      // Loop through the Result Set and fetch the results
      while (l_rset.next()) {
        standardRoomRate[0] = l_rset.getFloat(1); // Fetch Standard Room Rate
      }

      // Close the Result Set and Statement Objects
      l_rset.close();
      l_stmt.close();

      // Query to Find out total number of available Rooms for a given Room Type
      // and Hotel Id
      l_stmt = l_connection.prepareStatement("SELECT TOTAL_"+RoomType+
        " FROM ROOM_AVAILABILITY WHERE HOT_ID = TO_NUMBER(?) AND  " +
        " BOOKING_DATE = ( SELECT MAX(BOOKING_DATE) FROM ROOM_AVAILABILITY " +
        " WHERE HOT_ID = TO_NUMBER(?) )" );

      l_stmt.setString(1,HotelId);// Bind Input HotelId Parameter
      l_stmt.setString(2,HotelId);// Bind Input HotelId Parameter

      l_rset = l_stmt.executeQuery();//Execute Query and get Result Set
      // Loop through the Result Set and fetch results
      while (l_rset.next()) {
        numRoomsAvailable[0] = l_rset.getInt(1); // Get Number of Rooms Available
      }

      // Close Statement and Result Set
      l_stmt.close();
      l_rset.close();
    } catch (SQLException ex)  { // Trap SQL Errors
       System.err.println("Error in Executing getRoomDetails() method "+
                        '\n' + ex.toString());
   }
  }

  /**
  * This method finds out the Standard Room Rate for a given Hotel and Room Type,
  * in user's (traveler's) local currency.
  * Note: 1) Input Parameters to this method are HotelId , RoomType and traveler's
  *          nationality id
  *      2)  This function returns Standard Room Rate for a given Hotel Id and Room Type
  *          after converting to user's local currency
  **/
  public static float getLocalRate(String HotelId, String RoomType, String NationalityId) {
    Connection l_connection; // Database Connection Object
    float l_standardRoomRate = 0; // Variable to hold standard Room Rate
    try {
        String l_hotelCountryId = " ";
        int l_rowFetched = 0;
       // Get a Default Database Connection using Server Side JDBC Driver. Note :
       // This class will be loaded on the Database Server and hence use a Server
       // Side JDBC Driver to get default Connection to Database
       l_connection = new OracleDriver().defaultConnection();

       if (RoomType.equals("ORCL")) RoomType = "OTHR";

       // Query to find out Standard Room Rate for a given Hotel Id and Room Type
       PreparedStatement l_stmt = l_connection.prepareStatement("SELECT STANDARD_RATE " +
       " FROM AVAILABLE_ROOM_TYPES WHERE HOT_ID = TO_NUMBER(?) AND ROOM_TYPE = ? ");

       l_stmt.setString(1,HotelId);// Bind Input Parameter HotelId
       l_stmt.setString(2,RoomType);// Bind Input Parameter RoomType

       ResultSet l_rset = l_stmt.executeQuery(); // Execute Query and Get Result Set
       // Loop through Result Set and Fetch the Result
       while (l_rset.next()) {
         l_rowFetched ++;
         l_standardRoomRate = l_rset.getFloat(1); // Fetch standard Room Rate
       }

       // Close the Result Set and statement object
       l_rset.close();
       l_stmt.close();

       /* Check if the Standard Room Rate is available in Available_Room_Types Table*/
       if (l_rowFetched == 0) { // Data is not Available
         l_standardRoomRate =  -1;
         return l_standardRoomRate;  // Hence return -1
       }

       l_rowFetched = 0;
       // Query to find out the Country Id of the City where given Hotel is located
       l_stmt = l_connection.prepareStatement("SELECT b.CON_ID FROM hotels a, cities b " +
       " WHERE a.ID = TO_NUMBER(?) AND a.CTY_ID = b.ID ");

       l_stmt.setString(1,HotelId);// Bind Input parameter HotelId
       l_rset = l_stmt.executeQuery(); // Execute Query and Get Result Set
       // Loop through Result Set and Fetch the Result
       while (l_rset.next()) {
          l_hotelCountryId = l_rset.getString(1);// Fetch the CountryId of given Hotel
       }

       // Close the Result Set and statement object
       l_rset.close();
       l_stmt.close();

       // If the given Hotel is not present in the user's (traveller's own) country
       if (! NationalityId.equals((String)l_hotelCountryId)) {
         // Query to find out the Conversion Rate from Hotel country to user's country
         l_stmt = l_connection.prepareStatement("SELECT RATE FROM EXCHANGE_RATES WHERE " +
         " HOME_CON_ID = TO_NUMBER(?) AND NEW_CON_ID = TO_NUMBER(?)");
         l_stmt.setString(1,NationalityId); // Bind the Home Country Id
         l_stmt.setString(2,l_hotelCountryId); // Bind the Hotel Country Id
         l_rset = l_stmt.executeQuery();// Execute Query and Get Result Set
        // Loop through Result Set and Fetch the Result
         while (l_rset.next()) {
           // Fetch Exchange Rate and Calculate Standard Room Rate
           l_rowFetched ++;
           l_standardRoomRate = l_standardRoomRate * l_rset.getFloat(1);
         }

         // Close the Result Set and statement object
         l_rset.close();
         l_stmt.close();
         /* Check if the Exchange Rates are available in Exchange_Rates Table*/
         if (l_rowFetched == 0) { // Exchange Rates Not Available in Table
            l_standardRoomRate =  -1;
            return l_standardRoomRate;// Hence Return -1
         }
       }
    }catch (SQLException ex) {// Trap SQL Errors
       System.err.println("Error while Executing Get Local Rate()"+ ex.toString());
   }
   return l_standardRoomRate; // Return Standard Room Rate after conversion
 }

  /**
  * This method finds out the Best Hotels satisfying given criteria. The criteria
  * includes
  *   a) The Hotel should be present in the given city (CityName)
  *   b) The Hotel should have maximum number of Facilities required by the user
  *     (FacilityType) FacilityType variable will be of the form "F1##F2##F3"
  *      meaning that the user is interested in Facilities F1,F2 and F3
  *  c) The Hotel should have rooms of given RoomType with minimum Room Rate
  *     (RoomType)
  *
  * Depending on the above criteria, this method attaches a weight to each Hotel.
  * After computing weights for each Hotel, this method sorts the Hotels in ascending
  * order of weights.
  *
  * The Method then returns the Best Hotels in a String variable
  *
  * Weights Computation Procedure :
  *
  *  Let,
  *    1) Total Number Of Facilities required by user = nf
  *    2) Number Of Facilities hotel h can provide to above user = nr
  *    3) If the Hotel has the rooms of required ROOM_TYPE then
  *          Let ra = 1
  *       Else
  *          Let ra = 0
  *
  *  Then
  *    Weight for hotel h =  1 + nr + ra
  *
  * To illustrate, the Weights computation procedure let's take an example.
  * Suppose User wants to list Best Hotels in 'Tokyo' with
  * Meeting Facilities, Recreation Facilities and Conference Facilities.
  * Let User be interested in rooms of "KING" type.
  *
  * The inputs to this procedure then becomes
  *    CityName = "Tokyo"
  *    FacilityType = "MT##RF##CF" ( Note: MT is code for Meeting Facilities & so on )
  *    RoomType = "KING"
  *
  * Let us assume that Hotel h is equipped with Meeting Facilities and other
  * facilities are not available.
  *
  * Then  nf = Total Number Of Facilities required by user = 3
  *       nr = Number of Facilities hotel h can provide to above user = 1
  *       ra = 1 (Indicating that the required room types are available
  *
  * weight for hotel h = 1 + 1 + 1 = 3
  *
  * Note that this Method apart from querying the Database using JDBC, calls a
  * PL/SQL stored function GET_AVAILABLE_FACILITIES
  *
  **/
  public static void getBestHotels(String CityName, String FacilityType, String RoomType,
  String[] HotelNames){
    Connection l_connection; // Database Connection Object
    try {
      // Get a Default Database Connection using Server Side JDBC Driver. Note :
      // This class will be loaded on the Database Server and hence use a Server
      // Side JDBC Driver to get default Connection to Database
      l_connection = new OracleDriver().defaultConnection();
      // Get all the Hotels in given city
      int l_countHotels = 0, l_i=0;
      // Query to find out total number of Hotels in the given City, CityName
      PreparedStatement l_stmt = l_connection.prepareStatement("SELECT " +
       " COUNT(DISTINCT(a.ID)) FROM HOTELS a, CITIES b " +
       " WHERE a.CTY_ID = b.ID AND b.NAME like ? AND a.ADDRESS != 'hotel_city' ");

      l_stmt.setString(1,CityName); // Bind the CityName Input parameter
      ResultSet l_rset = l_stmt.executeQuery(); // Execute Query and Get Result Set
      // Loop through the Result Set and Fecth Values
      while (l_rset.next()) {
        l_countHotels = l_rset.getInt(1); // Get total number of Hotels in Given City
      }
      // Close Result Set and Statement Object
      l_rset.close();
      l_stmt.close();

      // Define Variables to Hold Hotel ID's , Hotel Names and correponsing weights
      String[] l_hotelID = new String[l_countHotels];
      String[] l_hotelNames = new String[l_countHotels];
      float[]  l_hotelWeights = new float[l_countHotels];
      String[] l_facilitiesAvailable = new String[l_countHotels];
      String[] l_roomTypeAvailable = new String[l_countHotels];

      int l_weight = 0;
      // Query to Find out Hotel Id's and Hotel Names for all Hotels in the given
      // city
      l_stmt = l_connection.prepareStatement("SELECT a.ID, a.NAME " +
      " FROM HOTELS a, CITIES b " + " WHERE a.CTY_ID = b.ID  AND b.NAME like ? " +
      " AND a.ADDRESS != 'hotel_city' ");

      l_stmt.setString(1,CityName);// Bind the CityName Input Parameter
      l_rset = l_stmt.executeQuery();  // Execute Query and Get Result Set
      // Loop through the Result Set and Fecth Values
      while (l_rset.next()) {
        l_hotelID[l_i] = l_rset.getString(1);// Get the Hotel Id
        l_hotelNames[l_i] = l_rset.getString(2);// Get the Hotel Name
        l_i++;
      }
      // Close the Result Set and Statement Object
      l_rset.close();
      l_stmt.close();

      if (RoomType.equals("ORCL")) RoomType = "OTHR";

      // Call a PL/SQL Stored Function to get all the facilities available with
      // given Hotel. Note that the PL/SQL Stored Function returns the available
      // facilities in a Varchar2 variable as "F1##F2##F3".
      CallableStatement l_cstmt =
          l_connection.prepareCall("{ ? = call GET_AVAILABLE_FACILITIES(?)}");
      int l_cntBestHotels = 0;
      String l_facilitiesProvided = new String("");
      // Loop through all the Hotels in Given City
      for (int l_j=0;l_j<l_countHotels;l_j++) {
        l_weight = 1;
        l_facilitiesProvided = " ";
        l_cstmt.setString(2,l_hotelID[l_j]); // Bind the HotelID parameter
        l_cstmt.registerOutParameter(1,OracleTypes.VARCHAR); // Function returns a VARCHAR2 value
        l_cstmt.execute(); // Execute the Call
        String l_availableFacilities = l_cstmt.getString(1); // Get the available Facilities
        // If the Hotel is equipped with at lease one facility then Parse the
        // Available Facilities String
        if (!l_availableFacilities.equals(new String("NO FACILITY"))) {
          java.util.StringTokenizer l_st1 = new java.util.StringTokenizer(l_availableFacilities,"##");
          boolean firstRec = true;
          while(l_st1.hasMoreTokens()) {
            String l_facility = l_st1.nextToken(); // Get individual Available Facility

            // If the available Facility is the one which is required by the user then
            // increase the weight
            if ( FacilityType.indexOf(l_facility) > -1) {
               l_weight ++;
               if (firstRec) {
                  l_facilitiesProvided = l_facilitiesProvided + l_facility;
                  firstRec = false;
               } else
                 l_facilitiesProvided = l_facilitiesProvided + "," + l_facility;
            }
          }
        }

        // Query to find out whether the Hotel provides Rooms of given Room Type
        PreparedStatement l_pstmt = l_connection.prepareStatement("SELECT COUNT(*) " +
        " FROM AVAILABLE_ROOM_TYPES WHERE HOT_ID = TO_NUMBER(?) AND ROOM_TYPE = (?)");

        l_pstmt.setString(1,l_hotelID[l_j]);// Bind HotelID parameter
        l_pstmt.setString(2,RoomType);// Bind RoomType Parameter
        l_rset = l_pstmt.executeQuery(); //Execute Query and get Result Set
        int l_cntRoomTypeAvailable = 0;
        while (l_rset.next()) {
             l_cntRoomTypeAvailable = l_rset.getInt(1);//
        }

        // Close the Result Set and Statement Object
        l_rset.close();
        l_pstmt.close();

        if (l_cntRoomTypeAvailable == 0)
           l_roomTypeAvailable[l_j] = "NO";
        else {
          l_roomTypeAvailable[l_j] = "YES";
          l_weight ++;
        }
        l_facilitiesAvailable[l_j] = l_facilitiesProvided;
        l_hotelWeights[l_j] =  l_weight;
      }
      // Sorting Weights Array To Order Hotel Names in ascending order of weights
      // Using Bubble Sort Algorithm to Sort weights Array
      int l_outerLoop = 0;
      int l_innerLoop = 0;
      for(l_outerLoop=0;l_outerLoop < l_countHotels - 2;l_outerLoop++) {
        for(l_innerLoop=l_outerLoop+1; l_innerLoop <= l_countHotels -1; l_innerLoop++) {
          if (l_hotelWeights[l_innerLoop] > l_hotelWeights[l_outerLoop]) {
            float l_tmpweight = l_hotelWeights[l_innerLoop];
            String l_tmpHotelname = l_hotelNames[l_innerLoop];
            String l_tmpfacilityProvd = l_facilitiesAvailable[l_innerLoop];
            String l_tmproomAvailable = l_roomTypeAvailable[l_innerLoop];

            l_hotelWeights[l_innerLoop] = l_hotelWeights[l_outerLoop];
            l_hotelWeights[l_outerLoop] = l_tmpweight;

            l_hotelNames[l_innerLoop] = l_hotelNames[l_outerLoop];
            l_hotelNames[l_outerLoop] = l_tmpHotelname;

            l_facilitiesAvailable[l_innerLoop] = l_facilitiesAvailable[l_outerLoop];
            l_facilitiesAvailable[l_outerLoop] = l_tmpfacilityProvd;

            l_roomTypeAvailable[l_innerLoop] = l_roomTypeAvailable[l_outerLoop];
            l_roomTypeAvailable[l_outerLoop] = l_tmproomAvailable;
          }
        }
      }
      l_outerLoop = 0;
      //Pack all the Best Hotel Names into a String variable and return it
      String l_bestHotels = new String("");
      for (int l_counter=0;l_counter<l_countHotels;l_counter++) {
          l_bestHotels = l_bestHotels + "$" +
          new String(l_hotelNames[l_counter]) + "#" +
          new String(l_facilitiesAvailable[l_counter]) + "#" +
          new String(l_roomTypeAvailable[l_counter]) ;
      }
      HotelNames[0] = l_bestHotels;
    } catch (SQLException ex) { // Trap SQL Errirs
      System.err.println("Error While Executing Procedure Get_BEST_HOTELS " +
                           ex.toString());
   }
}

  /**
  * This method Updates the available Room Data after a user check-in, check-out a
  * room.
  *
  * Note: 1) Input Parameters to this method are HotelId , RoomType, Number Of rooms and
  *          update flag.
  *       2) When user check-in a Hotel, the updateFlag will be "CIN".
  *          When user check-out a Hotel, the updateFlag will be "COUT"
  *       3)  This procedure updates the Available Room Data in Table ROOM_AVAILABILITY
  *       4) By making use of this method, a Basic Java Stored Trigger is demonstrated.
  **/

  public static void updateAvailableRoomData(int HotelId, String RoomType,
  int NumOfRooms, String updateFlag) {
    Connection l_connection; // Database Connection Object
    try {
      // Get a Default Database Connection using Server Side JDBC Driver. Note :
      // This class will be loaded on the Database Server and hence use a Server
      // Side JDBC Driver to get default Connection to Database
      l_connection = new OracleDriver().defaultConnection();

      // Note : Same method is used to update Available Room Data when
      //        1) User check-in a Hotel and
      //        2) User check-out a Hotel
      String l_addBookedSeats = " + ";
      String l_subTotalSeats  = " - ";
      // If updateFlag is COUT then decrease booked seats and increase total
      // number of available seats
      if (updateFlag.equals("COUT")) {
         l_addBookedSeats = " - ";
         l_subTotalSeats  = " + ";
      }
      if (RoomType.equals("ORCL")) RoomType = "OTHR";

      // Query to update ROOM_AVAILABLITY Table
      PreparedStatement l_pstmt =
          l_connection.prepareStatement("UPDATE ROOM_AVAILABILITY " +
          " SET BOOKED_" + RoomType + " = BOOKED_" + RoomType + l_addBookedSeats +
           NumOfRooms + " , TOTAL_" + RoomType + " = TOTAL_" + RoomType +
           l_subTotalSeats + NumOfRooms + " WHERE HOT_ID = ?  AND  BOOKING_DATE  = " +
          " ( SELECT MAX(BOOKING_DATE) FROM ROOM_AVAILABILITY WHERE HOT_ID = ? )" );

      l_pstmt.setInt(1,HotelId); // Bind the Hotel ID input parameter
      l_pstmt.setInt(2,HotelId); // Bind the Hotel Id input parameter
      int l_NoRecordsUpdated = l_pstmt.executeUpdate(); // Execute the Statement
      l_pstmt.close(); //Close the Statement
      l_pstmt = l_connection.prepareStatement("COMMIT"); // Commit the changes
      l_pstmt.execute(); // Execute the Statement
      l_pstmt.close(); // Close the Statement
    } catch (SQLException ex) { // Trap SQL Errors
      System.err.println("Error while executing UpdateAvailableRoomData " +
        ex.toString());
    }
  }
}
