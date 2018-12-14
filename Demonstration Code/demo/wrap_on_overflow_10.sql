CREATE OR REPLACE PACKAGE plch_pkg
IS
   PROCEDURE add_number (number_in IN NUMBER);

   PROCEDURE show_numbers;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   TYPE numbers_t IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   g_numbers     numbers_t;
   g_last_used   PLS_INTEGER := 0;

   PROCEDURE add_number (number_in IN NUMBER)
   IS
   BEGIN
      IF g_last_used = 3
      THEN
         g_numbers (1) := number_in;
         g_last_used := 1;
      ELSE
         g_last_used := g_last_used + 1;
         g_numbers (g_last_used) := number_in;
      END IF;
   END;

   PROCEDURE show_numbers
   IS
   BEGIN
      FOR indx IN 1 .. 3
      LOOP
         DBMS_OUTPUT.put_line (g_numbers (indx));
      END LOOP;
   END;
END;
/

BEGIN
   FOR indx IN 1 .. 5
   LOOP
      plch_pkg.add_number (indx);
   END LOOP;

   plch_pkg.show_numbers;
END;
/

/* SIMPLE_INTEGER wraps when it hits its limit.
   So it should wrap when I specify a shorter range,
   right? Wrong:
   
   ORA-06502: PL/SQL: numeric or value error
*/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   SUBTYPE just_3_t IS SIMPLE_INTEGER RANGE 1 .. 3;

   TYPE numbers_t IS TABLE OF NUMBER
      INDEX BY just_3_t;

   g_numbers     numbers_t;
   g_last_used   just_3_t := 0;

   PROCEDURE add_number (number_in IN NUMBER)
   IS
   BEGIN
      g_last_used := g_last_used + 1;
      g_numbers (g_last_used) := number_in;
   END;

   PROCEDURE show_numbers
   IS
   BEGIN
      FOR indx IN 1 .. 3
      LOOP
         DBMS_OUTPUT.put_line (g_numbers (indx));
      END LOOP;
   END;
END;
/

BEGIN
   FOR indx IN 1 .. 5
   LOOP
      plch_pkg.add_number (indx);
   END LOOP;

   plch_pkg.show_numbers;
END;
/

/* Clean up */

DROP PACKAGE plch_pkg
/