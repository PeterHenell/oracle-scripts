CREATE OR REPLACE PROCEDURE time_arrayupd (counter IN INTEGER)
IS
   tim PLS_INTEGER;
BEGIN
   tim := DBMS_UTILITY.GET_TIME;
   FOR i IN 1 .. counter
   LOOP
      UPDATE emp SET sal = 16000 WHERE empno = 7499;
      UPDATE emp SET sal = 12500 WHERE empno = 7521;
      ROLLBACK;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE 
      ('static = ' || TO_CHAR (DBMS_UTILITY.GET_TIME - tim));

   tim := DBMS_UTILITY.GET_TIME;
   FOR i IN 1 .. counter
   LOOP
      DECLARE
         emps DBMS_SQL.NUMBER_TABLE;
         sals DBMS_SQL.NUMBER_TABLE;
      BEGIN
         emps (1) := 7499;
         sals (1) := 16000;
         emps (2) := 7521;
         sals (2) := 12500;
         arrayupd.col ('emp', 'empno', 'sal', emps, sals);
      END;
      ROLLBACK;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE 
      ('very dynamic = ' || TO_CHAR (DBMS_UTILITY.GET_TIME - tim));
END;
/
