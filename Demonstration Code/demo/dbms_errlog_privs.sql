/* Create two schemas to use in example to avoid
   "pollution" from existing schema privileges.
*/

SPOOL dbms_errlog_privs.log

CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'drop user dml_owner cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE
      '
    grant Create Session, Resource, 
          create synonym, create public synonym, create table,
          drop public synonym
      to dml_owner identified by dml_owner';
END;
/

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'drop user dml_user cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE '
    grant Create Session, Resource, 
          create synonym, create table
      to dml_user identified by dml_user';
END;
/

CONNECT dml_owner/dml_owner

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 , last_name     VARCHAR2 (10)
 , salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100, 'Feuerstein', 10000);

   INSERT INTO plch_employees
        VALUES (200, 'Jobs', 1000000);

   COMMIT;
END;
/

/* Make sure public synonym is gone */

DROP PUBLIC SYNONYM plch_employees
/

/* Create error logging table */

BEGIN
   DBMS_ERRLOG.create_error_log ('PLCH_EMPLOYEES');
END;
/

/* Give other schema access to table. */

GRANT SELECT, UPDATE ON plch_employees TO dml_user
/

CREATE PUBLIC SYNONYM plch_employees FOR plch_employees
/

CONNECT dml_user/dml_user

SET SERVEROUTPUT ON FORMAT WRAPPED

/* Unable to log an error */

REM Without privs on log table, cannot complete update

BEGIN
   DBMS_OUTPUT.put_line (
      'Without privs on log table, cannot complete update');
   UPDATE plch_employees
      SET last_name = last_name||last_name
      LOG ERRORS REJECT LIMIT UNLIMITED;
   DBMS_OUTPUT.put_line ('Updated = ' || SQL%ROWCOUNT);
END;
/

/* Now grant privs on error logging table and try again */

CONNECT dml_owner/dml_owner

GRANT INSERT ON err$_plch_employees TO dml_user
/

CONNECT dml_user/dml_user

SET SERVEROUTPUT ON FORMAT WRAPPED

/* STILL get an error */

REM Without synonym on log table, cannot complete update

BEGIN
   DBMS_OUTPUT.put_line (
      'Without synonym on log table, cannot complete update');
   UPDATE plch_employees
      SET last_name = last_name||last_name
      LOG ERRORS REJECT LIMIT UNLIMITED;
   DBMS_OUTPUT.put_line ('Updated = ' || SQL%ROWCOUNT);
END;
/

ROLLBACK
/

/* Now create a synonym for the error logging table */

CONNECT dml_owner/dml_owner

GRANT INSERT ON err$_plch_employees TO dml_user
/

CREATE PUBLIC SYNONYM err$_plch_employees FOR err$_plch_employees
/

CONNECT dml_user/dml_user

SET SERVEROUTPUT ON FORMAT WRAPPED

REM Privs and synonym in place, can perform update.

BEGIN
   DBMS_OUTPUT.put_line ('Privs and synonym in place, can perform update.');
   UPDATE plch_employees
      SET last_name = last_name||last_name
      LOG ERRORS REJECT LIMIT UNLIMITED;
   DBMS_OUTPUT.put_line ('Updated = ' || SQL%ROWCOUNT);
END;
/

ROLLBACK
/

/* What about a private synonym for the error logging table? */

CONNECT dml_owner/dml_owner

DROP PUBLIC SYNONYM err$_plch_employees
/

CONNECT dml_user/dml_user

CREATE SYNONYM err$_plch_employees FOR dml_owner.err$_plch_employees
/

SET SERVEROUTPUT ON FORMAT WRAPPED

REM Private synonym on log table works, too.

BEGIN
   DBMS_OUTPUT.put_line ('Private synonym on log table works, too.');
   UPDATE plch_employees
      SET last_name = last_name||last_name
      LOG ERRORS REJECT LIMIT UNLIMITED;
   DBMS_OUTPUT.put_line ('Updated = ' || SQL%ROWCOUNT);
END;
/

ROLLBACK
/

/* Or use a local error logging table, specifying log table owner */

CONNECT dml_user/dml_user

SET SERVEROUTPUT ON FORMAT WRAPPED

DROP SYNONYM err$_plch_employees
/

DROP TABLE err$_plch_employees
/

REM Local log table, specifying owner of table

BEGIN
   DBMS_ERRLOG.create_error_log (
      dml_table_name        => 'DML_OWNER.PLCH_EMPLOYEES'
    , err_log_table_owner   => 'DML_USER');
END;
/

DESC ERR$_PLCH_EMPLOYEES

BEGIN
   DBMS_OUTPUT.put_line ('Local log table, specifying owner of table');
   UPDATE plch_employees
      SET last_name = last_name||last_name
      LOG ERRORS REJECT LIMIT UNLIMITED;
   DBMS_OUTPUT.put_line ('Updated = ' || SQL%ROWCOUNT);
END;
/

ROLLBACK
/

/* Or use a local error logging table, without specifying log table owner */

CONNECT dml_user/dml_user

SET SERVEROUTPUT ON FORMAT WRAPPED

DROP SYNONYM err$_plch_employees
/

DROP TABLE err$_plch_employees
/

REM Local log table, without specifying owner of table
REM Will attempt to create error log table in DML_OWNER schema.

BEGIN
   DBMS_ERRLOG.create_error_log (dml_table_name => 'DML_OWNER.PLCH_EMPLOYEES');
END;
/

/* Even though an error is raised, the error log table is created...IN DML_OWNER! */

DESC ERR$_PLCH_EMPLOYEES

BEGIN
   DBMS_OUTPUT.put_line (
      'Local log table, without specifying owner of table');
   UPDATE plch_employees
      SET last_name = last_name||last_name
      LOG ERRORS REJECT LIMIT UNLIMITED;
   DBMS_OUTPUT.put_line ('Updated = ' || SQL%ROWCOUNT);
END;
/

ROLLBACK
/

/* NOTE: this is not an option offered in the question itself. Just here for completeness.
   Lastly, give dml_user create any table and try again to create log table. */

CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'drop user dml_user cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE '
    grant Create Session, Resource, 
          create synonym, create any table
      to dml_user identified by dml_user';
END;
/

CONNECT dml_owner/dml_owner

GRANT SELECT,UPDATE ON plch_employees TO dml_user
/

DROP PUBLIC SYNONYM plch_employees
/

CREATE PUBLIC SYNONYM plch_employees FOR plch_employees
/

DROP TABLE err$_plch_employees
/

CONNECT dml_user/dml_user

SET SERVEROUTPUT ON FORMAT WRAPPED

DROP SYNONYM err$_plch_employees
/

DROP TABLE err$_plch_employees
/

REM Local log table, without specifying owner of table
REM Will attempt to create error log table in DML_OWNER schema.

BEGIN
   DBMS_ERRLOG.create_error_log (
      dml_table_name        => 'DML_OWNER.PLCH_EMPLOYEES'
    , err_log_table_owner   => 'DML_USER');
END;
/

DESC ERR$_PLCH_EMPLOYEES

BEGIN
   DBMS_OUTPUT.put_line (
      'Local log table, using create any table privilege');
   UPDATE plch_employees
      SET last_name = last_name||last_name
      LOG ERRORS REJECT LIMIT UNLIMITED;
   DBMS_OUTPUT.put_line ('Updated = ' || SQL%ROWCOUNT);
END;
/

ROLLBACK
/

SPOOL OFF