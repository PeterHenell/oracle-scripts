/*
Write a procedure that accepts a positive integer, displays all
the integers between 1 and that number, and then terminates.
*/

CREATE OR REPLACE PROCEDURE plch_show_numbers (
   up_to_in IN PLS_INTEGER)
IS
BEGIN
   FOR indx IN 1 .. up_to_in
   LOOP
      DBMS_OUTPUT.put_line (indx);
   END LOOP;

   RETURN;
END;
/

SHOW ERRORS

BEGIN
   plch_show_numbers (3);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_numbers (
   up_to_in IN PLS_INTEGER)
IS
BEGIN
   FOR indx IN 1 .. up_to_in
   LOOP
      DBMS_OUTPUT.put_line (indx);
   END LOOP;

   EXIT;
END;
/

SHOW ERRORS

CREATE OR REPLACE PROCEDURE plch_show_numbers (
   up_to_in IN PLS_INTEGER)
IS
BEGIN
   FOR indx IN 1 .. up_to_in
   LOOP
      DBMS_OUTPUT.put_line (indx);
   END LOOP;

   RAISE PROGRAM_ERROR;
EXCEPTION
   WHEN PROGRAM_ERROR
   THEN
      NULL;
END;
/

SHOW ERRORS

BEGIN
   plch_show_numbers (3);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_numbers (
   up_to_in IN PLS_INTEGER)
IS
BEGIN
   FOR indx IN 1 .. up_to_in
   LOOP
      DBMS_OUTPUT.put_line (indx);
   END LOOP;

   raise_application_error (-20000, 'All done');
END;
/

SHOW ERRORS

BEGIN
   plch_show_numbers (3);
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
/

CREATE OR REPLACE PROCEDURE plch_show_numbers (
   up_to_in IN PLS_INTEGER)
IS
BEGIN
   FOR indx IN 1 .. up_to_in
   LOOP
      DBMS_OUTPUT.put_line (indx);
   END LOOP;
END;
/

SHOW ERRORS

BEGIN
   plch_show_numbers (3);
END;
/