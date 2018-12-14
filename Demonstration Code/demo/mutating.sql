-- Cannot query from triggering table...

CREATE OR REPLACE TRIGGER isit_mutating
   AFTER INSERT OR UPDATE
   ON employees
   FOR EACH ROW
DECLARE
   myval   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO myval
     FROM employees;
END;
/

UPDATE employees
   SET salary = 1000
/
ROLLBACK ;

-- Now with autonomous transaction?

CREATE OR REPLACE TRIGGER isit_mutating
   AFTER INSERT OR UPDATE
   ON employees
   FOR EACH ROW
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
   myval   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO myval
     FROM employees;
END;
/

UPDATE employees
   SET salary = 1000;

ROLLBACK ;

-- Cannot change the triggering table...

CREATE OR REPLACE TRIGGER isit_mutating
   AFTER INSERT OR UPDATE
   ON employees
   FOR EACH ROW
DECLARE
   myval   NUMBER;
BEGIN
   UPDATE employees
      SET first_name = 'Steven'
    WHERE department_id = 10;
END;
/

UPDATE employees
   SET salary = 1000
 WHERE department_id = 20;

ROLLBACK ;

-- With auton transaction, get a deadlock error...

CREATE OR REPLACE TRIGGER isit_mutating
   AFTER INSERT OR UPDATE
   ON employees
   FOR EACH ROW
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
   myval   NUMBER;
BEGIN
   DELETE FROM employees;
END;
/
UPDATE employees
   SET salary = 1000;

ROLLBACK ;

DROP TRIGGER isit_mutating;