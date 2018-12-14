CREATE OR REPLACE FUNCTION first_day (date_in IN DATE)
   RETURN DATE
IS
BEGIN
   RETURN TRUNC (date_in, 'MM');
END;
/

CREATE OR REPLACE FUNCTION first_day (date_in IN DATE)
   RETURN DATE
IS
BEGIN
   RETURN TO_DATE (TO_CHAR (date_in, 'YYYY-MM') || '-01', 'YYYY-MM-DD');
END;
/

CREATE OR REPLACE FUNCTION first_day (date_in      IN DATE
                                    , dayname_in   IN VARCHAR2)
   RETURN DATE
IS
BEGIN
   RETURN NEXT_DAY (TRUNC (date_in, 'MONTH'), dayname_in);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (first_sunday (SYSDATE), 'SUNDAY');
END;
/