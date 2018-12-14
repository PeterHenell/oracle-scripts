CREATE OR REPLACE FUNCTION first_tuesday_in_month (year_in    IN INTEGER
                                                 , month_in   IN INTEGER)
   RETURN DATE
IS
BEGIN
   RETURN NEXT_DAY (TO_date (month_in || '-01-' || year_in, 'MM-DD-YYYY') - 1
                  , 'TUESDAY');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (first_tuesday_in_month (2010, 9));
   DBMS_OUTPUT.put_line (first_tuesday_in_month (2010, 10));
END;
/
