  SELECT *
    FROM nls_session_parameters
ORDER BY parameter
/

ALTER SESSION SET nls_numeric_characters='.,'
/

ALTER SESSION SET nls_numeric_characters=',.'
/

BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (100000.898));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (100000.898, '999,999.999'));
END;
/