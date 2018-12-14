CREATE OR REPLACE FUNCTION plch_func
   RETURN NUMBER
IS
BEGIN
   DBMS_OUTPUT.put_line ('plch_func executed');
   RETURN 0;
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (desc_in IN VARCHAR2)
IS
BEGIN
   DBMS_OUTPUT.put_line (desc_in);

   IF plch_func * NULL IS NULL
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   plch_proc ('plch_func*null');
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (desc_in IN VARCHAR2)
IS
BEGIN
   DBMS_OUTPUT.put_line (desc_in);

   IF TRUE OR plch_func = 1
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   plch_proc ('TRUE OR plch_func = 1');
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (desc_in IN VARCHAR2)
IS
BEGIN
   DBMS_OUTPUT.put_line (desc_in);

   IF FALSE AND plch_func = 1
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   plch_proc ('FALSE AND plch_func = 1');
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (desc_in IN VARCHAR2)
IS
   l_value   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line (desc_in);

   IF plch_func * l_value IS NULL
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   plch_proc ('plch_func*l_value-variable');
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (desc_in IN VARCHAR2)
IS
   c_value   CONSTANT NUMBER := NULL;
BEGIN
   DBMS_OUTPUT.put_line (desc_in);

   IF plch_func * c_value IS NULL
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   plch_proc ('plch_func*c_value-constant');
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (desc_in IN VARCHAR2)
IS
   c_boolean   BOOLEAN := TRUE;
BEGIN
   DBMS_OUTPUT.put_line (desc_in);

   IF c_boolean OR plch_func = 1
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   plch_proc ('c_boolean OR plch_func = 1');
END;
/