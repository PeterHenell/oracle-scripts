/*

Optimization in PL/SQL only in 11g?

*/

CREATE OR REPLACE FUNCTION getdata (n NUMBER)
   RETURN NUMBER
   DETERMINISTIC
IS
BEGIN
   DBMS_OUTPUT.put_line ('ran func ' || n);
   RETURN n;
END;
/

DECLARE
   l_number   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line ('First block');

   FOR indx IN 1 .. 10
   LOOP
      l_number := getdata (1);
   END LOOP;
END;
/

DECLARE
   l_number   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line ('Second block');

   FOR indx IN 1 .. 10
   LOOP
      l_number := getdata (1);
   END LOOP;
END;
/

DECLARE
   l_number   NUMBER;
BEGIN
   FOR indx IN 1 .. 10
   LOOP
      l_number := getdata (1);
      l_number := getdata (2);
      l_number := getdata (3);
   END LOOP;
END;
/

/* Now test via performance */

CREATE OR REPLACE FUNCTION getdata_determ (n NUMBER)
   RETURN NUMBER
   DETERMINISTIC
IS
BEGIN
   RETURN n;
END;
/

CREATE OR REPLACE FUNCTION getdata (n NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN n;
END;
/

DECLARE
   n   NUMBER;
BEGIN
   sf_timer.start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      n := getdata (1);
   END LOOP;

   sf_timer.show_elapsed_time ('Non-Determ');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      n := getdata_determ (1);
   END LOOP;

   sf_timer.show_elapsed_time ('Determ');
END;
/