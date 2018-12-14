DECLARE 
  boss_free TIMESTAMP(0) WITH TIME ZONE; 
  steven_leaves TIMESTAMP(0) WITH TIME ZONE; 
  window INTERVAL DAY(3) TO SECOND(3); 
BEGIN 
  boss_free := TO_TIMESTAMP_TZ ( 
    '29-JAN-2002   12:00:00.0    US/Pacific     PST', 
    'DD-MON-YYYY HH24:MI:SSXFF   TZR            TZD' );
	 
  steven_leaves := TO_TIMESTAMP_TZ ( 
    '29-JAN-2002   16:45:00.0    US/Central     CST', 
    'DD-MON-YYYY HH24:MI:SSXFF   TZR            TZD' );
	 
  window := steven_leaves - boss_free; 
  
  DBMS_OUTPUT.PUT_LINE ( TO_CHAR ( window, 'HH:MI:SSXFF' ) ); 
  DBMS_OUTPUT.PUT_LINE ( window ); 
  
  -- Implicit conversion from Timestamp to Date...
  DBMS_OUTPUT.PUT_LINE ( ADD_MONTHS (boss_free, -5 ) ); 
  
END;
