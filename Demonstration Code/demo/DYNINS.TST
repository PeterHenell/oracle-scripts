ROLLBACK;
ALTER TABLE emp MODIFY empno NUMBER (10);

CREATE OR REPLACE PROCEDURE dynins (
   vers IN INTEGER, counter IN INTEGER)
/*
|| Create instab7 and instab8 from instab.sp
*/
IS
   empnos7 mytables.number_table;
   enames7 mytables.varchar2_table;

   empnos8 DBMS_SQL.NUMBER_TABLE;
   enames8 DBMS_SQL.VARCHAR2_TABLE;
BEGIN
   /* Load up the PL/SQL tables. */
   FOR i IN 1 .. counter
   LOOP
      IF vers = 7
      THEN
         empnos7(i) := 10000 + i;
         enames7(i) := 'Eli ' || TO_CHAR (i);
      ELSIF vers = 8
      THEN
         empnos8(i) := 10000 + i;
         enames8(i) := 'Eli ' || TO_CHAR (i);
      END IF;
   END LOOP;

   IF vers = 7
   THEN
      sf_timer.start_timer;
      instab7 (empnos7, enames7);
      sf_timer.show_elapsed_time ('V7 style');
   ELSIF vers = 8 
   THEN
      sf_timer.start_timer;
      instab8 (empnos8, enames8);
      sf_timer.show_elapsed_time ('V8 style');
   END IF;
END;
/

