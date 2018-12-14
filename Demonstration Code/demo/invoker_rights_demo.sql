CONNECT hr/hr
SET echo on

CREATE TABLE my_data (VALUE NUMBER)
/

BEGIN
   FOR indx IN 1 .. 10
   LOOP
      INSERT INTO my_data
           VALUES (indx);
   END LOOP;

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE show_my_data
AUTHID CURRENT_USER
IS
   num   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM my_data;

   DBMS_OUTPUT.put_line ('Count of my_data = ' || num);
END show_my_data;
/

GRANT EXECUTE ON show_my_data TO scott
/
CONNECT scott/tiger
SET echo on


CREATE TABLE my_data (VALUE NUMBER)
/

BEGIN
   INSERT INTO my_data
        VALUES (1);

   COMMIT;
END;
/

SET serveroutput on

CALL hr.show_my_data();