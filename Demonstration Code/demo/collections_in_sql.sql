CREATE OR REPLACE TYPE names_t AS TABLE OF VARCHAR2 (100);
/

/* Blend together data from a PL/SQL block and a relational table! */

DECLARE
   l_names   names_t := names_t ('Ellison', 'Kurian', 'Llewellyn');
BEGIN
   DBMS_OUTPUT.put_line ('Demo Employees + Oracle Employees');

   FOR rec
      IN (SELECT COLUMN_VALUE || ' (from PL/SQL)' last_name
            FROM TABLE (l_names)
          UNION
          SELECT last_name FROM employees)
   LOOP
      DBMS_OUTPUT.put_line (rec.last_name);
   END LOOP;
END;
/