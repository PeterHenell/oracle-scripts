CREATE OR REPLACE FUNCTION SUBSTR (string_in IN VARCHAR2
                                 , start_in  IN PLS_INTEGER
                                 , count_in  IN PLS_INTEGER
                                  )
   RETURN VARCHAR2
IS
BEGIN
   RETURN 'MINE! ' || STANDARD.SUBSTR (string_in, start_in, count_in);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (SUBSTR ('abcdefg', 3, 3));
END;
/

BEGIN
   FOR rec IN (SELECT SUBSTR (last_name, 2, 4) nm
                 FROM employees
                WHERE department_id = 10)
   LOOP
      DBMS_OUTPUT.put_line (rec.nm);
   END LOOP;
END;
/