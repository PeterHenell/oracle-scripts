BEGIN
   DBMS_OUTPUT.put_line (TRUNC (15.79, 3));
   DBMS_OUTPUT.put_line (TRUNC (15.79, 2));
   DBMS_OUTPUT.put_line (TRUNC (15.79, 1));
   DBMS_OUTPUT.put_line (TRUNC (15.79));
   DBMS_OUTPUT.put_line (TRUNC (15.79, 0));
   DBMS_OUTPUT.put_line (TRUNC (15.79, -1));
   DBMS_OUTPUT.put_line (TRUNC (15.79, -2));
END;
/

DECLARE
   multiplier   INTEGER := 1;
BEGIN
   FOR indx IN 1 .. 5
   LOOP
      DBMS_OUTPUT.put_line (
            'Trunc by '
         || NVL (TO_CHAR (multiplier * indx), 'NULL')
         || ' = '
         || TO_NUMBER (TRUNC (123456.123456, multiplier * indx)));
   END LOOP;
END;
/

DECLARE
   multiplier   INTEGER := -1;
BEGIN
   FOR indx IN 1 .. 5
   LOOP
      DBMS_OUTPUT.put_line (
            'Trunc by '
         || NVL (TO_CHAR (multiplier * indx), 'NULL')
         || ' = '
         || TO_NUMBER (TRUNC (123456.123456, multiplier * indx)));
   END LOOP;
END;
/

DECLARE
   multiplier   INTEGER := NULL;
BEGIN
   FOR indx IN 1 .. 5
   LOOP
      DBMS_OUTPUT.put_line (
            'Trunc by '
         || NVL (TO_CHAR (multiplier * indx), 'NULL')
         || ' = '
         || TO_NUMBER (TRUNC (123456.123456, multiplier * indx)));
   END LOOP;
END;
/


DECLARE
   multiplier   INTEGER := 100;
BEGIN
   FOR indx IN 1 .. 5
   LOOP
      DBMS_OUTPUT.put_line (
            'Trunc by '
         || NVL (TO_CHAR (multiplier * indx), 'NULL')
         || ' = '
         || TO_NUMBER (TRUNC (123456.123456, multiplier * indx)));
   END LOOP;
END;
/