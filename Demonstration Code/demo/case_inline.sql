CREATE OR REPLACE FUNCTION days_in_period_str (period_in   IN VARCHAR2
                                             , days_in     IN PLS_INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   /*
   1. If days_in is 1, then use singular, else use plural for period
   (add an "s" to "day" in output).

   2. If days_in is NULL, then display "No days in <period_in>".
   */
   RETURN CASE
             WHEN days_in IS NULL THEN 'No'
             WHEN days_in = 1 THEN 'One'
             ELSE TO_CHAR (days_in)
          END
          || ' '
          || CASE days_in WHEN 1 THEN 'day' ELSE 'days' END
          || ' in '
          || period_in;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (days_in_period_str ('Month', 1));
   DBMS_OUTPUT.put_line (days_in_period_str ('Month', 2));
   DBMS_OUTPUT.put_line (days_in_period_str ('Month', NULL));
END;
/