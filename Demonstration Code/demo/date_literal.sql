ALTER SESSION SET nls_date_format = 'MM-DD-YYYY'
/

BEGIN
   DBMS_OUTPUT.put_line (DATE '12-30-2011');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (DATE '2011-12-30');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (TO_DATE ('12-30-2011'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (DATE '2011-30-12');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      TO_DATE ('2011-30-12', 'YYYY-DD-MM'));
END;
/

DECLARE
   l_my_date   VARCHAR2 (10) := '2011-12-30';
BEGIN
   DBMS_OUTPUT.put_line (DATE l_my_date);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (DATE q'[2011-12-30]');
END;
/