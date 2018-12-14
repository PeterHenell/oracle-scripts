CREATE OR REPLACE FUNCTION plch_converted_value (value_in IN NUMBER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE value_in
             WHEN 1 THEN 'All Alone'
             WHEN 2 THEN 'You and Me'
             WHEN 3 THEN 'A Party!'
             WHEN NULL THEN 'Dreamland'
          END;
END plch_converted_value;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_converted_value (1));
   DBMS_OUTPUT.put_line (plch_converted_value (2));
   DBMS_OUTPUT.put_line (plch_converted_value (3));
   DBMS_OUTPUT.put_line (plch_converted_value (NULL));
END;
/

CREATE OR REPLACE FUNCTION plch_converted_value (value_in IN NUMBER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE value_in
             WHEN 1 THEN 'All Alone'
             WHEN 2 THEN 'You and Me'
             WHEN 3 THEN 'A Party!'
             WHEN IS NULL THEN 'Dreamland'
          END;
END plch_converted_value;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_converted_value (1));
   DBMS_OUTPUT.put_line (plch_converted_value (2));
   DBMS_OUTPUT.put_line (plch_converted_value (3));
   DBMS_OUTPUT.put_line (plch_converted_value (NULL));
END;
/

CREATE OR REPLACE FUNCTION plch_converted_value (value_in IN NUMBER)
   RETURN VARCHAR2
IS
BEGIN
   IF value_in IS NULL
   THEN
      RETURN 'Dreamland';
   ELSE
      RETURN CASE value_in
                WHEN 1 THEN 'All Alone'
                WHEN 2 THEN 'You and Me'
                WHEN 3 THEN 'A Party!'
             END;
   END IF;
END plch_converted_value;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_converted_value (1));
   DBMS_OUTPUT.put_line (plch_converted_value (2));
   DBMS_OUTPUT.put_line (plch_converted_value (3));
   DBMS_OUTPUT.put_line (plch_converted_value (NULL));
END;
/

CREATE OR REPLACE FUNCTION plch_converted_value (value_in IN NUMBER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE 
             WHEN value_in = 1 THEN 'All Alone'
             WHEN value_in = 2 THEN 'You and Me'
             WHEN value_in = 3 THEN 'A Party!'
             WHEN value_in IS NULL THEN 'Dreamland'
          END;
END plch_converted_value;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_converted_value (1));
   DBMS_OUTPUT.put_line (plch_converted_value (2));
   DBMS_OUTPUT.put_line (plch_converted_value (3));
   DBMS_OUTPUT.put_line (plch_converted_value (NULL));
END;
/