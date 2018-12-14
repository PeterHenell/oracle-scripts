CREATE OR REPLACE PACKAGE error_mgr
IS
   exc_sal_is_not_positive EXCEPTION;
   en_sal_is_not_positive   CONSTANT PLS_INTEGER := -20100;
   PRAGMA EXCEPTION_INIT (exc_sal_is_not_positive, -20100);

   exc_emp_too_young EXCEPTION;
   en_emp_too_young         CONSTANT PLS_INTEGER := -20200;
   PRAGMA EXCEPTION_INIT (exc_emp_too_young, -20200);
END error_mgr;
/

CREATE OR REPLACE TRIGGER positive_salary_required
   BEFORE INSERT OR UPDATE
   ON employees
   FOR EACH ROW
BEGIN
   IF :new.salary <= 0
   THEN
      message_mgr.raise_error (error_mgr.en_sal_is_not_positive);
   END IF;
END positive_salary_required;
/

UPDATE employees
   SET salary = 0
/

DROP TRIGGER positive_salary_required
/

BEGIN
   message_mgr.raise_error (-20700);
END;
/

/*
ORA-06501: PL/SQL: program error
ORA-06512: at "HR.MESSAGE_MGR", line 49
ORA-01403: no data found
ORA-06512: at line 2
*/

SELECT name, line, text
  FROM user_source
 WHERE INSTR (UPPER (text), 'RAISE_APPLICATION_ERROR') > 0
/