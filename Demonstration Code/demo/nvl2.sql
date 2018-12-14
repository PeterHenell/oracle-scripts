CREATE OR REPLACE PROCEDURE show_vals (val1_in   IN NUMBER
                                     , val2_in   IN NUMBER
                                     , val3_in   IN NUMBER)
IS
BEGIN
   DBMS_OUTPUT.put_line ('if val1 is null');

   IF val1_in IS NULL
   THEN
      DBMS_OUTPUT.put_line (val2_in);
   ELSE
      DBMS_OUTPUT.put_line (val3_in);
   END IF;
END show_vals;
/

BEGIN
   show_vals (1, -1, 1);
   show_vals (NULL, -1, 1);
END;
/

CREATE OR REPLACE PROCEDURE show_vals (val1_in   IN NUMBER
                                     , val2_in   IN NUMBER
                                     , val3_in   IN NUMBER)
IS
BEGIN
   IF val1_in IS NOT NULL
   THEN
      DBMS_OUTPUT.put_line (val2_in);
   ELSE
      DBMS_OUTPUT.put_line (val3_in);
   END IF;
END show_vals;
/

BEGIN
   DBMS_OUTPUT.put_line ('if val1 is not null');
   show_vals (1, -1, 1);
   show_vals (NULL, -1, 1);
END;
/

CREATE OR REPLACE PROCEDURE show_vals (val1_in   IN NUMBER
                                     , val2_in   IN NUMBER
                                     , val3_in   IN NUMBER)
IS
BEGIN
   DBMS_OUTPUT.put_line (NVL2 (val1_in, val2_in, val3_in));
END show_vals;
/

BEGIN
   DBMS_OUTPUT.put_line ('nvl2');
   show_vals (1, -1, 1);
   show_vals (NULL, -1, 1);
END;
/

CREATE OR REPLACE PROCEDURE show_vals (val1_in   IN NUMBER
                                     , val2_in   IN NUMBER
                                     , val3_in   IN NUMBER)
IS
   l_value   NUMBER;
BEGIN
   SELECT NVL2 (val1_in, val2_in, val3_in) INTO l_value FROM sys.DUAL;

   DBMS_OUTPUT.put_line (l_value);
END show_vals;
/

BEGIN
   DBMS_OUTPUT.put_line ('nvl2 in sql');
   show_vals (1, -1, 1);
   show_vals (NULL, -1, 1);
END;
/

CREATE OR REPLACE PROCEDURE show_vals (val1_in   IN NUMBER
                                     , val2_in   IN NUMBER
                                     , val3_in   IN NUMBER)
IS
   FUNCTION NVL2 (val_in      IN VARCHAR2
                , ifnull      IN VARCHAR2
                , ifnotnull   IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      IF val_in IS NULL
      THEN
         RETURN ifnull;
      ELSE
         RETURN ifnotnull;
      END IF;
   END NVL2;
BEGIN
   DBMS_OUTPUT.put_line (NVL2 (val1_in, val2_in, val3_in));
END show_vals;
/

BEGIN
   DBMS_OUTPUT.put_line ('my nvl2');
   show_vals (1, -1, 1);
   show_vals (NULL, -1, 1);
END;
/
