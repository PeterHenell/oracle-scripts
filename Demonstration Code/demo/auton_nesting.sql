DROP TABLE employee_auton;

CREATE TABLE employee_auton (
   name VARCHAR2(100));

INSERT INTO employee_auton VALUES ('Steven');
INSERT INTO employee_auton VALUES ('George');
INSERT INTO employee_auton VALUES ('Paul');
COMMIT;   

CREATE OR REPLACE PROCEDURE not_auton_no_commit
IS
BEGIN
   DELETE FROM employee_auton;
END not_auton_no_commit;
/

CREATE OR REPLACE PROCEDURE not_auton_commit
IS
BEGIN
   DELETE FROM employee_auton;

   COMMIT;
END not_auton_commit;
/

CREATE OR REPLACE PROCEDURE auton_commit
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   DELETE FROM employee_auton;

   COMMIT;
END auton_commit;
/

CREATE OR REPLACE PROCEDURE show_count (
   str_in     IN   VARCHAR2
 , where_in   IN   VARCHAR2 DEFAULT NULL
)
IS
   l_count   PLS_INTEGER;
BEGIN
   IF where_in IS NULL
   THEN
      SELECT COUNT (*)
        INTO l_count
        FROM employee_auton;
   ELSE
      EXECUTE IMMEDIATE    'SELECT COUNT(*) FROM employee_auton WHERE '
                        || where_in
                   INTO l_count;
   END IF;

   DBMS_OUTPUT.put_line (str_in || ' Employee_auton count = ' || l_count);
END show_count;
/

CREATE OR REPLACE PROCEDURE auton_call_non_auton
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   show_count ('Initial');
   not_auton_no_commit;
   show_count ('Not AUTON No Commit');
   ROLLBACK;
   show_count ('After Rollback');
   not_auton_commit;
   show_count ('Not AUTON Commit');
END auton_call_non_auton;
/

BEGIN
   auton_call_non_auton;
END;
/

DROP TABLE employee_auton;
CREATE TABLE employee_auton AS SELECT * FROM employee;

CREATE OR REPLACE PROCEDURE auton_call_auton
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   show_count ('Initial');
   INSERT INTO employee_auton SELECT * FROM employee;
   show_count ('Double table in outer transaction');
   auton_commit;
   show_count ('After Inner auton commit');
   ROLLBACK;
   show_count ('After Rollback');
END auton_call_auton;
/

BEGIN
   auton_call_auton;
END;
/