DECLARE
   l_date   DATE := DATE '2012-01-01';
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (NEXT_DAY (l_date, 'SUN'), 'DD-D'));
END;
/

DECLARE
   l_date   DATE := DATE '2012-01-01';
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (NEXT_DAY (l_date + 1, 'SUN'), 'DD-D'));
END;
/

/* ORA-01846: not a valid day of the week */

DECLARE
   l_date   DATE := DATE '2012-01-01';
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (NEXT_DAY (l_date, 1), 'DD-D'));
END;
/

DECLARE
   l_date   DATE := DATE '2012-01-01';
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (NEXT_DAY (l_date, 'Sunday'), 'DD-D'));
END;
/

DECLARE
   l_date   DATE := DATE '2012-01-01';
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (NEXT_DAY (l_date, 'SUNDAY'), 'DD-D'));
END;
/