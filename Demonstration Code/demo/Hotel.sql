Rem
Rem
Rem Copyright 1999 (c) By Oracle Corporation
Rem
Rem Name  :  all_procs.sql
Rem
Rem Overview :
Rem
Rem This SQL Script creates following Java Stored Procedures/Functions etc
Rem
Rem   Java Stored Procedure/ Function               For the Sample
Rem   ---------------------------------------------------------------
Rem 
Rem  1) GET_LOCAL_RATE                              JavaStoredFunctionSample
Rem  2) GET_ROOM_DETAILS                            JavaStoredProcedureSample &&
Rem                                                 PLSQLCallingJSPSample
Rem  3) GET_BEST_HOTELS                             JSPCallingPLSQLSample
Rem  4) GET_HOTEL_DETAILS                           JSPCallAnonBlockSample
Rem  5) UPDATE_ROOM_DATA                            JSPTriggerSample
Rem
Rem 
Rem Modification / Creation History : 
Rem  
Rem 
Rem
SET SERVEROUTPUT ON
SET ECHO OFF
Rem
Rem  Creating Java Stored Function GET_LOCAL_RATE
Rem 
Rem
Rem
BEGIN
 DBMS_OUTPUT.PUT_LINE('Initialization for Java Stored Function Sample ...');
 DBMS_OUTPUT.PUT_LINE(' ');
 DBMS_OUTPUT.PUT_LINE('Creating Java Stored Function GET_LOCAL_RATE..');
END;
/
Rem
Rem
CREATE OR REPLACE  FUNCTION  GET_LOCAL_RATE (Hotel_ID  IN  VARCHAR2,
ROOM_TYPE IN VARCHAR2,  NATIONALITY_ID IN  VARCHAR2)
RETURN NUMBER AS
LANGUAGE JAVA NAME 'hotel.getLocalRate(java.lang.String,
java.lang.String,java.lang.String) return float';
/
SHOW ERRORS
Rem
Rem
Rem Creating Java Stored Procedure 
Rem
Rem
BEGIN
 DBMS_OUTPUT.PUT_LINE('Initialization for Java Stored Procedure Sample ...');
 DBMS_OUTPUT.PUT_LINE(' ');
 DBMS_OUTPUT.PUT_LINE('Creating Java Stored Procedure GET_ROOM_DETAILS..');
END;
/
Rem
CREATE  OR REPLACE PROCEDURE GET_ROOM_DETAILS( HOTEL_ID  IN VARCHAR2,
ROOM_TYPE  IN  VARCHAR2, NUM_ROOMS_AVAILABLE  OUT NUMBER,
STANDARD_RATE  OUT  NUMBER ) AS
LANGUAGE JAVA NAME 'hotel.getRoomDetails(java.lang.String,
java.lang.String,int[], float[])';
/
SHOW ERRORS
Rem
Rem
Rem
BEGIN
  DBMS_OUTPUT.PUT_LINE('Initialization for JSP Calling PL/SQL Sample ...');
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('Creating Java Stored Procedure GET_BEST_HOTELS..');
END;
/
Rem
Rem Creating Java Stored Procedure which calls the PL/SQL Stored Function
Rem
CREATE  OR  REPLACE  PROCEDURE  GET_BEST_HOTELS ( CITY_NAME  IN  VARCHAR2,
FACILITY_TYPE  IN  VARCHAR2,  ROOM_TYPE  IN  VARCHAR2,
BEST_HOTELS OUT VARCHAR2) AS
LANGUAGE JAVA NAME 'hotel.getBestHotels(java.lang.String,
java.lang.String,java.lang.String, java.lang.String[])';
/
SHOW ERRORS
Rem
Rem
Rem Initialization for Java Call from Anonymous Block
Rem
BEGIN
  DBMS_OUTPUT.PUT_LINE('Initialization for Java Call From Anonymous Block Sample ...');
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('Creating Java Stored Procedure GET_HOTEL_DETAILS..');
END;
/
Rem
Rem
CREATE  OR REPLACE  PROCEDURE  GET_HOTEL_DETAILS ( HOTEL_ID IN VARCHAR2,
HOTEL_NAME  OUT  VARCHAR2,  HOTEL_ADDRESS OUT  VARCHAR2,
HOTEL_CITY  OUT  VARCHAR2,  HOTEL_COUNTRY OUT VARCHAR2,
HOTEL_FACILITIES  OUT  VARCHAR2 ) AS
LANGUAGE JAVA NAME 'hotel.getHotelDetails(java.lang.String,
java.lang.String[],java.lang.String[],java.lang.String[],
java.lang.String[], java.lang.String[])';
/
SHOW ERRORS
Rem
Rem
Rem
Rem Initialization for Java Stored Trigger Sample
Rem
Rem
BEGIN
  DBMS_OUTPUT.PUT_LINE('Initialization for Java Stored Trigger Sample ...');
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('Creating Java Stored Procedure UPDATE_ROOM_DATA..');
END;
/
Rem
Rem
CREATE OR REPLACE PROCEDURE UPDATE_ROOM_DATA
(HOTEL_ID  IN NUMBER, ROOM_TYPE IN VARCHAR2, 
NUM_ROOMS_AVAILABLE  IN NUMBER, 
UPDATEFLAG IN VARCHAR2)
AS
LANGUAGE JAVA NAME 
'hotel.updateAvailableRoomData(int, 
java.lang.String,int, java.lang.String)';
/
SHOW ERRORS
