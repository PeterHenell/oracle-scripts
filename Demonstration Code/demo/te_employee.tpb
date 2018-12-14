CREATE OR REPLACE PACKAGE BODY te_employee_tst
IS
   g_norow EMPLOYEE%ROWTYPE;
   g_norow_set BOOLEAN := FALSE;

   -- Display header for a new set of information.
   PROCEDURE newset (str IN VARCHAR2, gr IN VARCHAR2 := '=') IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE (RPAD (gr, 60, gr));
      DBMS_OUTPUT.PUT_LINE (str);
      DBMS_OUTPUT.PUT_LINE (RPAD (gr, 60, gr));
   END;

   -- Show the contents of a table record.
   PROCEDURE showrow (row_in IN EMPLOYEE%ROWTYPE) IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('**COL EMPLOYEE_ID: ' || row_in.EMPLOYEE_ID);
      DBMS_OUTPUT.PUT_LINE ('**COL LAST_NAME: ' || row_in.LAST_NAME);
      DBMS_OUTPUT.PUT_LINE ('**COL FIRST_NAME: ' || row_in.FIRST_NAME);
      DBMS_OUTPUT.PUT_LINE ('**COL MIDDLE_INITIAL: ' || row_in.MIDDLE_INITIAL);
      DBMS_OUTPUT.PUT_LINE ('**COL JOB_ID: ' || row_in.JOB_ID);
      DBMS_OUTPUT.PUT_LINE ('**COL MANAGER_ID: ' || row_in.MANAGER_ID);
      DBMS_OUTPUT.PUT_LINE ('**COL HIRE_DATE: ' || row_in.HIRE_DATE);
      DBMS_OUTPUT.PUT_LINE ('**COL SALARY: ' || row_in.SALARY);
      DBMS_OUTPUT.PUT_LINE ('**COL COMMISSION: ' || row_in.COMMISSION);
      DBMS_OUTPUT.PUT_LINE ('**COL DEPARTMENT_ID: ' || row_in.DEPARTMENT_ID);
      DBMS_OUTPUT.PUT_LINE ('**COL EMPNO: ' || row_in.EMPNO);
      DBMS_OUTPUT.PUT_LINE ('**COL ENAME: ' || row_in.ENAME);
      DBMS_OUTPUT.PUT_LINE ('**COL CREATED_BY: ' || row_in.CREATED_BY);
      DBMS_OUTPUT.PUT_LINE ('**COL CREATED_ON: ' || row_in.CREATED_ON);
      DBMS_OUTPUT.PUT_LINE ('**COL CHANGED_BY: ' || row_in.CHANGED_BY);
      DBMS_OUTPUT.PUT_LINE ('**COL CHANGED_ON: ' || row_in.CHANGED_ON);
   END;

   -- Sets contents of record that does NOT match a row in the database table.
   PROCEDURE set_norow (
      employee_id_in IN EMPLOYEE.EMPLOYEE_ID%TYPE
      ,last_name_in IN EMPLOYEE.LAST_NAME%TYPE DEFAULT NULL
      ,first_name_in IN EMPLOYEE.FIRST_NAME%TYPE DEFAULT NULL
      ,middle_initial_in IN EMPLOYEE.MIDDLE_INITIAL%TYPE DEFAULT NULL
      ,job_id_in IN EMPLOYEE.JOB_ID%TYPE DEFAULT NULL
      ,manager_id_in IN EMPLOYEE.MANAGER_ID%TYPE DEFAULT NULL
      ,hire_date_in IN EMPLOYEE.HIRE_DATE%TYPE DEFAULT SYSDATE
      ,salary_in IN EMPLOYEE.SALARY%TYPE DEFAULT NULL
      ,commission_in IN EMPLOYEE.COMMISSION%TYPE DEFAULT NULL
      ,department_id_in IN EMPLOYEE.DEPARTMENT_ID%TYPE DEFAULT NULL
      ,empno_in IN EMPLOYEE.EMPNO%TYPE DEFAULT NULL
      ,ename_in IN EMPLOYEE.ENAME%TYPE DEFAULT NULL
      ,created_by_in IN EMPLOYEE.CREATED_BY%TYPE DEFAULT USER
      ,created_on_in IN EMPLOYEE.CREATED_ON%TYPE DEFAULT SYSDATE
      ,changed_by_in IN EMPLOYEE.CHANGED_BY%TYPE DEFAULT USER
      ,changed_on_in IN EMPLOYEE.CHANGED_ON%TYPE DEFAULT SYSDATE
      )
   IS
   BEGIN
      newset ('Defining "No Row" Values for Primary and Foreign Keys');
      g_norow.EMPLOYEE_ID := employee_id_in;
      g_norow.LAST_NAME := last_name_in;
      g_norow.FIRST_NAME := first_name_in;
      g_norow.MIDDLE_INITIAL := middle_initial_in;
      g_norow.JOB_ID := job_id_in;
      g_norow.MANAGER_ID := manager_id_in;
      g_norow.HIRE_DATE := hire_date_in;
      g_norow.SALARY := salary_in;
      g_norow.COMMISSION := commission_in;
      g_norow.DEPARTMENT_ID := department_id_in;
      g_norow.EMPNO := empno_in;
      g_norow.ENAME := ename_in;
      g_norow.CREATED_BY := created_by_in;
      g_norow.CREATED_ON := created_on_in;
      g_norow.CHANGED_BY := changed_by_in;
      g_norow.CHANGED_ON := changed_on_in;
      g_norow_set := TRUE;
   END;

   FUNCTION norowset RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_norow_set;
   END;

   -- Test unique index related functionality.
   PROCEDURE uind (maxrows IN INTEGER := NULL)
   IS
      v_row EMPLOYEE%ROWTYPE;

      --// Test record structures and functions to retrieve rows. --//
      i_employee_name_r te_employee.i_employee_name_rt;
      v_pky te_employee.pky_rt;
   BEGIN
      newset ('Unique Index-Related Fetch Activity', '*');

      -- Exercise "by primary key" cursor
      FOR rec IN te_employee.allbypky_cur
      LOOP
         EXIT WHEN te_employee.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         -- Perform a lookup based on the primary key values.
         v_pky := te_employee.i_employee_name$pky (
            rec.LAST_NAME,
            rec.FIRST_NAME,
            rec.MIDDLE_INITIAL
            );

         -- Display contents to verify the results.
         DBMS_OUTPUT.PUT_LINE ('Primary key from I_EMPLOYEE_NAME:');
         DBMS_OUTPUT.PUT_LINE ('**IND LAST_NAME: ' || rec.LAST_NAME);
         DBMS_OUTPUT.PUT_LINE ('**IND FIRST_NAME: ' || rec.FIRST_NAME);
         DBMS_OUTPUT.PUT_LINE ('**IND MIDDLE_INITIAL: ' || rec.MIDDLE_INITIAL);
         DBMS_OUTPUT.PUT_LINE ('**PKY EMPLOYEE_ID: ' || v_pky.employee_id);

         -- If user has set a "no row", use it to test a failed lookup
         -- by primary key.
         IF norowset
         THEN
            v_pky := te_employee.i_employee_name$pky (
               g_norow.LAST_NAME,
               g_norow.FIRST_NAME,
               g_norow.MIDDLE_INITIAL
              );

            -- If primary key is null, then the lookup failed.
            IF te_employee.isnullpky (v_pky)
            THEN
               DBMS_OUTPUT.PUT_LINE ('"No row" value from I_EMPLOYEE_NAME is invalid/NULL.');
            END IF;
         END IF;

         newset ('Look up index entry for a primary key.');

         -- Use the primary key to return an index entry
         i_employee_name_r := te_employee.i_employee_name$val (
            rec.EMPLOYEE_ID
            );

         DBMS_OUTPUT.PUT_LINE ('Index i_employee_name values from Primary Key');
         DBMS_OUTPUT.PUT_LINE ('**PKY EMPLOYEE_ID: ' || rec.EMPLOYEE_ID);
         DBMS_OUTPUT.PUT_LINE ('**IND LAST_NAME: ' || i_employee_name_r.last_name);
         DBMS_OUTPUT.PUT_LINE ('**IND FIRST_NAME: ' || i_employee_name_r.first_name);
         DBMS_OUTPUT.PUT_LINE ('**IND MIDDLE_INITIAL: ' || i_employee_name_r.middle_initial);

         newset ('Look up row for unique index');

         -- Get all row information for the contents of a unique index entry.
         v_row := te_employee.i_employee_name$row (
            rec.LAST_NAME,
            rec.FIRST_NAME,
            rec.MIDDLE_INITIAL
            );
         DBMS_OUTPUT.PUT_LINE ('Entire row from I_EMPLOYEE_NAME:');
         DBMS_OUTPUT.PUT_LINE ('**IND LAST_NAME: ' || rec.LAST_NAME);
         DBMS_OUTPUT.PUT_LINE ('**IND FIRST_NAME: ' || rec.FIRST_NAME);
         DBMS_OUTPUT.PUT_LINE ('**IND MIDDLE_INITIAL: ' || rec.MIDDLE_INITIAL);
         showrow (v_row);

      END LOOP;
   END uind;

   PROCEDURE pky (maxrows IN INTEGER := NULL)
   IS
      v_row te_employee.allforpky_cur%ROWTYPE;

      v_pky te_employee.pky_rt;

   BEGIN
      newset ('Primary Key-Related Activity', '*');

      -- Use the by primary key cursor.
      FOR rec IN te_employee.allbypky_cur
      LOOP
         EXIT WHEN te_employee.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         newset ('Cursor by primary key');

         -- Open the cursor for the current primary key and fetch the row
         -- it identifies.

         OPEN te_employee.allforpky_cur (
            rec.EMPLOYEE_ID
            );

         FETCH te_employee.allforpky_cur INTO v_row;

         DBMS_OUTPUT.PUT_LINE ('**PKY EMPLOYEE_ID: ' || v_row.EMPLOYEE_ID);

         IF te_employee.allforpky_cur%NOTFOUND
         THEN
            DBMS_OUTPUT.PUT_LINE ('!! Row not found for primary key.');
         ELSE
            DBMS_OUTPUT.PUT_LINE ('Row found for primary key');
            DBMS_OUTPUT.PUT_LINE ('**COL LAST_NAME: ' || v_row.LAST_NAME);
            DBMS_OUTPUT.PUT_LINE ('**COL FIRST_NAME: ' || v_row.FIRST_NAME);
            DBMS_OUTPUT.PUT_LINE ('**COL MIDDLE_INITIAL: ' || v_row.MIDDLE_INITIAL);
            DBMS_OUTPUT.PUT_LINE ('**COL JOB_ID: ' || v_row.JOB_ID);
            DBMS_OUTPUT.PUT_LINE ('**COL MANAGER_ID: ' || v_row.MANAGER_ID);
            DBMS_OUTPUT.PUT_LINE ('**COL HIRE_DATE: ' || v_row.HIRE_DATE);
            DBMS_OUTPUT.PUT_LINE ('**COL SALARY: ' || v_row.SALARY);
            DBMS_OUTPUT.PUT_LINE ('**COL COMMISSION: ' || v_row.COMMISSION);
            DBMS_OUTPUT.PUT_LINE ('**COL DEPARTMENT_ID: ' || v_row.DEPARTMENT_ID);
            DBMS_OUTPUT.PUT_LINE ('**COL EMPNO: ' || v_row.EMPNO);
            DBMS_OUTPUT.PUT_LINE ('**COL ENAME: ' || v_row.ENAME);
            DBMS_OUTPUT.PUT_LINE ('**COL CREATED_BY: ' || v_row.CREATED_BY);
            DBMS_OUTPUT.PUT_LINE ('**COL CREATED_ON: ' || v_row.CREATED_ON);
            DBMS_OUTPUT.PUT_LINE ('**COL CHANGED_BY: ' || v_row.CHANGED_BY);
            DBMS_OUTPUT.PUT_LINE ('**COL CHANGED_ON: ' || v_row.CHANGED_ON);
         END IF;

         -- Close the cursor.
         te_employee.close_allforpky_cur;

      END LOOP;
   END pky;

   -- Test FKY related functionality.
   PROCEDURE fky (maxrows IN INTEGER := NULL)
   IS
      v_pky EMPLOYEE.employee_id%TYPE;
   BEGIN
      newset ('Foreign Key-Related Activity', '*');

   END fky;

   -- Test lookup functionality
   PROCEDURE lookups (maxrows IN INTEGER := NULL)
   IS
      v_row EMPLOYEE%ROWTYPE;

   BEGIN
      newset ('Retrieve one row at a time.', '*');

      FOR rec IN te_employee.allbypky_cur
      LOOP
         EXIT WHEN te_employee.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         newset ('Retrieve and display row and desc columns for primary key.');

         DBMS_OUTPUT.PUT_LINE ('**PKY EMPLOYEE_ID: ' || rec.EMPLOYEE_ID);

         -- Use onerow function to lookup row for this primary key value.
         v_row := te_employee.onerow (
            rec.EMPLOYEE_ID
            );

         IF NOT te_employee.isnullpky (v_row)
         THEN
            showrow (v_row);
         ELSE
            DBMS_OUTPUT.PUT_LINE ('!! Row not found for primary key.');
         END IF;
      END LOOP;


   END lookups;

   -- Test the validation programs.
   PROCEDURE validate
   IS
      v_row EMPLOYEE%ROWTYPE;
      v_valuesOK BOOLEAN;
      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
   BEGIN
--// Check Constraint Validation --//

      --// Check Constraint: "HIRE_DATE" IS NOT NULL --//
      IF NOT te_employee.sys_c003090$chk (
         hire_date_in => NULL
         )
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'Constraint SYS_C003090 failed.');
      END IF;

      --// Check Constraint: "CREATED_BY" IS NOT NULL --//
      IF NOT te_employee.sys_c003091$chk (
         created_by_in => NULL
         )
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'Constraint SYS_C003091 failed.');
      END IF;

      --// Check Constraint: "CREATED_ON" IS NOT NULL --//
      IF NOT te_employee.sys_c003092$chk (
         created_on_in => NULL
         )
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'Constraint SYS_C003092 failed.');
      END IF;

      --// Check Constraint: "CHANGED_BY" IS NOT NULL --//
      IF NOT te_employee.sys_c003093$chk (
         changed_by_in => NULL
         )
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'Constraint SYS_C003093 failed.');
      END IF;

      --// Check Constraint: "CHANGED_ON" IS NOT NULL --//
      IF NOT te_employee.sys_c003094$chk (
         changed_on_in => NULL
         )
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'Constraint SYS_C003094 failed.');
      END IF;

      te_employee.validate (
         hire_date_in => NULL,
         created_by_in => NULL,
         created_on_in => NULL,
         changed_by_in => NULL,
         changed_on_in => NULL,
         record_error => FALSE --// no record //--
         );

      te_employee.validate (v_row, FALSE);
   END validate;

   -- Test insert activity.
   PROCEDURE ins (maxrows IN INTEGER := NULL)
   IS
      v_row EMPLOYEE%ROWTYPE;
      v_pky te_employee.pky_rt;
      v_pkycol INTEGER;
      v_nxtpky INTEGER;

      --// Variable for every primary key column //--
      v_EMPLOYEE_ID EMPLOYEE.EMPLOYEE_ID%TYPE;

      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
   BEGIN
      newset ('INS: function-based record init');
      v_row := te_employee.initrec;
      showrow (v_row);

      newset ('INS: procedure-based record init');
      te_employee.initrec (v_row);
      showrow (v_row);

      ROLLBACK;

      newset ('INS: Pass in primary key');

      te_employee.ins (
         v_EMPLOYEE_ID,
         SUBSTR ('LAST_NAME', 1, 15),
         SUBSTR ('FIRST_NAME', 1, 15),
         SUBSTR ('MIDDLE_INITIAL', 1, 1),
         22,
         22,
         SYSDATE,
         22,
         22,
         22,
         22,
         SUBSTR ('ENAME', 1, 30),
         SUBSTR ('CREATED_BY', 1, 100),
         SYSDATE,
         SUBSTR ('CHANGED_BY', 1, 100),
         SYSDATE,
         FALSE
         );

      ROLLBACK;

      newset ('INS: Record-based insert');

      --// Populate the row! //--
      te_employee.ins (v_row,
         FALSE
         );

      ROLLBACK;
      FOR rec IN te_employee.allbypky_cur
      LOOP
         EXIT WHEN te_employee.allbypky_cur%ROWCOUNT > 1;

         --// Move primary key information to the PKY record. //--
         v_pky.employee_id := rec.EMPLOYEE_ID;

         --// Try to reinsert same record with update-on-dup option. //--
         --// Double all nonprimary key column values. //--
         v_row.LAST_NAME :=
            SUBSTR (v_row.LAST_NAME || v_row.LAST_NAME, 1, 15);
         v_row.FIRST_NAME :=
            SUBSTR (v_row.FIRST_NAME || v_row.FIRST_NAME, 1, 15);
         v_row.MIDDLE_INITIAL :=
            SUBSTR (v_row.MIDDLE_INITIAL || v_row.MIDDLE_INITIAL, 1, 1);
         v_row.JOB_ID :=
            v_row.JOB_ID + v_row.JOB_ID;
         v_row.MANAGER_ID :=
            v_row.MANAGER_ID + v_row.MANAGER_ID;
         v_row.HIRE_DATE :=
            v_row.HIRE_DATE + (v_row.HIRE_DATE - TRUNC (v_row.HIRE_DATE, 'YY'));
         v_row.SALARY :=
            v_row.SALARY + v_row.SALARY;
         v_row.COMMISSION :=
            v_row.COMMISSION + v_row.COMMISSION;
         v_row.DEPARTMENT_ID :=
            v_row.DEPARTMENT_ID + v_row.DEPARTMENT_ID;
         v_row.EMPNO :=
            v_row.EMPNO + v_row.EMPNO;
         v_row.ENAME :=
            SUBSTR (v_row.ENAME || v_row.ENAME, 1, 30);
         v_row.CREATED_BY :=
            SUBSTR (v_row.CREATED_BY || v_row.CREATED_BY, 1, 100);
         v_row.CREATED_ON :=
            v_row.CREATED_ON + (v_row.CREATED_ON - TRUNC (v_row.CREATED_ON, 'YY'));
         v_row.CHANGED_BY :=
            SUBSTR (v_row.CHANGED_BY || v_row.CHANGED_BY, 1, 100);
         v_row.CHANGED_ON :=
            v_row.CHANGED_ON + (v_row.CHANGED_ON - TRUNC (v_row.CHANGED_ON, 'YY'));

         te_employee.ins (v_row,
            TRUE
            );

          ROLLBACK;

         --// Try to reinsert same record with no-update option. //--
         te_employee.ins (v_row,
            FALSE
            );

          ROLLBACK;
       END LOOP;
   END ins;
   PROCEDURE upd (maxrows IN INTEGER := NULL)
   IS
      v_row EMPLOYEE%ROWTYPE;
      v_pky te_employee.pky_rt;
      v_LAST_NAME EMPLOYEE.LAST_NAME%TYPE;
      v_FIRST_NAME EMPLOYEE.FIRST_NAME%TYPE;
      v_MIDDLE_INITIAL EMPLOYEE.MIDDLE_INITIAL%TYPE;
      v_JOB_ID EMPLOYEE.JOB_ID%TYPE;
      v_MANAGER_ID EMPLOYEE.MANAGER_ID%TYPE;
      v_HIRE_DATE EMPLOYEE.HIRE_DATE%TYPE;
      v_SALARY EMPLOYEE.SALARY%TYPE;
      v_COMMISSION EMPLOYEE.COMMISSION%TYPE;
      v_DEPARTMENT_ID EMPLOYEE.DEPARTMENT_ID%TYPE;
      v_EMPNO EMPLOYEE.EMPNO%TYPE;
      v_ENAME EMPLOYEE.ENAME%TYPE;
      v_CREATED_BY EMPLOYEE.CREATED_BY%TYPE;
      v_CREATED_ON EMPLOYEE.CREATED_ON%TYPE;
      v_CHANGED_BY EMPLOYEE.CHANGED_BY%TYPE;
      v_CHANGED_ON EMPLOYEE.CHANGED_ON%TYPE;

      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
      v_rowcount INTEGER;
   BEGIN
      newset ('UPD: Update Processing', '*');

      FOR rec IN te_employee.allbypky_cur
      LOOP
         EXIT WHEN te_employee.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         --// Move primary key information to the PKY record. //--
         v_pky.employee_id := rec.EMPLOYEE_ID;

         newset ('UPD: Turn off all force fields with reset, update all NULLs');
         te_employee.reset$frc;
         te_employee.upd (
           rec.EMPLOYEE_ID,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);
         ROLLBACK;

         newset ('UPD: Turn on force fields, update all NULLs');
         te_employee.upd (
           rec.EMPLOYEE_ID,
           'a',
           'a',
           'a',
           1,
           1,
           SYSDATE,
           1,
           1,
           1,
           1,
           'a',
           'a',
           SYSDATE,
           'a',
           SYSDATE,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);

         ROLLBACK;

         newset ('UPD: Record-based Update');

         te_employee.upd (v_row,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);
      END LOOP;
   END upd;


   PROCEDURE del (maxrows IN INTEGER := NULL)
   IS
      v_pky te_employee.pky_rt;
      v_LAST_NAME EMPLOYEE.LAST_NAME%TYPE;
      v_FIRST_NAME EMPLOYEE.FIRST_NAME%TYPE;
      v_MIDDLE_INITIAL EMPLOYEE.MIDDLE_INITIAL%TYPE;
      v_JOB_ID EMPLOYEE.JOB_ID%TYPE;
      v_MANAGER_ID EMPLOYEE.MANAGER_ID%TYPE;
      v_HIRE_DATE EMPLOYEE.HIRE_DATE%TYPE;
      v_SALARY EMPLOYEE.SALARY%TYPE;
      v_COMMISSION EMPLOYEE.COMMISSION%TYPE;
      v_DEPARTMENT_ID EMPLOYEE.DEPARTMENT_ID%TYPE;
      v_EMPNO EMPLOYEE.EMPNO%TYPE;
      v_ENAME EMPLOYEE.ENAME%TYPE;
      v_CREATED_BY EMPLOYEE.CREATED_BY%TYPE;
      v_CREATED_ON EMPLOYEE.CREATED_ON%TYPE;
      v_CHANGED_BY EMPLOYEE.CHANGED_BY%TYPE;
      v_CHANGED_ON EMPLOYEE.CHANGED_ON%TYPE;
      v_rowcount INTEGER;

      PROCEDURE showcount (str IN VARCHAR2 := NULL) IS
      BEGIN
         SELECT COUNT(*) INTO v_rowcount
           FROM EMPLOYEE;

         DBMS_OUTPUT.PUT_LINE ('# of rows in table ' || str || ': ' || v_rowcount);
      END;
   BEGIN
      newset ('DEL: Delete Processing', '*');

      showcount ('before delete - individual fields');
      FOR rec IN te_employee.allbypky_cur
      LOOP
         EXIT WHEN te_employee.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);
         te_employee.del (
            rec.EMPLOYEE_ID,
            v_rowcount);
      END LOOP;
      showcount ('after delete');

      ROLLBACK;

      showcount ('before delete - by record');
      FOR rec IN te_employee.allbypky_cur
      LOOP
         EXIT WHEN te_employee.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);
            v_pky.employee_id := rec.EMPLOYEE_ID;
         te_employee.del (
            v_pky,
            v_rowcount);
      END LOOP;
      showcount ('after delete');

      ROLLBACK;

      IF norowset
      THEN
         showcount ('Delete "No Row"');
         te_employee.del (
            g_norow.EMPLOYEE_ID,
            v_rowcount);
         DBMS_OUTPUT.PUT_LINE ('Number of "no rows" deleted:' || v_rowcount);
      END IF;

   END;

   PROCEDURE load
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('LOAD: Pre-loading not performed for this table.');
   END;

END te_employee_tst;
/
