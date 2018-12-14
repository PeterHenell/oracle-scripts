SPOOL external_tables_demo.log

CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE create_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      EXECUTE IMMEDIATE
            'grant Create Session, Resource to '
         || user_in
         || ' identified by '
         || user_in;

      DBMS_OUTPUT.put_line ('User "' || user_in || '" was created.');
   END create_user;
BEGIN
   create_user ('Usr');

   EXECUTE IMMEDIATE 'grant create any directory to Usr';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY TEMP AS ''c:\temp''';

   EXECUTE IMMEDIATE 'GRANT READ,WRITE ON DIRECTORY TEMP to Usr';
END;
/

CONNECT Usr/Usr

SET SERVEROUTPUT ON FORMAT WRAPPED

DROP TABLE departments_ext
/

CREATE TABLE departments_ext (
   department_id        NUMBER(6),
   department_name      VARCHAR2(40),
   department_location  VARCHAR2(25)
)
ORGANIZATION EXTERNAL
(TYPE oracle_loader
 DEFAULT DIRECTORY demo
 ACCESS PARAMETERS
 (
  RECORDS DELIMITED BY NEWLINE
  BADFILE 'departments.bad'
  DISCARDFILE 'departments.dis'
  LOGFILE 'departments.log'
  FIELDS TERMINATED BY ","  OPTIONALLY ENCLOSED BY '"'
  (
   department_id        INTEGER EXTERNAL(6),
   department_name      CHAR(40),
   department_location  CHAR(25)
  )
 )
 LOCATION ('departments.ctl')
)
REJECT LIMIT UNLIMITED
/

SELECT * FROM departments_ext
/

DECLARE
   l_department   departments_ext%ROWTYPE;
BEGIN
   SELECT *
     INTO l_department
     FROM departments_ext
    WHERE department_id = 1;

   DBMS_OUTPUT.put_line (l_department.department_name);
END;
/

/* And I can join this data with another table's data: */

SELECT department_name FROM departments_ext
UNION
SELECT department_name FROM departments
/

/* But I can't change the contents */

DELETE FROM departments_ext
/

CONNECT Sys/quest AS SYSDBA

DROP USER usr CASCADE
/

SPOOL OFF