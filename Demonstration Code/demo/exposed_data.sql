CREATE OR REPLACE PROCEDURE show_proc_validity (
   change_in      IN VARCHAR2
 , owner_in       IN VARCHAR2
 , NAME_IN        IN VARCHAR2
 , recompile_in   IN BOOLEAN DEFAULT TRUE)
IS
   l_validity   all_objects.status%TYPE;
BEGIN
   SELECT status
     INTO l_validity
     FROM all_objects
    WHERE     owner = owner_in
          AND object_name = NAME_IN
          AND object_type = 'PROCEDURE';

   DBMS_OUTPUT.put_line ('After "' || change_in || '"');
   DBMS_OUTPUT.put_line (
      '   State of ' || owner_in || '.' || NAME_IN || ' = ' || l_validity);
   DBMS_OUTPUT.put_line ('.');

   IF l_validity = 'INVALID' AND recompile_in
   THEN
      EXECUTE IMMEDIATE
            'alter procedure '
         || owner_in
         || '.'
         || NAME_IN
         || ' COMPILE REUSE SETTINGS';
   END IF;
END show_proc_validity;
/

/*

Value in package specification

*/

CREATE OR REPLACE PACKAGE exposed_value
IS
   g_number   NUMBER := 10;
END;
/

CREATE OR REPLACE PROCEDURE use_exposed_value
IS
BEGIN
   DBMS_OUTPUT.put_line (exposed_value.g_number);
END;
/

BEGIN
   show_proc_validity ('Create', USER, 'USE_EXPOSED_VALUE');
END;
/

CREATE OR REPLACE PACKAGE exposed_value
IS
   g_number   NUMBER := 20;
END;
/

BEGIN
   show_proc_validity ('Change value in package in 11g'
                     , USER
                     , 'USE_EXPOSED_VALUE');
END;
/

CREATE OR REPLACE PACKAGE exposed_value
IS
   g_number   DATE := SYSDATE;
END;
/

BEGIN
   show_proc_validity ('Change type in package in 11g'
                     , USER
                     , 'USE_EXPOSED_VALUE');
END;
/

/* Hide value in pacakge body */

CREATE OR REPLACE PACKAGE exposed_value
IS
   FUNCTION g_number
      RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY exposed_value
IS
   g_number_private   NUMBER := 20;

   FUNCTION g_number
      RETURN NUMBER
   IS
   BEGIN
      RETURN g_number_private;
   END;
END;
/

BEGIN
   show_proc_validity ('Move value to body', USER, 'USE_EXPOSED_VALUE');
END;
/

BEGIN
   show_proc_validity ('After recompilation', USER, 'USE_EXPOSED_VALUE');
END;
/

CREATE OR REPLACE PACKAGE BODY exposed_value
IS
   g_number_private   DATE := SYSDATE;

   FUNCTION g_number
      RETURN NUMBER
   IS
   BEGIN
      RETURN TO_NUMBER (TO_CHAR (g_number_private, 'sssss'));
   END;
END;
/

BEGIN
   show_proc_validity ('Change datatype of variable'
                     , USER
                     , 'USE_EXPOSED_VALUE');
END;
/