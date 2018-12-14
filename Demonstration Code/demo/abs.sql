CREATE OR REPLACE FUNCTION plch_absolute_value (n IN NUMBER)
   RETURN NUMBER
IS
BEGIN
   IF n <= 0
   THEN
      RETURN n * -1;
   ELSE
      RETURN n;
   END IF;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_absolute_value (-1000));
   DBMS_OUTPUT.put_line (plch_absolute_value (0));
   DBMS_OUTPUT.put_line (plch_absolute_value (1000));
END;
/

CREATE OR REPLACE FUNCTION plch_absolute_value (n IN NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN absolute_value (n);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_absolute_value (-1000));
   DBMS_OUTPUT.put_line (plch_absolute_value (0));
   DBMS_OUTPUT.put_line (plch_absolute_value (1000));
END;
/

CREATE OR REPLACE FUNCTION plch_absolute_value (n IN NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN ABS (n);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_absolute_value (-1000));
   DBMS_OUTPUT.put_line (plch_absolute_value (0));
   DBMS_OUTPUT.put_line (plch_absolute_value (1000));
END;
/

CREATE OR REPLACE FUNCTION plch_absolute_value (n IN NUMBER)
   RETURN NUMBER
IS
BEGIN
   SELECT ABS (n) INTO l_return FROM DUAL;

   RETURN l_return;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_absolute_value (-1000));
   DBMS_OUTPUT.put_line (plch_absolute_value (0));
   DBMS_OUTPUT.put_line (plch_absolute_value (1000));
END;
/