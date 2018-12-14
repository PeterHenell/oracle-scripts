/* A solution that maintains uniqueness down to the second. */
DECLARE
   dateinfo PLVtab.vc30_table;
   v_row INTEGER;
   v_now DATE := SYSDATE; /* Utrecht */
   datemask VARCHAR2(30) := 'JSSSSS';
   lowlim INTEGER := 
      TO_CHAR (TO_DATE ('01-01-1950', 'DD-MM-YYYY'), 'J');

   /* Date to Number */
   PROCEDURE setrow (dt IN DATE, val IN VARCHAR2) 
   IS
      v_row INTEGER;
   BEGIN
      v_row := 
         TO_NUMBER (
         TO_CHAR (TO_NUMBER (TO_CHAR (dt, 'J')) - lowlim) ||
         TO_CHAR (dt, 'SSSSS')
         );
      dateinfo (v_row) := val;
   END;

   /* Number to Date */
   FUNCTION dateforrow (rw IN INTEGER) RETURN DATE 
   IS
      dt PLV.identifier;
      tm PLV.identifier;
      loc PLS_INTEGER;
      v_rw PLV.identifier := TO_CHAR (rw);
   BEGIN
      loc := LENGTH (v_rw) - 5;
      dt := SUBSTR (v_rw, 1, loc);
      tm := SUBSTR (v_rw, loc+1);
      RETURN TO_DATE (
         TO_CHAR (TO_NUMBER(dt) + lowlim) || tm, 
         datemask);
   END;
BEGIN
   setrow (v_now + 10/1440, 'Hire date');
   setrow (v_now+22-200/1440, 'First review');
   setrow (v_now+22 + 1/24, 'Celebration Dinner');
   setrow (v_now-155 - 35/1440, 'Application received');

   v_row := dateinfo.FIRST;
   LOOP
      EXIT WHEN v_row IS NULL;
      p.l (dateinfo(v_row), dateforrow (v_row));
      v_row := dateinfo.NEXT (v_row);
   END LOOP;
END;
/

