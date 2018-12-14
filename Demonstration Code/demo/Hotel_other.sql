Rem
Rem  Name  other_objects.sql
Rem
Rem  Oracle Corporation CopyRight(c) 1999
Rem
Rem  Overview :
Rem     This PL/SQL Script creates following Database Objects.
Rem
Rem       Database Object               Object Type
Rem    --------------------------------------------
Rem     GET_AVAILABLE_FACILITIES       PL/SQL Stored Function
Rem     FECT_BEST_HOTELS               PL/SQL Stored Procedure
Rem     UPDATE_ROOM_DATA_TRIG          DataBase Trigger
Rem     HOTEL_SPEC_OBJECT              Object Type
Rem     HOTEL_BODY_OBJECT              Object Type
Rem
Rem
Rem  Overview of GET_AVAILABLE_FACILITIES Function :
Rem  -----------------------------------------------
Rem     The function, GET_AVAILABLE_FACILITIES , returns all the facilities types
Rem     available with the given Hotel as a Varchar2 such that the facility types
Rem     are concatenated with '##'. If there is no facility available with the
Rem     given Hotel then this function returns value as 'NO FACILITY'
Rem
Rem     For Example : If Hotel with id '1000' has "MT","AT" and "BT" facilities
Rem     available then after the call
Rem
Rem      SQL> facilities := GET_AVAIBALE_FACILITIES('1000');
Rem
Rem    the value in the variable facilities will be 'MT##AT##BT'
Rem
Rem
Rem  Overview of PL/SQL Stored Procedure FETCH_BEST_HOTELS
Rem  -------------------------------------------------------
Rem  The procedure FETCH_BEST_HOTELS takes following input parameters :
Rem          1) City_Name
Rem          2) Facility_Type
Rem          3) Room_Type
Rem
Rem  The Procedure finds out Best Hotels satisfying given criteria. The criteria
Rem  includes
Rem      a) The Hotel should be present in the given city (City_Name)
Rem      b) The Hotel should have maximum number of Facilities required by the
Rem         user (Facility_Type). Value in Facility_Type variable will be of the
Rem         form "F1##F2##F3" meaning that the user is interested in Facilities
Rem         F1,F2 and F3
Rem      c) The Hotel should have rooms of given Room_Type with minimum Room Rate
Rem
Rem  Depending on the above criteria, this procedure attaches a weight to each Hotel.
Rem  After computing weights for each Hotel, this method sorts the Hotels in ascending
Rem  order of weights.
Rem
Rem  The Method then returns the Best Hotels in a variable BEST_HOTELS.
Rem
Rem  Weights Computation Procedure :
Rem
Rem  Let,
Rem    1) Number of Facilities required by the user = nf
Rem    2) Number Of Facilities hotel h can provide to above user = nr
Rem    3) If the Hotel is equipped with the given ROOM_TYPE then
Rem          Let ra = 1
Rem       Else
Rem          Let ra = 0
Rem    4) Number of Rooms Available of required Room Type = ao
Rem
Rem  Then
Rem    Weight for hotel h =  1 + nr + ra + ao
Rem
Rem  To illustrate the Weights computation procedure, let's take an example.
Rem  Suppose User wants to list Best Hotels in 'Tokyo' with
Rem  Meeting Facilities, Recreation Facilities and Conference Facilities.
Rem  Let User be interested in rooms of "KING" type.
Rem
Rem  The inputs to this procedure then becomes
Rem    CityName = "Tokyo"
Rem    FacilityType = "MT##RF##CF"  ( Note that MT is code for Meeting Facilities and so on )
Rem    RoomType = "KING"
Rem
Rem  Let us assume that Hotel h is equipped with Meeting Facilities and other facilities are not
Rem  available.
Rem
Rem  Then  nf = Total Number Of Facilities required by user = 3
Rem       nr = Number of Facilities hotel h can provide to above user = 1
Rem       ra = 1
Rem       ao = Number Of rooms Available of required Room Type = 5
Rem
Rem  weight for hotel h = 1 + 1 + 1 + 5 = 8
Rem
Rem Creation/Modification History
Rem      ukulkarn              Creation         18-Mar-1999
Rem
Rem
Rem
Rem
SET ECHO OFF
SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('Creating PL/SQL Stored Function GET_AVAILABLE_FACILITIES');
  DBMS_OUTPUT.PUT_LINE(' ');
END;
/
Rem
Rem
Rem
CREATE OR REPLACE FUNCTION GET_AVAILABLE_FACILITIES(HOTEL_ID VARCHAR2)
RETURN VARCHAR2
IS
  -- Declare Cursor to fetch distinct Facility_Types available with
  -- given Hotel
  CURSOR C1(H_ID VARCHAR2) IS SELECT DISTINCT(FACILITY_TYPE)
  FROM HOTEL_FACILITIES
  WHERE HOT_ID = TO_NUMBER(H_ID);
  -- Declare other variables
  FAC_TYPE_NAME  VARCHAR2(50);
  ALL_FACILITIES VARCHAR2(2000);
  NUM_FACILITIES NUMBER := 0;
BEGIN
  -- Open cursor for given Hotel Id
  OPEN c1(HOTEL_ID);
  LOOP
     FETCH c1 INTO FAC_TYPE_NAME;
     EXIT WHEN (c1%NOTFOUND);
     NUM_FACILITIES := NUM_FACILITIES + 1;
     ALL_FACILITIES := FAC_TYPE_NAME || '##' || ALL_FACILITIES;
  END LOOP;
  CLOSE c1;
  IF (NUM_FACILITIES > 0) THEN
     RETURN ALL_FACILITIES;
  ELSE
     RETURN 'NO FACILITY';
  END IF;
END;
/
SHOW ERRORS
Rem
Rem
Rem
Rem
Rem
BEGIN
   DBMS_OUTPUT.PUT_LINE(' ');
   DBMS_OUTPUT.PUT_LINE('Creating PL/SQL Stored Procedure FETCH_BEST_HOTELS');
   DBMS_OUTPUT.PUT_LINE(' ');
END;
/
Rem
Rem DROP TYPE BEST_HOTEL_NAMES;

CREATE TYPE BEST_HOTEL_NAMES AS TABLE OF VARCHAR2(400)
/

Rem  Create a Nested Table Type to hold all the Hotel Id's of Hotels in a given City
Rem  DROP TYPE HOTELID_TYPE;

CREATE TYPE HOTELID_TYPE  AS TABLE OF NUMBER(5)
/

Rem   Create a Nested Table Type to hold all the weights for all Hotels in a given City
Rem   DROP TYPE WEIGHT_TYPE;

CREATE TYPE WEIGHT_TYPE AS TABLE OF NUMBER(10)
/

CREATE OR REPLACE PROCEDURE FETCH_BEST_HOTELS ( CITY_NAME IN  VARCHAR2,
FACILITY_TYPE  IN  VARCHAR2,  ROOM_TYPE  IN  VARCHAR2, BEST_HOTELS OUT BEST_HOTEL_NAMES)
IS
  -- Declare a cursor to find out all the Hotel ID's and Hotel Names in a
  -- given City
  CURSOR c1(CTY_NAME VARCHAR2)  IS  SELECT a.ID, a.NAME
  FROM  HOTELS a, CITIES b
  WHERE  a.CTY_ID = b.ID AND  b.NAME  LIKE  CTY_NAME AND a.ADDRESS != 'hotel_city';

  -- Declare a cursor to find out all the facilities available with a Given Hotel
  CURSOR c2(HOTELID NUMBER) IS SELECT DISTINCT(FACILITY_TYPE)
  FROM HOTEL_FACILITIES WHERE HOT_ID = HOTELID;

  -- Declare variables to hold HotelNames, Hotel Ids, and weights associated with the Hotels
  HOTELNAMES BEST_HOTEL_NAMES := BEST_HOTEL_NAMES(NULL);
  CITYHOTELS   HOTELID_TYPE :=  HOTELID_TYPE(NULL);
  WEIGHTS_CALCULATED WEIGHT_TYPE := WEIGHT_TYPE(NULL);

  -- Declare temporary variables
  TMP_HOTEL_ID    NUMBER(5);
  TMP_HOTEL_NAME  VARCHAR2(80);

  V_FACILITY_TYPE VARCHAR2(10);
  ROOMRATE  NUMBER(10,4);
  WEIGHT  NUMBER(10);
  NUM_OF_ROOMS NUMBER;

  CNT  NUMBER := 1;
  HOTEL_COUNTER NUMBER := 1;
  outerLoop NUMBER;
  cntBestHotels NUMBER := 0;
  RoomType_INFO  VARCHAR2(5);
  tmp_count NUMBER := 0;
  Facilities_Provided VARCHAR2(100);
  First_Record NUMBER := 1;
BEGIN
  BEST_HOTELS := BEST_HOTEL_NAMES(); -- Initialize the output variable to Null array

  -- Fetch all the IDs and Names of the Hotels in given City
  OPEN c1(CITY_NAME);
  LOOP
    FETCH c1 INTO TMP_HOTEL_ID, TMP_HOTEL_NAME;
    EXIT WHEN (c1%NOTFOUND);
    HOTELNAMES.EXTEND(1);
    CITYHOTELS.EXTEND(1);
    HOTELNAMES(CNT) :=  TMP_HOTEL_NAME;
    CITYHOTELS(CNT) := TMP_HOTEL_ID;
    CNT  :=  CNT + 1;
  END LOOP;
  CLOSE c1;
  -- Remove Extra Null Hotel at the End;
  HOTELNAMES.DELETE(HOTELNAMES.COUNT);
  CITYHOTELS.DELETE(CITYHOTELS.COUNT);

  -- Weights Array
  WEIGHTS_CALCULATED.EXTEND(CITYHOTELS.COUNT);

  -- Loop through Each Hotel In The City
  WHILE(HOTEL_COUNTER <= HOTELNAMES.COUNT)
  LOOP
     Facilities_Provided := ' ';
     RoomType_Info := ' ';
     weight := 1; -- Initialize default weight as 1
     -- Fetch all the facilities available with the Hotel
     First_Record := 1;
     OPEN c2(CITYHOTELS(HOTEL_COUNTER));
     LOOP
         FETCH c2 INTO V_FACILITY_TYPE;
         EXIT WHEN(c2%NOTFOUND);
         -- If the available Facility is required by the user then increment the weight
         IF (INSTR(FACILITY_TYPE,V_FACILITY_TYPE,1,1) > 0)
         THEN
           IF (First_Record = 1) THEN
               Facilities_Provided := Facilities_Provided || V_FACILITY_TYPE;
               First_Record := 0;
           ELSE
              Facilities_Provided := Facilities_Provided || ',' ||V_FACILITY_TYPE;
           END IF;
           weight := weight + 1;
         END IF;
     END LOOP;
     CLOSE c2;
     -- Check whether the Hotel has the given Room Type available
     SELECT COUNT(*) INTO tmp_count FROM AVAILABLE_ROOM_TYPES
     WHERE HOT_ID = CITYHOTELS(HOTEL_COUNTER) AND
     AVAILABLE_ROOM_TYPES.ROOM_TYPE = ROOM_TYPE;

     -- If RoomType is Available then increment weight by 1
     IF (tmp_count > 0) THEN
        RoomType_Info := 'Yes';
        WEIGHT := WEIGHT + 1;
     ELSE
        RoomType_Info := 'No';
     END IF;
     -- Call Java Stored Procedure to get Number of Rooms Available.
     -- Note that the Number of Rooms Available is used in weight computation
     -- procedure.
     -- Get the Standard Room rate and Num Of Rooms Available for the Room Type
     GET_ROOM_DETAILS(CITYHOTELS(HOTEL_COUNTER),ROOM_TYPE,NUM_OF_ROOMS,ROOMRATE);
     -- Increment the weight
     WEIGHTS_CALCULATED(HOTEL_COUNTER) := WEIGHT + NVL(NUM_OF_ROOMS,0);

     -- Concatenate HOTEL NAME with the Facilities provided and Room Type Info
     HOTELNAMES(HOTEL_COUNTER) := HOTELNAMES(HOTEL_COUNTER) || '#' ||
                                  Facilities_Provided || '#' || RoomType_Info;
     HOTEL_COUNTER := HOTEL_COUNTER + 1;
  END LOOP;
  WEIGHTS_CALCULATED.DELETE(WEIGHTS_CALCULATED.COUNT);

  -- Sort the Weights Array to Find Best Hotels
  -- Using Bubble Sort Algorithm
  outerLoop := HOTELNAMES.COUNT - 1;
  FOR i IN 1..outerLoop  LOOP
    FOR j IN i+1..HOTELNAMES.COUNT LOOP
      IF(WEIGHTS_CALCULATED(j) > WEIGHTS_CALCULATED(i))
      THEN
         WEIGHT := WEIGHTS_CALCULATED(j);
         TMP_HOTEL_NAME := HOTELNAMES(j);
         WEIGHTS_CALCULATED(j) := WEIGHTS_CALCULATED(i);
         HOTELNAMES(j) := HOTELNAMES(i);
         WEIGHTS_CALCULATED(i) := WEIGHT;
         HOTELNAMES(i) := TMP_HOTEL_NAME;
      END IF;
    END LOOP;
  END LOOP;

  -- Construct BEST_HOTELS Array
  FOR i IN 1..HOTELNAMES.COUNT LOOP
    IF ( WEIGHTS_CALCULATED(i) > 0) THEN
      BEST_HOTELS.EXTEND(1);
      cntBESTHOTELS := cntBESTHOTELS + 1;
      BEST_HOTELS(cntBESTHOTELS) := HOTELNAMES(i);
    END IF;
  END LOOP;
END;
/
SHOW ERRORS
Rem
Rem
Rem
Rem The SQL Statements below creates a Java Stored Trigger "UPDATE_ROOM_DATA_TRIG". The trigger
Rem gets fired after any insert on HOTEL_BOOKINGS table. This trigger is made use of in the Sample
Rem JSPTriggerSample.
Rem
Rem This Script also creates two object types "HOTEL_BODY_OBJECT" and "HOTEL_SPEC_OBJECT".
Rem
Rem HOTEL_SPEC_OBJECT defines a Java Method in the Specification of the Object Type.
Rem
Rem HOTEL_BODY_OBJECT defines a Java Method in the Body of the Object Type.
Rem
Rem Any Oracle Object Type has basically two distinct parts. a)Object Specification
Rem b) Object Body
Rem
Rem a) Object Specification : The attributes and the member method signatures are defined here.
Rem    You can define a Java Method as the implementation of the member method in the
Rem    Object Specification itself. HOTEL_SPEC_OBJECT illustrates this concept.
Rem
Rem b) Object Body : The implementation of the Member Methods can be defined here if not defined
Rem    in the Specification. You can associate a Java Method to be the implementation of the Member
Rem    Method. HOTEL_BODY_OBJECT illustrates this concept.
Rem
Rem
Rem
BEGIN
  DBMS_OUTPUT.PUT_LINE('Creating Trigger UPDATE_ROOM_DATA_TRIG...');
  DBMS_OUTPUT.PUT_LINE(' ');
END;
/
Rem
Rem
CREATE OR REPLACE TRIGGER UPDATE_ROOM_DATA_TRIG
AFTER INSERT ON HOTEL_BOOKINGS
FOR EACH ROW
call UPDATE_ROOM_DATA(:new.HOT_ID, :new.ROOM_TYPE,
:new.NO_OF_ROOMS,'CIN')
/
SHOW ERRORS
Rem
Rem
Rem
Rem Insert a Sample row into inineraries table.
Rem
DECLARE
  rowCnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO rowCnt FROM ITINERARIES WHERE id = 9999999;
  IF (rowCnt = 0) THEN
         INSERT INTO ITINERARIES values(9999999, 10, 1, SYSDATE, 5, SYSDATE,
         SYSDATE, 'D', 'Not Avaulable', 'NA','NA', 1,2,3,4,5,10.5,10.5,10.5,
         10.5,'Not Fully Available', 10.30, 20.30);
         COMMIT;
         DBMS_OUTPUT.PUT_LINE('Inserted a Sample Row into ITINERARIES Table');
  END IF;
END;
/
Rem
Rem
Rem
Rem Initialization for Java Method in Specification of the Object
Rem
BEGIN
  DBMS_OUTPUT.PUT_LINE('Initialization for Java Method in Specification of the Object Sample...');
  DBMS_OUTPUT.PUT_LINE(' ');
END;
/
Rem
Rem
Rem DROP TYPE HOTEL_SPEC_OBJECT
Rem /
Rem
Rem
CREATE TYPE HOTEL_SPEC_OBJECT  AS  OBJECT  (
             Hotel_Id    NUMBER(5),
             Hotel_Name  VARCHAR2(80),
             Hotel_Address VARCHAR2(200),

             STATIC PROCEDURE GET_HOTEL_DETAILS(HOT_ID IN VARCHAR2, HOTEL_NAME OUT VARCHAR2,
             HOTEL_ADDRESS OUT VARCHAR2, HOTEL_CITY OUT VARCHAR2, HOTEL_COUNTRY OUT VARCHAR2,
             HOTEL_FACILITIES OUT VARCHAR2) AS
             LANGUAGE JAVA NAME
             'hotel.getHotelDetails(java.lang.String, java.lang.String[], java.lang.String[],
             java.lang.String[],java.lang.String[], java.lang.String[])'
)
/
SHOW ERRORS
Rem
Rem
Rem Initialization for Java Method in Body of the Object
Rem
BEGIN
  DBMS_OUTPUT.PUT_LINE('Initialization for Java Method in Body of the Object Sample...');
  DBMS_OUTPUT.PUT_LINE(' ');
end;
/
Rem
Rem
Rem DROP TYPE HOTEL_BODY_OBJECT
Rem /
Rem
Rem Define the specification of the Object
Rem
CREATE TYPE HOTEL_BODY_OBJECT  AS  OBJECT  (
                Hotel_Id    NUMBER(5),
                Hotel_Name  VARCHAR2(80),
                Hotel_Address VARCHAR2(200),

                STATIC PROCEDURE GET_ROOM_DETAILS(HOTEL_ID IN VARCHAR2,
                ROOM_TYPE IN VARCHAR2, NUM_ROOMS_AVAILABLE OUT NUMBER,
                STANDARD_RATE OUT NUMBER)

)
/
Rem
Rem Define the Body of the Object
Rem
CREATE TYPE BODY HOTEL_BODY_OBJECT AS
                 STATIC PROCEDURE GET_ROOM_DETAILS(HOTEL_ID IN VARCHAR2,
                 ROOM_TYPE IN VARCHAR2,NUM_ROOMS_AVAILABLE OUT NUMBER,
                 STANDARD_RATE OUT NUMBER) AS LANGUAGE JAVA NAME
                 'hotel.getRoomDetails(java.lang.String, java.lang.String, int[], float[])';
END;
/
SHOW ERRORS
Rem
Rem
