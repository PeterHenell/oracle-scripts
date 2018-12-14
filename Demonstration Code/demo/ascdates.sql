DECLARE
   dateinfo PLVtab.vc30_table;
   v_row INTEGER;
   v_now DATE := SYSDATE; /* Utrecht suggestion for improvement */
   datemask VARCHAR2(30) := 'J'; -- 'YYYYMMDDHH24MISS';

   /* Date to Number */
   PROCEDURE setrow (dt IN DATE, val IN VARCHAR2) IS
   BEGIN
      dateinfo (TO_NUMBER (TO_CHAR (dt, datemask))) := val;
   END;

   /* Number to Date */
   FUNCTION dateforrow (rw IN INTEGER) RETURN DATE IS
   BEGIN
      RETURN TO_DATE (TO_CHAR (rw), datemask);
   END;
BEGIN
   setrow (v_now, 'Hire date');
   setrow (v_now+22, 'First review');
   setrow (v_now-155, 'Application received');

   v_row := dateinfo.FIRST;
   LOOP
      EXIT WHEN v_row IS NULL;
      p.l (dateinfo(v_row), dateforrow (v_row));
      v_row := dateinfo.NEXT (v_row);
   END LOOP;
END;
/

