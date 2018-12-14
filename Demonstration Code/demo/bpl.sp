CREATE OR REPLACE PROCEDURE bpl (val IN BOOLEAN)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      CASE val
         WHEN TRUE THEN 'TRUE'
         WHEN FALSE THEN 'FALSE'
         ELSE 'NULL'
      END);
END bpl;
/

CREATE OR REPLACE PROCEDURE bplstr (str   IN VARCHAR2,
                                    val   IN BOOLEAN)
IS
BEGIN
   DBMS_OUTPUT.put_line (
         str
      || ' - '
      || CASE val
            WHEN TRUE THEN 'TRUE'
            WHEN FALSE THEN 'FALSE'
            ELSE 'NULL'
         END);
END bplstr;
/

BEGIN
   bpl (TRUE);
   bplstr ('Is this true?', TRUE);
END;
/