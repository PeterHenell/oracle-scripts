SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE plch_pkg1
IS
   g_number   NUMBER := 100;
END;
/

CREATE OR REPLACE PACKAGE plch_pkg2
IS
   PROCEDURE do_stuff;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg2
IS
   PROCEDURE do_stuff
   IS
      g_number   NUMBER := 100;
   BEGIN
      NULL;
   END;
END;
/

CREATE OR REPLACE PROCEDURE show_utilization (title_in IN VARCHAR2)
IS
   o   DBMS_SESSION.lname_array;
   n   DBMS_SESSION.lname_array;
   t   DBMS_SESSION.integer_array;
   u   DBMS_SESSION.integer_array;
   f   DBMS_SESSION.integer_array;
BEGIN
   DBMS_OUTPUT.put_line (title_in);

   DBMS_SESSION.get_package_memory_utilization (owner_names    => o,
                                                unit_names     => n,
                                                unit_types     => t,
                                                used_amounts   => u,
                                                free_amounts   => f);
   DBMS_OUTPUT.put_line ('Package count =' || o.COUNT);

   FOR indx IN 1 .. o.COUNT
   LOOP
      IF o (indx) = USER
      THEN
         DBMS_OUTPUT.put_line (
            t (indx) || ' ' || o (indx) || '.' || n (indx) || '=' || u (indx));
      END IF;
   END LOOP;
END;
/

BEGIN
   plch_pkg1.g_number := 1000;
   plch_pkg2.do_stuff;

   show_utilization ('After using packages');

   DBMS_SESSION.reset_package;

   show_utilization ('After resetting package state');
END;
/

BEGIN
   DBMS_SESSION.reset_package;
END;
/

SET SERVEROUTPUT ON

BEGIN
   show_utilization ('After resetting package state');
END;
/