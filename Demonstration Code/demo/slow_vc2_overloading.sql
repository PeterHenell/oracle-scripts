CREATE OR REPLACE PACKAGE pkg_test
AS
   FUNCTION fv (i VARCHAR2)
      RETURN NUMBER;

   FUNCTION fn (i NUMBER)
      RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_test
AS
   FUNCTION fv (i VARCHAR2)
      RETURN NUMBER
   IS
   BEGIN
      RETURN 1;
   END;

   FUNCTION fn (i NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      RETURN 1;
   END;
END;
/

CREATE OR REPLACE FUNCTION fv (i VARCHAR2)
   RETURN NUMBER
IS
BEGIN
   RETURN 1;
END;
/

CREATE OR REPLACE FUNCTION fn (i NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN 1;
END;
/

/* No difference in PL/SQL 

"VC2 overloading" completed in: 2.5 seconds
"Number overloading" completed in: 2.52 seconds
"Schema-level VC2" completed in: 2.48 seconds
"Schema-level Number" completed in: 2.49 seconds

*/

DECLARE
   l             NUMBER;
   last_timing   NUMBER := NULL;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            '"'
         || message_in
         || '" completed in: '
         || (DBMS_UTILITY.get_cpu_time - last_timing) / 100
         || ' seconds');
   END;
BEGIN
   start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      l := pkg_test.fv (NULL);
   END LOOP;

   show_elapsed_time ('VC2 overloading');
   --
   start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      l := pkg_test.fn (NULL);
   END LOOP;

   show_elapsed_time ('Number overloading');
   --
   start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      l := fv (NULL);
   END LOOP;

   show_elapsed_time ('Schema-level VC2');
   --
   start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      l := fv (NULL);
   END LOOP;

   show_elapsed_time ('Schema-level Number');
END;
/

/* Noticeable difference in SQL 

MAX(PKG_TEST.FV(NULL))
----------------------
                     1
1 row selected.
Elapsed: 00:00:07.93

MAX(FV(NULL))
-------------
            1
1 row selected.
Elapsed: 00:00:05.03

MAX(PKG_TEST.FN(NULL))
----------------------
                     1
1 row selected.
Elapsed: 00:00:04.45

MAX(FN(NULL))
-------------
            1
1 row selected.
Elapsed: 00:00:05.45

*/

SET TIMING ON

CREATE TABLE driver_table
AS
       SELECT LEVEL id
         FROM DUAL
   CONNECT BY LEVEL < 1000000
/

SELECT MAX (pkg_test.fv (NULL)) FROM driver_table
/

SELECT MAX (fv (NULL)) FROM driver_table
/

SELECT MAX (pkg_test.fn (NULL)) FROM driver_table
/

SELECT MAX (fn (NULL)) FROM driver_table
/

DROP driver_table
/

DROP package pkg_test
/

DROP FUNCTION fn
/

DROP FUNCTION fv
/