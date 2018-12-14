/**
 * @author  Reghu
 * @version 1.0
 *
 * Development Environment        :  JDeveloper 2.0
 * Name of the Application        :  JspBodyObjectSample.java
 * Creation/Modification History  :
 *
 * rkrishna.in       15-Mar-1999      Created
 *
 * This sample illustrates access and definition of a Object Type method,
 * which has been implemented as a Java Stored Procedure in the body of the
 * object type.
 *
 * For this sample we use the HOTEL_BODY_OBJECT object type, which has a method
 * get_room_details() that is a Java Stored Procedure. The steps required for
 * creating the HOTEL_BODY_OBJECT object type with the above method, are described
 * in install.txt.
 *
 * The get_room_details() procedure is implemented in Java by the getRoomDetails
 * method in hotel.java.
 *
 * This sample retrieves and displays room availability and rate details for
 * a chosen hotel by calling the get_room_details method of the HOTEL_BODY_OBJECT
 * object type.

 *
 * The GUI for this sample is handled in JspBodyObjectFrame.java
 *
 */

import java.sql.*; // Package for JDBC classes
import oracle.jdbc.driver.*; // Package for Oracle specific data types

import java.util.*;

public class JspBodyObjectSample {
  Connection m_connection;   // Database Connection Object
  JspBodyObjectFrame m_GUI;  // GUI handler for this sample

  String m_roomType;         // String holds the room type
  int m_roomRate,m_numRoom ; // holds room rate and number of available rooms

  /**
  *  Constructor. Instantiates GUI.
  **/
  public JspBodyObjectSample() {
    try {
        m_GUI=new JspBodyObjectFrame(this); // Instantiate GUI
        m_GUI.setVisible(true);
    } catch (Exception e) { // Trap general errors
      m_GUI.putStatus("Error...!!"+ e.toString());
    }
  }

  /**
  *  Main entry point for the class. Instantiates root class and  sets up the
  *  database connection.
  **/
  public static void main(String[] args)throws SQLException{
    // Instantiate application class
    JspBodyObjectSample root = new JspBodyObjectSample();

    root.dbConnection();    // Setup the db connection
    root.populateHotels();  // Populate JTable with Hotel Records

    // Enabling the Buttons
    root.m_GUI.m_baction.setEnabled(true);
  }

  /**
  *  Dispatches the GUI events to the appropriate method, which performs
  *  the required JDBC operations. This method is invoked when event occurs
  *  in the GUI (like table Selection, Button clicks etc.) and is invoked
  *  from the setupListeners section of JspBodyObjectFrame.java
  **/
  public void dispatchEvent(String p_eventName) {
    // Dispatch Event
    if(p_eventName.equals("GET ROOM DETAILS")){
       getRoomDetails(m_GUI.getSelectedHotelID());
       m_GUI.displayRoomInfo();
    }
    if(p_eventName.equals("EXIT"))
       exitApplication();
  }

  /**
  * This method accesses Java Stored Procedure get_Room_Details()
  **/
  public void getRoomDetails(int p_hotId) {
    // Create the PreparedStatement to fetch room types
    // The SQLJ code equivalent to the block below will be:
    //
    // -- First Declare a Iterator to hold all these records
    // #sql iterator RoomIter(String room_type);
    //
    // -- Retrieve all rows into an iterator instance
    // #sql RoomIter = {select room_type from AVAILABLE_ROOM_TYPES
    //                                 where hot_id = :p_hotId };
    // -- Loop through the iterator and process all rows returned
    //   while(RoomIter.next())
    //      Process all room types
    //
    // To Call the JSP to fetch room details JDBC is used in the following block
    // The equivalent SQLJ code will be:
    //
    // #sql {CALL HOTEL_BODY_OBJECT.Get_Room_Details(:in hotId,:in m_roomType,
    //                               :out m_numRoom,:out m_roomRate)};
    //
    try {
       // Create a PreparedStatement to query available room types in the
       // selected room type
       PreparedStatement l_pst = m_connection.prepareStatement(
              "select room_type from AVAILABLE_ROOM_TYPES where hot_id = ?");

       l_pst.setInt(1,p_hotId); // Bind Hotel ID
       ResultSet l_resultSet = l_pst.executeQuery(); // Execute the Query

        // Loop through the result set and retrieve all room types
        while (l_resultSet.next()) {  // Point result set to next row

           String l_roomType = l_resultSet.getString(1); // Retrieve room type

          // Prepare CallableStatement to call the Java Stored Procedure
          // method get_Room_details of HOTEL_BODY_OBJECT object type.
          // This method is called to obtain room availability and rate details
          // for the chosen room type.
          CallableStatement l_cstmt = m_connection.prepareCall(
                   "{CALL HOTEL_BODY_OBJECT.Get_Room_Details(?,?,?,?)}");

          // Bind the IN parameters
          l_cstmt.setInt(1,p_hotId);       // Hotel ID
          l_cstmt.setString(2,l_roomType); // Room Type

          // Specify OUT parameter types.
          l_cstmt.registerOutParameter(3,OracleTypes.NUMBER);
          l_cstmt.registerOutParameter(4,OracleTypes.NUMBER);

          l_cstmt.execute(); // Execute the callable statement

          // Get the values of the return parameters
          int l_numRoom  = l_cstmt.getInt(3); // Number of available rooms
          int l_roomRate = l_cstmt.getInt(4); // Room Rate

          // Insert the row to the JTable in GUI.
          m_GUI.m_Dialog.addToJTable(l_roomType, l_roomRate, l_numRoom);

          m_GUI.clearStatus(); // Clear the status field
          l_cstmt.close(); // Close the CallableStatement
        }
       l_pst.close();  // Close the PreparedStatement
       } catch(SQLException ex){ // Trap SQL Errors
         m_GUI.putStatus("Error in getting the room details "+ex.toString());
       }
  }

  /**
  *  This method retrieves all rows from the HOTELS table and populates the
  *  GUI Table with the records.
  **/
  public void populateHotels() {
    try{
       // Statement Context to execute SQL query
       Statement l_statement = m_connection.createStatement();

       // Retrieve all rows from the hotels table into a ResultSet
       ResultSet l_resultSet = l_statement.executeQuery(
                  "select hot.id,hot.name,hot.address,city.name from hotels "+
                  "hot,cities city where hot.cty_id=city.id and "+
                  "hot.address != 'hotel_city'");

       // Loop through the resultset, obtain column values and add to
       // GUI JTable
       while (l_resultSet.next())
          m_GUI.addToJTable(l_resultSet.getInt(1),    // Hotel ID
                            l_resultSet.getString(2), // Hotel Name
                            l_resultSet.getString(3), // Hotel Address
                            l_resultSet.getString(4));// City Name

       m_GUI.putStatus("Done retrieving Hotel Records");

       l_statement.close(); // Close the statement Object
    } catch(SQLException ex){ // Trap SQL Errors
      m_GUI.putStatus("Error in Populating the Hotel table "+ex.toString());
    }
  }

  /**
  *  Creates a database connection object using JDBC. Please substitute the
  *  database connection parameters with appropriate values in
  *  ConnectionParams.java
  */
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
       // "jdbc:oracle:<driver>:@<db connection string>"
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
      m_GUI.putStatus("Error in Connecting to the Database "+ex.toString());
    }
  }

  /**
  *  This method closes the connection object before exiting the application
  **/
  public void exitApplication(){
    try{
       if(m_connection != null)
          m_connection.close(); // Close the database connection
    } catch(SQLException ex){   // Trap SQL Errors
      m_GUI.putStatus(ex.toString());
    }
    System.exit(0);   // Exit Application
  }
}
