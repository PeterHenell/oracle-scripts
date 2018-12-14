DECLARE
/* Written by Jonas Nordstrom, jonasn@bigfoot.com,
   an avid PL/SQL Pipeliner */
   v_old_date DATE;
   v_curr_date DATE := SYSDATE;
   v_stop BOOLEAN := FALSE;
   v_offset PLS_INTEGER := 36500; -- approx. 100 yrs
BEGIN
   WHILE NOT v_stop LOOP
      BEGIN
         v_old_date := v_curr_date;
         v_curr_date := v_curr_date + v_offset;
      EXCEPTION
         WHEN OTHERS THEN
            IF v_offset = 1 THEN
               v_stop := true;
            END IF;
            v_offset := CEIL(v_offset / 2);
            v_curr_date := v_old_date;
      END;
   END LOOP;
   dbms_output.put_line('Last date: '||to_char(v_curr_date, 'YYYY-MM-DD'));
END;
/
