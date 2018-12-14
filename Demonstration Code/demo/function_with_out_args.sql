/* Simple string utility */

CREATE OR REPLACE FUNCTION betwnstr (string_in   IN VARCHAR2
                                   , start_in    IN INTEGER
                                   , end_in      IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN SUBSTR (string_in, start_in, end_in - start_in + 1);
END betwnstr;
/

BEGIN
   IF betwnstr ('abcdef', 1, 3) = 'abc'
   THEN
      DBMS_OUTPUT.put_line ('Function returns value through RETURN only');
   END IF;
END;
/

/* Call it in SQL */

SELECT betwnstr (last_name, 3, 5) FROM employees
/

/* Using function to return status code. 
   Generally a bad idea, at least in PL/SQL.
*/

CREATE OR REPLACE FUNCTION betwnstr (string_in      IN     VARCHAR2
                                   , start_in       IN     INTEGER
                                   , end_in         IN     INTEGER
                                   , betwnstr_out      OUT VARCHAR2)
   RETURN INTEGER
IS
BEGIN
   betwnstr_out := SUBSTR (string_in, start_in, end_in - start_in + 1);
   RETURN 0;
EXCEPTION
   WHEN OTHERS
   THEN
      log_error ();
      RETURN SQLCODE;
END betwnstr;
/

DECLARE
   l_string   VARCHAR2 (100);
BEGIN
   IF betwnstr ('abcdef'
              , 1
              , 3
              , l_string) = 0
   THEN
      DBMS_OUTPUT.put_line ('Function returns status through RETURN');
   END IF;
END;
/

/* Cannot it in SQL 
   
   ORA-06572: Function BETWNSTR has out arguments
   
*/

DECLARE
   l_string   VARCHAR2 (100);
BEGIN
   FOR rec IN (SELECT betwnstr (last_name
                              , 5
                              , 3
                              , l_string)
                         namepart
                 FROM employees)
   LOOP
      DBMS_OUTPUT.put_line (rec.namepart);
   END LOOP;
END;
/