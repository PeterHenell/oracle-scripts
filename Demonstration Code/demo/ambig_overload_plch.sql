CREATE OR REPLACE PACKAGE plch_pkg
IS
   PROCEDURE show_data (value1_in IN VARCHAR2, value2_in IN NUMBER);

   PROCEDURE show_data (value1_in   IN VARCHAR2
                      , value2_in   IN NUMBER
                      , value3_in   IN BOOLEAN DEFAULT TRUE);
END plch_pkg;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE show_data (value1_in   IN VARCHAR2
                      , value2_in   IN NUMBER
                      , value3_in   IN BOOLEAN DEFAULT TRUE)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         value1_in || ' ' || value2_in || ' '
         || CASE value3_in
               WHEN TRUE THEN 'TRUE'
               WHEN FALSE THEN 'FALSE'
               ELSE 'NULL'
            END);
   END;

   PROCEDURE show_data (value1_in IN VARCHAR2, value2_in IN NUMBER)
   IS
   BEGIN
      show_data (value1_in, value2_in, TRUE);
   END;
END plch_pkg;
/

/* This raises the error:
       PLS-00307: too many declarations of 'SHOW_DATA' match this call
*/

BEGIN
   plch_pkg.show_data ('Lucky Number?', 4815162342);
   plch_pkg.show_data ('Lucky Number?', 4815162342, FALSE);
END;
/

/* Adding named notation does not help */

BEGIN
   plch_pkg.show_data ('Lucky Number?', 4815162342);
   plch_pkg.show_data ('Lucky Number?', 4815162342, value3_in => FALSE);
END;
/

/* Adding named notation does not help */

BEGIN
   plch_pkg.show_data (value1_in => 'Lucky Number?', value2_in => 4815162342);
   plch_pkg.show_data (value1_in   => 'Lucky Number?'
                     , value2_in   => 4815162342
                     , value3_in   => FALSE);
END;
/

/* Remove default value from third parameter */

CREATE OR REPLACE PACKAGE plch_pkg
IS
   PROCEDURE show_data (value1_in IN VARCHAR2, value2_in IN NUMBER);

   PROCEDURE show_data (value1_in   IN VARCHAR2
                      , value2_in   IN NUMBER
                      , value3_in   IN BOOLEAN);
END plch_pkg;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE show_data (value1_in   IN VARCHAR2
                      , value2_in   IN NUMBER
                      , value3_in   IN BOOLEAN)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         value1_in || ' ' || value2_in || ' '
         || CASE value3_in
               WHEN TRUE THEN 'TRUE'
               WHEN FALSE THEN 'FALSE'
               ELSE 'NULL'
            END);
   END;

   PROCEDURE show_data (value1_in IN VARCHAR2, value2_in IN NUMBER)
   IS
   BEGIN
      show_data (value1_in, value2_in, TRUE);
   END;
END plch_pkg;
/

BEGIN
   plch_pkg.show_data ('Lucky Number?', 4815162342);
   plch_pkg.show_data ('Lucky Number?', 4815162342, FALSE);
END;
/

/* Get rid of overloading entirely */

CREATE OR REPLACE PACKAGE plch_pkg
IS
   PROCEDURE show_data (value1_in   IN VARCHAR2
                      , value2_in   IN NUMBER
                      , value3_in   IN BOOLEAN DEFAULT TRUE);
END plch_pkg;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE show_data (value1_in   IN VARCHAR2
                      , value2_in   IN NUMBER
                      , value3_in   IN BOOLEAN DEFAULT TRUE)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         value1_in || ' ' || value2_in || ' '
         || CASE value3_in
               WHEN TRUE THEN 'TRUE'
               WHEN FALSE THEN 'FALSE'
               ELSE 'NULL'
            END);
   END;
END plch_pkg;
/

BEGIN
   plch_pkg.show_data ('Lucky Number?', 4815162342);
   plch_pkg.show_data ('Lucky Number?', 4815162342, FALSE);
END;
/