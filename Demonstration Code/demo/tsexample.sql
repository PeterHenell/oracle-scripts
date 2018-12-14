/* Formatted on 2002/02/05 12:17 (Formatter Plus v4.6.0) */
DECLARE
   right_now TIMESTAMP (4) := 
      CURRENT_TIMESTAMP;
   over_there TIMESTAMP (0) 
      WITH TIME ZONE:= 
      CURRENT_TIMESTAMP;	
   right_here TIMESTAMP (2) 
      WITH LOCAL TIME ZONE:= 
      CURRENT_TIMESTAMP;	  
BEGIN
   DBMS_OUTPUT.PUT_LINE (
      SYSTIMESTAMP);
   DBMS_OUTPUT.PUT_LINE (
      CURRENT_TIMESTAMP);
   DBMS_OUTPUT.PUT_LINE (
      right_now);
   DBMS_OUTPUT.PUT_LINE (
      over_there);
   DBMS_OUTPUT.PUT_LINE (
      right_here);	  
END;
