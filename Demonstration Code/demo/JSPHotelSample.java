/**
 * @author  Rajesh
 * @version 1.0
 *
 * Development Environment        :  JDeveloper 2.0
 * Name of the Application        :  JSPHotelSample.java
 * Creation/Modification History  :
 *
 * rsundara.in       29-Mar-1999      Created
 *
 * Overview of Application        :
 *
 * This application is an integrated hotel reservation and enquiry application
 * that uses Java Stored Procedures in a number of ways to implement business
 * logic.
 *
 * Java Stored Procedures, Functions and Triggers are used as part of this
 * application. Further Java Stored Procedures that call PLSQL procedures, and
 * also Java Stored Procedure calls from anonymous PLSQL blocks are illustrated.
 *
 * This application has a number of hotel reservation components, each of which
 * uses JSPs in the backend Oracle 8i database, in different ways.
 *
 * Each JSP is implemented in various methods of the "hotel" class, the source
 * for which is in hotel.java
 *
 * The various components of the system, and the Java Stored Procedures used by
 * them are :-
 *
 * Hotel Details: Uses the JAVA STORED PROCEDURE get_hotel_details called from
 * an anonymous PLSQL block, and is implemented in the getHotelDetails() method
 * of this class
 *
 * Room Availability and Rates: Uses the JAVA STORED PROCEDURE get_room_details
 * and is implemented in the getRoomAvailabilityRates() method of this class
 *
 * Match Suitable Hotels : Uses a JAVA STORED PROCEDURE get_best_hotels, which
 * in turn uses a PLSQL procedure in its implementation.
 * This component is implemented in the JSPBestHotels class.
 *
 * Room Rates in Local Currency: Uses JAVA STORED FUNCTION, to convert room rates
 * to the chosen currency. Implemented in the getLocalRoomRates() method of this
 * class.
 *
 * Room Reservation and Cancellation: Use JAVA STORED TRIGGERS that use the
 * updateRoomAvailability Java methods in hotel.java to implement their business
 * logic. Implemented in the reserveRoom and roomCancellation() methods of this
 * class.
 *
 * The GUI for this sample is handled in JSPHotelFrame.java
 *
 */

import java.sql.*;   //Package for JDBC classes
import java.util.*;  //Package which holds Vector class

// Package for Oracle Extensions to JDBC
import oracle.sql.*;
import oracle.jdbc.driver.*;

public class JSPHotelSample {

  Connection m_connection;    //Database Connection Object
  JSPHotelFrame m_GUI;        // GUI handler for this sample

  /**
  * Constructor. Instantiates GUI.
  **/
  public JSPHotelSample() {
    try {
        m_GUI=new JSPHotelFrame(this); // Instantiate GUI
        m_GUI.setVisible(true);
    }catch (Exception e) { //Trap general errors
      m_GUI.putStatus(e.toString());
    }
  }

  /**
  *  Main entry point for the class. Instantiates root class and  sets up the
  *  database connection.
  **/
  public static void main(String[] args)throws SQLException{
    JSPHotelSample root = new JSPHotelSample();// Instantiate application class

    root.dbConnection();             // Setup the db connection
    root.m_GUI.m_tablemodel.clearTable();

    root.populateHotels();             // Populate JTable with Hotel Records
  }

  /**
  * Dispatches the GUI events to the appropriate method, which perform
  * the required JDBC operations. This method is invoked when events occur
  * in the GUI (like table Selection, Button clicks etc.).
  **/
  public void dispatchEvent(String p_eventName) {

    // *********************************
    // Dispatch GET HOTEL DETAILS event
    if (p_eventName.equals("GET HOTEL DETAILS")){
      getHotelDetails();
    }

    // ******************************************************
    // Dispatch Event for ROOM AVAILABILITY and RATES enquiry
    if (p_eventName.equals("ROOM AVAILABILITY AND RATES")){
        int l_selectedHotelID = m_GUI.getSelectedHotelID();

      // Fetch room details  only if a hotel is selected
      if( l_selectedHotelID >=0)
        getRoomAvailabilityRates(l_selectedHotelID);
    }

    // *******************************
    // Dispatch SHOW LOCAL RATES Event
    if(p_eventName.equals("SHOW LOCAL RATES")){
       //Obtain the selected nationality and country id from GUI
       int l_countryId=0;

       // Get the chosen country name
       String l_countryName=(String) m_GUI.m_op.m_cnationality.getSelectedItem();

       // If a valid country chosen then parse the ID from the country name.
       // The Country ID is concatenated to the Country name for display in the
       // GUI
       if(!l_countryName.equals("Please select a local nationality")){

         StringTokenizer st=new StringTokenizer(l_countryName,"-");
         m_GUI.m_op.m_tablemodel.clearTable();
         while(st.hasMoreTokens()){
           st.nextToken();
           l_countryId=Integer.parseInt(st.nextToken());
           st.nextToken();
         }

         // Call method to Obtain Room Rates in Local Currency
         getLocalRoomRates(m_GUI.m_op.m_hotelId,l_countryId);
      }
    }

    // *****************************************
    // Dispatch the MATCH SUITABLE HOTELS Event
    if(p_eventName.equals("MATCH SUITABLE HOTELS")){

      // The Match Best Hotels functionality is handled by the JSPBestHotels
      // class. Instantiate the class here to open the Best Hotels frame.
      JSPBestHotels l_matchhotels = new JSPBestHotels(m_connection);
    }

    // ********************************
    // Dispatch the ROOM RESERVATION Event
    if(p_eventName.equals("RESERVE ROOM")) {

       // Obtain the entered fields from the Reservation Form
       String l_roomType = (String)m_GUI.m_Pane.m_jComboBox.getSelectedItem();
       String l_Date     = m_GUI.m_Pane.m_arrDate.getText();
       String l_Name     = m_GUI.m_Pane.m_ssNumb.getText();
       int l_numNigh   = Integer.parseInt(m_GUI.m_Pane.m_numNight.getText());
       int l_Room      = Integer.parseInt(m_GUI.m_Pane.m_numbRoom.getText());

       // Call the reserve room method, to save the reservation with above data
       reserveRoom(l_Date, l_Name, l_roomType, l_numNigh, l_Room);
    }

    //**********************************
    // Dispatch the SHOW ROOM BOOKINGS Event. This event is called when
    // cancellation button is pressed from the main window.
    if(p_eventName.equals("SHOW ROOM BOOKINGS")){
       // Retrieve and populate the room bookings available
       showRoomBookings(m_GUI.getSelectedHotelID());

       m_GUI.displayRoomBookings(); // Display the bookings
    }

    //**********************************
    // Dispatch the CANCEL ROOM Event. This event is called when
    // cancellation button is pressed after choosing a booking from the
    // cancellation dialog.
    if(p_eventName.equals("CANCEL ROOM")){
       // Retrieve and populate the room bookings available
       roomCancellation(m_GUI.m_cancelDialog.getSelectedBookingID());
    }


    // ***************************************
    // Dispatch the exit application event
    if (p_eventName.equals("EXIT"))
      exitApplication();
  }

  /**
  * This method retrieves the details for a selected hotel by calling the
  * JSP, get_hotel_details, from an anonymous PLSQL block. The retrieved
  * details are then displayed in a Dialog Box in GUI.
  *
  * JSP feature used:
  *     Java Stored Procedure called from an anonymous PLSQL block
  **/
  public void getHotelDetails() {

    // Call the JSP to fetch hotel details for the selected hotel, by making a
    // call to the Java Stored Procedure get_hotel_details in an anonymous
    // PLSQL block
    //
    // JDBC is used in the following block to call the JSP. The SQLJ code
    // equivalent to the block below will be:
    //
    // #sql { begin get_hotel_details(:in hotel_id,:out hotel_name,:out address
    //                         ,out city,out country,out facilities end;};
    try {

      m_GUI.putStatus("Calling JSP to retrieve Hotel Details ...");

      // Prepare a statement to create an anonymous PLSQL block that calls the
      // get_hotel_details Java Stored procedure.
      CallableStatement l_stmt =
          m_connection.prepareCall(" begin  get_hotel_details(?,?,?,?,?,?); end ;");

      l_stmt.setInt(1,m_GUI.getSelectedHotelID()); // Bind IN paramete Hotel ID

      // Binds the OUT parameter types
      l_stmt.registerOutParameter(2,OracleTypes.VARCHAR);
      l_stmt.registerOutParameter(3,OracleTypes.VARCHAR);
      l_stmt.registerOutParameter(4,OracleTypes.VARCHAR);
      l_stmt.registerOutParameter(5,OracleTypes.VARCHAR);
      l_stmt.registerOutParameter(6,OracleTypes.VARCHAR);

      // execute the callable statement
      l_stmt.execute();

      // Retrieve all the details from the OUT parameters
      String l_hotelName = l_stmt.getString(2);
      String l_hotelAddress = l_stmt.getString(3);
      String l_hotelCity = l_stmt.getString(4);
      String l_hotelCountry = l_stmt.getString(5);
      String l_hotelFacilities = l_stmt.getString(6);

      // No facilities returned
      if(l_hotelFacilities == null)
        l_hotelFacilities = "No Facilities Available";

      m_GUI.appendStatus("Done");

      //Display the results obtained in GUI
      m_GUI.displayHotelDetails(l_hotelName,l_hotelAddress,l_hotelCity
                                ,l_hotelCountry,l_hotelFacilities);

      l_stmt.close(); //Close the statement
      m_GUI.clearStatus();
    }catch (SQLException ex) { // Trap SQL Errors
      m_GUI.putStatus("Error while Calling PL/SQL Procedure\n" + ex.toString());
     }
   }


  /**
  * This Method calls the Java Stored Procedure get_room_details, to obtain the
  * room availability and rate details for a hotel.
  *
  * The method first obtains all the room types available in the hotel using a
  * JDBC resultset, and then calls the get_room_details java stored procedure
  * to obtain rate and availability.
  *
  * The body of get_room_details is implemented as the getRoomDetails() method in
  * hotel.java
  *
  * JSP feature used:
  *    Java Stored Proceudure call using the "CALL" SQL statement
  **/
  public void  getRoomAvailabilityRates(int p_selectedHotelID){

    // Vector to store resulting table
    Vector l_resultTable= new Vector();

    // Call the JSP to fetch room details.
    // JDBC is used in the following block to call the JSP. The SQLJ code
    // equivalent to the block below will be:
    //
    // #sql iterator roomTypeIter { String room_type };
    //
    // #sql roomTypeIter = { Select distinct(room_type) from
    //         available_room_types where hot_id = :hotelID }
    //
    // while(roomTypeIter.next()) {
    //  #sql { CALL get_Room_Details(  :selectedHotelID, roomTypeIter.room_Type(),
    //                                                                   :out availableRooms, :out standardRate) };
    // }
    try{

      m_GUI.putStatus("Fetching Room Details using Java Stored Procedures.. ");
     // Forming  and executing the query. This query selects room types
     // available in the selected hotel.
      Statement l_statement=m_connection.createStatement();
      String l_query="select room_type from  Available_room_types "+
                "where hot_id = " + p_selectedHotelID;
                        ResultSet l_result=l_statement.executeQuery(l_query);

                        // Create a callableStatement for calling JavaStored
      // Procedure  'Get_Room_Details()'.
                        CallableStatement l_callbleStatement =
            m_connection.prepareCall("{ call get_Room_Details(?,?,?,?) }");

      // Setting  the type of output parameters
      l_callbleStatement.registerOutParameter(3,Types.INTEGER);
      l_callbleStatement.registerOutParameter(4,Types.FLOAT);

                        // For each room type  Java Stored Procedure will be called
      // to fetch available rooms and standard room rates

      while (l_result.next()) {

        // Get the room type from the result set.
        String  l_roomType = l_result.getString(1);

        // Setting the Input parameters for Java Stored Procedure
        l_callbleStatement.setInt(1, p_selectedHotelID);
        l_callbleStatement.setString(2, l_roomType);

        // Call JavaStored Procedure to fetch room details.
        l_callbleStatement.execute();

        // Creating new output row with the result
        Vector l_newrow = new   Vector();
        l_newrow.addElement(l_roomType);
        l_newrow.addElement(new Float( l_callbleStatement.getFloat(4) ));
        l_newrow.addElement(new Integer( l_callbleStatement.getInt(3) ));

        //  Add the new row to the result table.
        l_resultTable.addElement(l_newrow);
                        }

                        // Closing  result set, jdbc statement and callblestatement.
      l_result.close();
      l_statement.close();
      l_callbleStatement.close();
                        m_GUI.appendStatus("Done ");

      // Display the result using Jtable
      m_GUI.displayRoomDetails(l_resultTable);
      m_GUI.clearStatus();

                }catch(SQLException ex){ //Trap SQL Errors
      m_GUI.putStatus(" Error while Getting Room Details "+ex.toString());
    }
  }


  /**
  * This method calls the java stored function GET_LOCAL_RATE() with the hotel id,
  * room type and the nationality id, and displays the rate of each type of room
  * in the local currency
  *
  * JSP feature useed :
  *     Java Stored Function Call
  **/
  public void getLocalRoomRates(int p_id,int p_countryId){
    Vector l_tempholder=null;

    // Retrieve the room rate for each room type by making a call to the Java
    // Stored Function get_Local_Rate
    //
    // JDBC is used in the following block to call the JSF. The SQLJ code
    // equivalent to the block below will be :
    //
    // #sql iterator RoomTypeIter (String room_type); //Iterator to hold room type
    //
    // RoomTypeIter l_roomtypes;
    //
    // #sql l_roomtypes = { select room_types from available_room_types where
    //                       hot_id=:p_id };
    // while (l_roomtypes.next()){
    //   #sql { CALL GET_LOCAL_RATES(:in p_id,:in l_roomtype,:in p_countryId,
    //                     :out result };
    //    -- calling JSF to retrieve local room rate

    try{

     // Statement Context to query all available room types for chosen hotel
      PreparedStatement l_statement=m_connection.prepareStatement(
           "select room_type from available_room_types where hot_id=?");
      l_statement.setInt(1,p_id);

      // Retrieve all rows from the hotels table into a ResultSet
      ResultSet l_resultSet=l_statement.executeQuery();

      // Loop through the result-set, and call the Java Stored Function to
      // obtain room rate for each room type
      while (l_resultSet.next()){
          String l_roomtype=l_resultSet.getString(1);  // Room Type
          Integer l_integer=new Integer(p_countryId);  // Local Country ID


          // Create a Callable Statement to call the Java Stored Function,
          // GET_LOCAL_RATE, which maps to the Java Method getLocalRate in
          // hotel.java
          CallableStatement l_stmt =
               m_connection.prepareCall("{ ?  = call GET_LOCAL_RATE(?,?,?)}");

          // Bind the IN Parameters to the function
          l_stmt.setString(2,new Integer(p_id).toString()); // Hotel ID
          l_stmt.setString(3,l_roomtype); // Room Type
          l_stmt.setString(4,new Integer(p_countryId).toString()); // Local Country ID

          // Specify the OUT parameter type for the Java Stored Function call
          // In this case the out parameter is a float (local room rate)
          l_stmt.registerOutParameter(1,Types.FLOAT);

          l_stmt.execute(); // Execute the callable statement

          //Retrieve the returned local room rate
          float l_localrate = l_stmt.getFloat(1);

          // Insert the retrieved local rate row to the GUI table
          l_tempholder=new Vector();   // Create vector to hold table row elements
          l_tempholder.addElement(l_roomtype);
          if (l_localrate != -1)
            l_tempholder.addElement( (new Float(l_localrate)).toString());
          else
            l_tempholder.addElement("Data Not Available");
          m_GUI.m_op.m_tablemodel.insertRow(l_tempholder);// Add the row to JTable
       }
       l_statement.close(); //Close the statement(also closes the resultset)
     }catch(Exception ex){ //Trap SQL Errors
        m_GUI.putStatus("Error " + ex.toString());
   }

  }

  /**
  *  This method gets all data from the HOTEL RESERVATION FORM and reserves
  *  the room
  *
  *  JSP feature used:
  *     Java stored triggers to update room availability information
  *     when a booking is made.
  **/
  public void reserveRoom(String p_arrDate, String p_name, String p_roomType,
                          int p_numNights, int p_numRooms) {
    try{
       m_GUI.putStatus("Saving room reservation ...");
       java.util.Date l_tempDate = new java.util.Date();  // Current Date

       // The note to be entered for the booking is, booked by and booking date
       String l_bookingNote = p_name + "##"+l_tempDate;

       double l_itnId = 9999999; // The default itenarary ID for the sample

       int l_hotId = m_GUI.getSelectedHotelID();
       // Query the next booking ID from the sequence
       Statement l_stmt = m_connection.createStatement();
       ResultSet l_resultSet = l_stmt.executeQuery(
                                 "select hotel_booking_id.nextval from dual");

       int l_bookingId =0 ;
       // Retrieve the booking ID
       if (l_resultSet.next())
          l_bookingId = l_resultSet.getInt(1); // Holds the value of booking_id
       l_resultSet.close();

       // Query the room rate and currency for the chosen room
       l_resultSet = l_stmt.executeQuery("select standard_rate,currency from "+
                                   "AVAILABLE_ROOM_TYPES where hot_id = "+l_hotId+
                                   "and room_type = '"+p_roomType+"'");


       // Initialize room rate and currency
       int l_roomRate = -1;
       String l_currency = "";

       // Retrieve room rate and currency
       if (l_resultSet.next()) {
         l_roomRate = l_resultSet.getInt(1);
         l_currency = l_resultSet.getString(2);
       }

       l_resultSet.close(); // Close the resultSet
       l_stmt.close(); // Close the Statement object

       // Create a SQL Statement context to insert a record to
       // hotel_bookings table
       PreparedStatement l_pst = m_connection.prepareStatement(
                    "insert into hotel_bookings values (?,?,?,?,?,?,?,?,?,?)");

       // Bind the column values into the PreparedStatement, l_pst
       l_pst.setInt(1,l_bookingId);   // Booking ID
       l_pst.setInt(2,l_hotId); // HOTEL ID
       l_pst.setString(3,p_arrDate); // Arrival Date
       l_pst.setInt(4,p_numNights); // Number of nights
       l_pst.setInt(5,p_numRooms); // Number of rooms
       l_pst.setInt(6,l_roomRate); // Room Rate
       l_pst.setString(7,p_roomType); // Room Type
       l_pst.setString(8,l_currency); // Currency of Room Rate
       l_pst.setDouble(9,l_itnId); // Itenarary ID
       l_pst.setString(10,l_bookingNote); // Booking Note

       l_pst.execute(); // Execute the PreparedStatement
       l_pst.close();   // Close the PreparedStatement object

       m_GUI.m_Pane.clearForm(); // Clear the Room Reservation Form

       m_GUI.putStatus("The Room is reserved for "+p_numNights+" days from "
                       +p_arrDate);
    } catch (Exception ex) { // Trap SQL errors
      m_GUI.putStatus("Error in reserving room... "+ex.toString());
      m_GUI.getReservationForm();
    }
  }

  /**
  *  This method deletes the record from the HOTEL_BOOKINGS table based on
  *  Booking Id
  *
  *  JSP feature used:
  *     Java stored triggers to update room availability information
  *     when a booking is cancelled.
  **/
  public void roomCancellation(int p_bookId) {
    try{
       m_GUI.clearStatus(); // Clear the status field

       // Create a Statement Object to get Booking_id
       PreparedStatement l_pstmt = m_connection.prepareStatement(
                       "Delete from HOTEL_BOOKINGS where booking_id = ?");

       // Bind the column values into the PreparedStatement, l_pstmt
       l_pstmt.setInt(1,p_bookId);

       // Execute the Query and gets the ResultSet
       int l_numb = l_pstmt.executeUpdate();

       m_GUI.putStatus(l_numb +" Room canceled");

       // Close the Statement object
       l_pstmt.close();

    }catch (Exception ex) { // Trap SQL errors
     m_GUI.putStatus("Error in Cancelation.. "+ex.toString());
    }
  }

  /**
  *  This method retrieves all available room types for the selected hotel,
  *  and returns a vector containing all room types.
  *
  *  Supporting function for Room Reservation Functionality.
  **/
  public Vector retrieveRoomTypes(int p_hotId) {
    Vector l_roomType = new Vector();
    try{
       // Create a PreparedStatement Query to select all available room types
       // for the selected hotel
       PreparedStatement l_pst = m_connection.prepareStatement(
                         "select room_type from AVAILABLE_ROOM_TYPES "+
                         "where hot_id = ?");

       l_pst.setInt(1,p_hotId); // Bind hotel ID into SQL query
       ResultSet l_resultSet = l_pst.executeQuery(); // Execute the Query

       // Loop through the resultSet, retrieve room types and add to vector
       while (l_resultSet.next())
          // Retrieve column values for this row
          l_roomType.addElement(l_resultSet.getString(1));

       l_pst.close();  // Close the PreparedStatement object

    } catch (SQLException ex) { // Trap SQL errors
      m_GUI.putStatus("Error in selecting data "+'\n'+ex.toString());
    }
    return l_roomType;
  }
  /**
  * This method displays the booking details of a hotel based on the
  * value of Hotel Id
  *
  *  Supporting function for Room Cancellation Functionality.
  **/
  public void showRoomBookings(int p_hotId) {
    try {
       // Create a PreparedStatement to select room type
       PreparedStatement l_pst = m_connection.prepareStatement(
                    "select booking_id,to_char(arrival_date,'DD-MON-YYYY')"+
                    ",no_of_nights,room_type,"+
                    "booking_notes from hotel_bookings where hot_id = ? and itn_id =?");

       // Bind the column values into the PreparedStatement, l_pst
       l_pst.setInt(1,p_hotId);
       l_pst.setInt(2,9999999);

       // Execute the PreparedStatement
       ResultSet l_resultSet = l_pst.executeQuery();

        // Populating the Result set, retrieve rows
        while (l_resultSet.next()) {  // Point result set to next row
           String l_name="",l_reserveDate="";
           Vector l_tempData = new Vector();
           StringTokenizer l_st = new StringTokenizer(l_resultSet.getString(5),"##");
             while(l_st.hasMoreElements()) {
                 l_name = l_st.nextToken();
                 l_reserveDate = l_st.nextToken();
             }

           // Retrieve room type values for this row and inserts into the Vector
           l_tempData.addElement(l_resultSet.getString(4));
           l_tempData.addElement(new Integer(l_resultSet.getInt(3)));
           l_tempData.addElement(l_resultSet.getString(2));
           l_tempData.addElement(l_name);
           l_tempData.addElement(l_reserveDate);
           l_tempData.addElement(new Integer(l_resultSet.getInt(1)));

           m_GUI.m_cancelDialog.m_tablemodel.insertRow(l_tempData);
        }

       // Close the PreparedStatement
       l_pst.close();
       } catch(SQLException ex){ // Trap SQL Errors
         m_GUI.putStatus("Error in getting the room details "+ex.toString());
       }
  }

  /**
  * This method populates the nationality combo box in ShowLocalRates.java
  * This method is defined here bcos this class holds all the database stuff.
  *
  *
  *  Supporting function for Room Local rate enquiry Functionality.
  **/
  public Vector populateNationality(){
    Vector l_dataholder=new Vector();
    try{

      // Statement Context to execute SQL query
      Statement l_statement=m_connection.createStatement();

      // Retrieve all rows from the hotels table into a ResultSet
      ResultSet l_resultSet=l_statement.executeQuery("select id,name,currency from countries");

      // Loop through the result-set, obtain column values and add to
      // to the vector that is to be returned
      while (l_resultSet.next()){
          int l_id=l_resultSet.getInt(1);
          String l_countryname=l_resultSet.getString(2);
          String l_currency=l_resultSet.getString(3);
          l_countryname+="-";
          l_countryname+=l_id;
          l_countryname+="-";
          l_countryname+=l_currency;
          l_dataholder.addElement(l_countryname);
      }
      l_statement.close(); //Close the statement(also closes the resultset)

    } catch(SQLException ex){ //Trap SQL Errors

    }
    return l_dataholder;
  }

  /**
  * This method retrieves all rows from the HOTELS table and populates the
  * GUI Table with the records.
  *
  * Called to populate the hotel JTable on the main screen
  **/
  public void populateHotels(){
    try{
      m_GUI.putStatus("Loading data to the table. Please Wait...");

      // Statement Context to execute SQL query
      Statement l_statement=m_connection.createStatement();

      // Retrieve all rows from the hotels table into a ResultSet
      ResultSet l_resultSet=l_statement.executeQuery(
        "select hot.id,hot.name,hot.address,city.name from hotels "+
        "hot,cities city where hot.cty_id=city.id and address != 'hotel_city' ");

      // Loop through the result-set, obtain column values and add to
      // GUI JTable
      while (l_resultSet.next())
        m_GUI.addToJTable(l_resultSet.getInt(1),      // Hotel ID
                          l_resultSet.getString(2),   // Hotel Name
                          l_resultSet.getString(3),   // Hotel Address
                          l_resultSet.getString(4));  // City Name


      m_GUI.putStatus("Done retrieving Hotel Records");
      l_statement.close(); //Close the statement(also closes the resultset)

    } catch(SQLException ex){ //Trap SQL Errors
      m_GUI.putStatus(ex.toString());
    }
  }

  /**
  *  Creates a database connection object using JDBC. Please substitute the
  *  database connection parameters with appropriate values in
  *  ConnectionParams.java
  **/
  public void dbConnection(){
    try{
      m_GUI.putStatus("Trying to connect to the Database");

      // Load the Oracle JDBC Driver and register it.
      DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

      // Form the database connect string(TNSNAMES entry) as a name-value pair
      // using the connection parameters as specified in ConnectionParams.java
      String l_dbConnectString =
          "(DESCRIPTION=(ADDRESS=(HOST="+ConnectionParams.s_hostName+")"+
          "(PROTOCOL=tcp)(PORT="+ConnectionParams.s_portNumber+"))"+
          "(CONNECT_DATA=(SID="+ConnectionParams.s_databaseSID+")))";

      // *** The following statement creates a database connection object
      // using the DriverManager.getConnection method. The first parameter is
      // the database URL which is constructed based on the connection parameters
      // specified in ConnectionParams.java.
      // The URL syntax is as follows:
      //      "jdbc:oracle:<driver>:@<db connection string>"
      // <driver>, can be 'thin' or 'oci8'
      // <db connect string>, is a Net8 name-value, denoting the TNSNAMES entry
      m_connection = DriverManager.getConnection(
                  "jdbc:oracle:thin:@"+l_dbConnectString,
                  ConnectionParams.s_userName,
                  ConnectionParams.s_password);

      // sets the auto-commit property for the connection to be false. By default
      // the connections always auto-commit.
      m_connection.setAutoCommit(false);

      m_GUI.putStatus("Connected to "+ConnectionParams.s_databaseSID+
                           " Database as "+ConnectionParams.s_userName);
    } catch(SQLException ex){ //Trap SQL errors
      m_GUI.putStatus(
              "Error in Connecting to the Database "+'\n'+ex.toString());
    }
  }

  /**
  *  This method closes the connection object before exiting this module.
  **/
  public void exitApplication(){
    // Close database connection if it is open
    try{
      if (m_connection != null)
        m_connection.close(); // Close the database connection
    } catch(SQLException ex){ //Trap SQL Errors
      m_GUI.putStatus(ex.toString());
    }
    System.exit(0);   // Exit Application
  }
}
