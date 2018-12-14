/* Change a character to a number, where A = 0 and J = 9. 

   So "ABC" -> "012"
*/

/* The cleanest, best solution */

CREATE OR REPLACE FUNCTION plch_to_numbers (
   string_in IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN TRANSLATE (string_in, 'ABCDEFGHIJ', '0123456789');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_to_numbers ('ABC'));
   DBMS_OUTPUT.put_line (plch_to_numbers ('CEGI'));
END;
/

/* Brute force with CASE */

CREATE OR REPLACE FUNCTION plch_to_numbers (
   string_in IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_return   VARCHAR2 (10);
BEGIN
   FOR indx IN 1 .. LENGTH (string_in)
   LOOP
      l_return :=
            l_return
         || CASE SUBSTR (string_in, indx, 1)
               WHEN 'A' THEN 0
               WHEN 'B' THEN 1
               WHEN 'C' THEN 2
               WHEN 'D' THEN 3
               WHEN 'E' THEN 4
               WHEN 'F' THEN 5
               WHEN 'G' THEN 6
               WHEN 'H' THEN 7
               WHEN 'I' THEN 8
               WHEN 'J' THEN 9
            END;
   END LOOP;

   RETURN l_return;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_to_numbers ('ABC'));
   DBMS_OUTPUT.put_line (plch_to_numbers ('CEGI'));
END;
/

/* Use the ASCII function */

CREATE OR REPLACE FUNCTION plch_to_numbers (
   string_in IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_return   VARCHAR2 (10);
BEGIN
   FOR indx IN 1 .. LENGTH (string_in)
   LOOP
      l_return :=
            l_return
         || TO_CHAR (
               ASCII (SUBSTR (string_in, indx, 1)) - 65);
   END LOOP;

   RETURN l_return;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_to_numbers ('ABC'));
   DBMS_OUTPUT.put_line (plch_to_numbers ('CEGI'));
END;
/

/* Not a good fit for replace */

CREATE OR REPLACE FUNCTION plch_to_numbers (
   string_in IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN REPLACE (string_in, 'ABCDEFGHIJ', '0123456789');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_to_numbers ('ABC'));
   DBMS_OUTPUT.put_line (plch_to_numbers ('CEGI'));
END;
/

/* Clean up */

DROP FUNCTION plch_to_numbers
/