CREATE OR REPLACE PACKAGE serial_package
AS
   CURSOR emps_cur
   IS
      SELECT *
        FROM employees;
END serial_package;
/

BEGIN
   OPEN serial_package.emps_cur;
END;
/

BEGIN
   OPEN serial_package.emps_cur;
END;
/

CREATE OR REPLACE PACKAGE serial_package
AS
   PRAGMA SERIALLY_REUSABLE;

   CURSOR emps_cur
   IS
      SELECT *
        FROM employees;
END serial_package;
/

BEGIN
   OPEN serial_package.emps_cur;
END;
/

BEGIN
   OPEN serial_package.emps_cur;
END;
/