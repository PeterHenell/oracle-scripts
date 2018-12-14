SET SERVEROUTPUT ON FORMAT WRAPPED SIZE 1000000

DROP TYPE person_t FORCE;

CREATE OR REPLACE TYPE person_t  IS OBJECT 
(  name    VARCHAR2 (100),
   weight  NUMBER,
   dob     DATE);
/

DECLARE
   TYPE rec_tabtype IS TABLE OF employee%ROWTYPE
      INDEX BY BINARY_INTEGER;
	  
   TYPE obj_tabtype IS TABLE OF person_t
      INDEX BY VARCHAR2(100);

   rec_tab rec_tabtype;
   
   obj_tab obj_tabtype;
   
   rectmr tmr_t := tmr_t.make ('By Rec', 10000);
   objtmr tmr_t := tmr_t.make ('By Obj', 10000);
   v_name VARCHAR2(100) := 'Steven';
   
BEGIN
   dbms_session.free_unused_user_memory;
   
   rectmr.go;

   FOR indx IN 1 .. &1
   LOOP
      rec_tab (indx).last_name := v_name;      
      rec_tab (indx).first_name := v_name;      
      rec_tab (indx).salary := 100;      
      v_name := rec_tab (indx).last_name;

   END LOOP;

   rectmr.STOP;
   objtmr.go;
   
   FOR indx IN 1 .. &1
   LOOP
      obj_tab (indx) := person_t ('steven', 165, sysdate);
      v_name := obj_tab (indx).name;
   END LOOP;

   objtmr.STOP;
END;
/
/*
Elapsed time for "By Rec" = 2.51 seconds. Per repetition timing = .000251 seconds.
Elapsed time for "By Obj" = 5.04 seconds. Per repetition timing = .000504 seconds.
*/

