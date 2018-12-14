/* With recursion, provided by candhu */

CREATE OR REPLACE FUNCTION proximate_weekday (
   date_in        IN DATE
 , direction_in   IN SIGNTYPE DEFAULT 1)
   RETURN DATE
IS
   TYPE days_tt IS TABLE OF NUMBER
                      INDEX BY VARCHAR2 (3);

   w_end                   days_tt;
   c_day          CONSTANT DATE := date_in + direction_in;
   c_day_abbrev   CONSTANT VARCHAR2 (3)
      := TO_CHAR (c_day, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') ;
   l_return                DATE;
BEGIN
   w_end ('SAT') := 1;
   w_end ('SUN') := 1;

   IF w_end.EXISTS (c_day_abbrev)
   THEN
      RETURN proximate_weekday (c_day, direction_in);
   ELSE
      RETURN c_day;
   END IF;
END proximate_weekday;
/


/* Original brute force */

CREATE OR REPLACE FUNCTION proximate_weekday (
   date_in        IN DATE
 , direction_in   IN signtype DEFAULT 1)
   RETURN DATE
IS
   c_before_weekend   CONSTANT VARCHAR2 (3) := 'FRI';
   c_weekend_one      CONSTANT VARCHAR2 (3) := 'SAT';
   c_weekend_two      CONSTANT VARCHAR2 (3) := 'SUN';
   c_after_weekend    CONSTANT VARCHAR2 (3) := 'MON';
   c_day_abbrev       CONSTANT VARCHAR2 (3)
      := TO_CHAR (date_in, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') ;
   l_return                    DATE;
BEGIN
   CASE
      WHEN    c_day_abbrev IN ('TUE', 'WED', 'THU')
           OR (c_day_abbrev = c_after_weekend AND direction_in = 1)
           OR (c_day_abbrev = c_before_weekend AND direction_in = -1)
      THEN
         l_return := date_in + direction_in;
      WHEN (c_day_abbrev = c_before_weekend AND direction_in = 1)
           OR (c_day_abbrev = c_after_weekend AND direction_in = -1)
      THEN
         l_return := date_in + (direction_in * 3);
      WHEN (c_day_abbrev = c_weekend_one AND direction_in = 1)
           OR (c_day_abbrev = c_weekend_two AND direction_in = -1)
      THEN
         l_return := date_in + (direction_in * 2);
      WHEN (c_day_abbrev = c_weekend_two AND direction_in = 1)
           OR (c_day_abbrev = c_weekend_one AND direction_in = -1)
      THEN
         l_return := date_in + (direction_in * 1);
   END CASE;

   RETURN l_return;
END proximate_weekday;
/

DECLARE
   /* Start with a Monday */
   l_date   DATE := DATE '2010-11-01';

   PROCEDURE show_dates_around (date_in IN DATE)
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Day is ' || TO_CHAR (date_in, 'Day'));
      DBMS_OUTPUT.
       put_line (
         'One day before is '
         || TO_CHAR (proximate_weekday (date_in, -1), 'Day'));
      DBMS_OUTPUT.
       put_line (
         'One day after is ' || TO_CHAR (proximate_weekday (date_in, 1), 'Day'));
   END;
BEGIN
   FOR indx IN 1 .. 7
   LOOP
      show_dates_around (l_date + indx - 1);
   END LOOP;
END;
/