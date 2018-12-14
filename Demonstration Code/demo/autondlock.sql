CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
)
/

CREATE OR REPLACE PROCEDURE plch_ins_data
IS
BEGIN
   DELETE FROM plch_employees;

   INSERT INTO plch_employees
        VALUES (100, 'Ellison', 1000000);

   INSERT INTO plch_employees
        VALUES (200, 'Gates', 1000000);

   INSERT INTO plch_employees
        VALUES (300, 'Zuckerberg', 1000000);

   COMMIT;
END;
/

BEGIN
   plch_ins_data;
END;
/

/* Multiple commits or rollbacks are fine. */

CREATE OR REPLACE PROCEDURE plch_update_salary (name_like_in IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE plch_employees
      SET salary = salary * 2
    WHERE last_name LIKE name_like_in;

   COMMIT;

   UPDATE plch_employees
      SET salary = salary * .5
    WHERE last_name NOT LIKE name_like_in;

   COMMIT;
END;
/

BEGIN
   plch_update_salary ('%e%');
END;
/

/* Rollback in main transaction does not affect changes in AT */

BEGIN
   plch_ins_data;
END;
/

DECLARE
   l_count   PLS_INTEGER;

   PROCEDURE show_count
   IS
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM plch_employees
       WHERE salary > 1000000;

      DBMS_OUTPUT.put_line (l_count);
   END;
BEGIN
   show_count;
   
   plch_update_salary ('%e%');
   
   show_count;

   ROLLBACK;

   show_count;
END;
/

/* This section demonstrates that the AT does not share locks with
      the main transaction. */

CREATE OR REPLACE PROCEDURE plch_update_salary (name_like_in IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   FOR rec IN (    SELECT employee_id
                     FROM plch_employees
                    WHERE last_name LIKE name_like_in
               FOR UPDATE NOWAIT)
   LOOP
      UPDATE plch_employees
         SET salary = salary * 2
       WHERE employee_id = rec.employee_id;
   END LOOP;

   COMMIT;
END;
/

BEGIN
   UPDATE plch_employees
      SET salary = salary * 2;

   plch_update_salary ('%e%');
END;
/

/* Visibility of AT changes in main transaction */

CREATE OR REPLACE PROCEDURE plch_fire_em_all
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   DELETE FROM plch_employees;
   COMMIT;
END;
/

DECLARE
   l_count   PLS_INTEGER;

   PROCEDURE show_count
   IS
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM plch_employees;

      DBMS_OUTPUT.put_line (l_count);
   END;
BEGIN
   SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

   show_count;
   
   plch_fire_em_all;

   /* Main transaction still sees rows in table. */
   show_count;
   
   COMMIT; 

   /* Now all rows are gone in main transaction */
   show_count;
END;
/


DROP TABLE plch_employees
/

DROP PROCEDURE plch_ins_data
/

DROP PROCEDURE plch_update_salary
/

DROP PROCEDURE plch_fire_em_all
/