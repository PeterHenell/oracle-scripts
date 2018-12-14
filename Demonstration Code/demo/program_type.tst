CREATE OR REPLACE PACKAGE my_package
IS
   FUNCTION program1 (p_in IN NUMBER)
      RETURN NUMBER;

   PROCEDURE program1 (p_in IN NUMBER);

   PROCEDURE program2;

   FUNCTION program3
      RETURN DATE;
END;
/

CREATE OR REPLACE FUNCTION my_function
   RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END my_function;
/

CREATE OR REPLACE PROCEDURE my_procedure
IS
BEGIN
   NULL;
END my_procedure;
/

DECLARE
   l_success   BOOLEAN DEFAULT TRUE;
BEGIN
   IF program_type (USER, 'MY_PACKAGE', 'PROGRAM1') !=
                                                      'FUNCTION,PROCEDURE'
   THEN
      DBMS_OUTPUT.put_line
         ('Failure identifying overloaded function/procedure combination.');
      l_success := FALSE;
   END IF;

   IF program_type (USER, 'MY_PACKAGE', 'PROGRAM2') != 'PROCEDURE'
   THEN
      DBMS_OUTPUT.put_line
              ('Failure identifying packaged procedure without arguments.');
      l_success := FALSE;
   END IF;

   IF program_type (USER, 'MY_PACKAGE', 'PROGRAM3') != 'FUNCTION'
   THEN
      DBMS_OUTPUT.put_line
               ('Failure identifying packaged function without arguments.');
      l_success := FALSE;
   END IF;

   IF program_type (USER, NULL, 'MY_PROCEDURE') != 'PROCEDURE'
   THEN
      DBMS_OUTPUT.put_line ('Failure identifying stand-alone procedure.');
      l_success := FALSE;
   END IF;

   IF program_type (USER, NULL, 'MY_FUNCTION') != 'FUNCTION'
   THEN
      DBMS_OUTPUT.put_line ('Failure identifying stand-alone procedure.');
      l_success := FALSE;
   END IF;

   IF l_success
   THEN
      DBMS_OUTPUT.put_line ('Success: PROGRAM_TYPE utility');
   END IF;
END;
/