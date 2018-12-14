CREATE OR REPLACE PROCEDURE test_empfetch (counter IN INTEGER)
IS
   timing PLS_INTEGER;
   v_ename emp.ename%TYPE;
   v_empno emp.empno%TYPE;
BEGIN
   timing := DBMS_UTILITY.GET_TIME;
   FOR i IN 1 .. counter
   LOOP
      DECLARE 
         CURSOR cur IS SELECT empno, ename FROM emp;
      BEGIN
         FOR rec IN cur
         LOOP
            v_ename := rec.ename;
            v_empno := rec.empno;
         END LOOP;
      END;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE 
      ('static = ' || TO_CHAR (DBMS_UTILITY.GET_TIME - timing));

   timing := DBMS_UTILITY.GET_TIME;
   FOR i IN 1 .. counter
   LOOP
      empfetch.rows (20);
      FOR i IN 1 .. empfetch.numfetched
      LOOP
         v_ename := empfetch.ename_val (i);
         v_empno := empfetch.empno_val (i);
      END LOOP;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE 
      ('dynamic = ' || TO_CHAR (DBMS_UTILITY.GET_TIME - timing));
END;
/

