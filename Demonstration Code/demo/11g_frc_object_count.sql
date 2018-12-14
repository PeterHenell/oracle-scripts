CREATE OR REPLACE FUNCTION object_count
   RETURN PLS_INTEGER
   RESULT_CACHE
IS
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM all_objects
    WHERE owner = USER;

   RETURN l_count;
END object_count;
/

GRANT EXECUTE ON object_count TO PUBLIC
/

BEGIN
   DBMS_OUTPUT.put_line (object_count);
END;
/

CREATE OR REPLACE FUNCTION object_count
   RETURN PLS_INTEGER
   RESULT_CACHE RELIES_ON (all_objects)
IS
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM all_objects
    WHERE owner = USER;

   RETURN l_count;
END object_count;
/

BEGIN
   DBMS_OUTPUT.put_line ('HR-object count');

   DBMS_OUTPUT.put_line (object_count);
END;
/

CONNECT scott/tiger

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line ('Scott-object count');

   DBMS_OUTPUT.put_line (hr.object_count);
END;
/

CREATE OR REPLACE PROCEDURE new_object
IS
BEGIN
   NULL;
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Scott - after creating new object');
   DBMS_OUTPUT.put_line (hr.object_count);
END;
/

CONNECT hr/hr

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION object_count
   RETURN PLS_INTEGER
   RESULT_CACHE RELIES_ON (all_objects)
IS
   l_counter   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_counter
     FROM all_objects
    WHERE owner = USER;

   RETURN l_counter;
END object_count;
/

CONNECT scott/tiger

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line ('Scott-after recompilation in HR');

   DBMS_OUTPUT.put_line (hr.object_count);
END;
/

CONNECT hr/hr

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION object_count (user_in IN VARCHAR2 DEFAULT USER)
   RETURN PLS_INTEGER
   RESULT_CACHE
IS
   l_counter   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_counter
     FROM all_objects
    WHERE owner = USER;

   RETURN l_counter;
END object_count;
/

CONNECT scott/tiger

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line ('Scott-with user_in argument');

   DBMS_OUTPUT.put_line (hr.object_count);
END;
/