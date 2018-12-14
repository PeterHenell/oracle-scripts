CREATE OR REPLACE PACKAGE BODY te_emp_tst
IS
   g_norow EMP%ROWTYPE;
   g_norow_set BOOLEAN := FALSE;

   -- Display header for a new set of information.
   PROCEDURE newset (str IN VARCHAR2, gr IN VARCHAR2 := '=') IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE (RPAD (gr, 60, gr));
      DBMS_OUTPUT.PUT_LINE (str);
      DBMS_OUTPUT.PUT_LINE (RPAD (gr, 60, gr));
   END;

   -- Show the contents of a table record.
   PROCEDURE showrow (row_in IN EMP%ROWTYPE) IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('**COL EMPNO: ' || row_in.EMPNO);
      DBMS_OUTPUT.PUT_LINE ('**COL ENAME: ' || row_in.ENAME);
      DBMS_OUTPUT.PUT_LINE ('**COL JOB: ' || row_in.JOB);
      DBMS_OUTPUT.PUT_LINE ('**COL MGR: ' || row_in.MGR);
      DBMS_OUTPUT.PUT_LINE ('**COL HIREDATE: ' || row_in.HIREDATE);
      DBMS_OUTPUT.PUT_LINE ('**COL SAL: ' || row_in.SAL);
      DBMS_OUTPUT.PUT_LINE ('**COL COMM: ' || row_in.COMM);
      DBMS_OUTPUT.PUT_LINE ('**COL DEPTNO: ' || row_in.DEPTNO);
   END;

   -- Sets contents of record that does NOT match a row in the database table.
   PROCEDURE set_norow (
      empno_in IN EMP.EMPNO%TYPE
      ,ename_in IN EMP.ENAME%TYPE DEFAULT NULL
      ,job_in IN EMP.JOB%TYPE DEFAULT NULL
      ,mgr_in IN EMP.MGR%TYPE DEFAULT NULL
      ,hiredate_in IN EMP.HIREDATE%TYPE DEFAULT NULL
      ,sal_in IN EMP.SAL%TYPE DEFAULT NULL
      ,comm_in IN EMP.COMM%TYPE DEFAULT NULL
      ,deptno_in IN EMP.DEPTNO%TYPE DEFAULT NULL
      )
   IS
   BEGIN
      newset ('Defining "No Row" Values for Primary and Foreign Keys');
      g_norow.EMPNO := empno_in;
      g_norow.ENAME := ename_in;
      g_norow.JOB := job_in;
      g_norow.MGR := mgr_in;
      g_norow.HIREDATE := hiredate_in;
      g_norow.SAL := sal_in;
      g_norow.COMM := comm_in;
      g_norow.DEPTNO := deptno_in;
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
      v_row EMP%ROWTYPE;

      --// Test record structures and functions to retrieve rows. --//
      v_pky te_emp.pky_rt;
   BEGIN
      newset ('Unique Index-Related Fetch Activity', '*');

      -- Exercise "by primary key" cursor
      FOR rec IN te_emp.allbypky_cur
      LOOP
         EXIT WHEN te_emp.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         -- Perform a lookup based on the primary key values.
      END LOOP;
   END uind;

   PROCEDURE pky (maxrows IN INTEGER := NULL)
   IS
      v_row te_emp.allforpky_cur%ROWTYPE;

      v_pky te_emp.pky_rt;

   BEGIN
      newset ('Primary Key-Related Activity', '*');

      -- Use the by primary key cursor.
      FOR rec IN te_emp.allbypky_cur
      LOOP
         EXIT WHEN te_emp.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         newset ('Cursor by primary key');

         -- Open the cursor for the current primary key and fetch the row
         -- it identifies.

         OPEN te_emp.allforpky_cur (
            rec.EMPNO
            );

         FETCH te_emp.allforpky_cur INTO v_row;

         DBMS_OUTPUT.PUT_LINE ('**PKY EMPNO: ' || v_row.EMPNO);

         IF te_emp.allforpky_cur%NOTFOUND
         THEN
            DBMS_OUTPUT.PUT_LINE ('!! Row not found for primary key.');
         ELSE
            DBMS_OUTPUT.PUT_LINE ('Row found for primary key');
            DBMS_OUTPUT.PUT_LINE ('**COL ENAME: ' || v_row.ENAME);
            DBMS_OUTPUT.PUT_LINE ('**COL JOB: ' || v_row.JOB);
            DBMS_OUTPUT.PUT_LINE ('**COL MGR: ' || v_row.MGR);
            DBMS_OUTPUT.PUT_LINE ('**COL HIREDATE: ' || v_row.HIREDATE);
            DBMS_OUTPUT.PUT_LINE ('**COL SAL: ' || v_row.SAL);
            DBMS_OUTPUT.PUT_LINE ('**COL COMM: ' || v_row.COMM);
            DBMS_OUTPUT.PUT_LINE ('**COL DEPTNO: ' || v_row.DEPTNO);
         END IF;

         -- Close the cursor.
         te_emp.close_allforpky_cur;

      END LOOP;
   END pky;

   -- Test FKY related functionality.
   PROCEDURE fky (maxrows IN INTEGER := NULL)
   IS
      v_pky EMP.empno%TYPE;
      -- Declare a cursor to obtain distinct foreign key values in the table.
      CURSOR fk_deptno_all_cur
      IS
         SELECT DISTINCT
             DEPTNO
           FROM EMP;
   BEGIN
      newset ('Foreign Key-Related Activity', '*');

      -- For each value in this foreign key cursor...
      FOR Orec IN fk_deptno_all_cur
      LOOP
         EXIT WHEN fk_deptno_all_cur%ROWCOUNT > NVL (maxrows, 5);
         newset ('Retrieve Data for Foreign Key fk_deptno');
         DBMS_OUTPUT.PUT_LINE ('**FKY DEPTNO: ' || Orec.DEPTNO);
         -- Display all records identified for that foreign key.
         FOR Irec IN te_emp.fk_deptno_all_cur (
            Orec.DEPTNO
            )
         LOOP
            IF te_emp.fk_deptno_all_cur%ROWCOUNT > NVL (maxrows, 5)
            THEN
               --// Test close cursor program and then exit. --//
               te_emp.close_fk_deptno_all_cur;
               EXIT;
            ELSE
               showrow (Irec);
            END IF;
         END LOOP;
      END LOOP;
   END fky;

   -- Test lookup functionality
   PROCEDURE lookups (maxrows IN INTEGER := NULL)
   IS
      v_row EMP%ROWTYPE;

   BEGIN
      newset ('Retrieve one row at a time.', '*');

      FOR rec IN te_emp.allbypky_cur
      LOOP
         EXIT WHEN te_emp.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         newset ('Retrieve and display row and desc columns for primary key.');

         DBMS_OUTPUT.PUT_LINE ('**PKY EMPNO: ' || rec.EMPNO);

         -- Use onerow function to lookup row for this primary key value.
         v_row := te_emp.onerow (
            rec.EMPNO
            );

         IF NOT te_emp.isnullpky (v_row)
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
      v_row EMP%ROWTYPE;
      v_valuesOK BOOLEAN;
      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('No check constraints to validate.');
   END validate;

   -- Test insert activity.
   PROCEDURE ins (maxrows IN INTEGER := NULL)
   IS
      v_row EMP%ROWTYPE;
      v_pky te_emp.pky_rt;
      v_pkycol INTEGER;
      v_nxtpky INTEGER;

      --// Variable for every primary key column //--
      v_EMPNO EMP.EMPNO%TYPE;

      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
   BEGIN
      newset ('INS: function-based record init');
      v_row := te_emp.initrec;
      showrow (v_row);

      newset ('INS: procedure-based record init');
      te_emp.initrec (v_row);
      showrow (v_row);

      ROLLBACK;

      newset ('INS: Pass in primary key');

      te_emp.ins (
         v_EMPNO,
         SUBSTR ('ENAME', 1, 10),
         SUBSTR ('JOB', 1, 9),
         22,
         SYSDATE,
         22,
         22,
         22,
         FALSE
         );

      ROLLBACK;

      newset ('INS: Record-based insert');

      --// Populate the row! //--
      te_emp.ins (v_row,
         FALSE
         );

      ROLLBACK;
      FOR rec IN te_emp.allbypky_cur
      LOOP
         EXIT WHEN te_emp.allbypky_cur%ROWCOUNT > 1;

         --// Move primary key information to the PKY record. //--
         v_pky.empno := rec.EMPNO;

         --// Try to reinsert same record with update-on-dup option. //--
         --// Double all nonprimary key column values. //--
         v_row.ENAME :=
            SUBSTR (v_row.ENAME || v_row.ENAME, 1, 10);
         v_row.JOB :=
            SUBSTR (v_row.JOB || v_row.JOB, 1, 9);
         v_row.MGR :=
            v_row.MGR + v_row.MGR;
         v_row.HIREDATE :=
            v_row.HIREDATE + (v_row.HIREDATE - TRUNC (v_row.HIREDATE, 'YY'));
         v_row.SAL :=
            v_row.SAL + v_row.SAL;
         v_row.COMM :=
            v_row.COMM + v_row.COMM;
         v_row.DEPTNO :=
            v_row.DEPTNO + v_row.DEPTNO;

         te_emp.ins (v_row,
            TRUE
            );

          ROLLBACK;

         --// Try to reinsert same record with no-update option. //--
         te_emp.ins (v_row,
            FALSE
            );

          ROLLBACK;
       END LOOP;
   END ins;
   PROCEDURE upd (maxrows IN INTEGER := NULL)
   IS
      v_row EMP%ROWTYPE;
      v_pky te_emp.pky_rt;
      v_ENAME EMP.ENAME%TYPE;
      v_JOB EMP.JOB%TYPE;
      v_MGR EMP.MGR%TYPE;
      v_HIREDATE EMP.HIREDATE%TYPE;
      v_SAL EMP.SAL%TYPE;
      v_COMM EMP.COMM%TYPE;
      v_DEPTNO EMP.DEPTNO%TYPE;

      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
      v_rowcount INTEGER;
   BEGIN
      newset ('UPD: Update Processing', '*');

      FOR rec IN te_emp.allbypky_cur
      LOOP
         EXIT WHEN te_emp.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         --// Move primary key information to the PKY record. //--
         v_pky.empno := rec.EMPNO;

         newset ('UPD: Turn off all force fields with reset, update all NULLs');
         te_emp.reset$frc;
         te_emp.upd (
           rec.EMPNO,
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
         te_emp.upd (
           rec.EMPNO,
           'a',
           'a',
           1,
           SYSDATE,
           1,
           1,
           1,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);

         ROLLBACK;

         newset ('UPD: Record-based Update');

         te_emp.upd (v_row,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);
      END LOOP;
   END upd;


   PROCEDURE del (maxrows IN INTEGER := NULL)
   IS
      v_pky te_emp.pky_rt;
      v_ENAME EMP.ENAME%TYPE;
      v_JOB EMP.JOB%TYPE;
      v_MGR EMP.MGR%TYPE;
      v_HIREDATE EMP.HIREDATE%TYPE;
      v_SAL EMP.SAL%TYPE;
      v_COMM EMP.COMM%TYPE;
      v_DEPTNO EMP.DEPTNO%TYPE;
      v_rowcount INTEGER;

      PROCEDURE showcount (str IN VARCHAR2 := NULL) IS
      BEGIN
         SELECT COUNT(*) INTO v_rowcount
           FROM EMP;

         DBMS_OUTPUT.PUT_LINE ('# of rows in table ' || str || ': ' || v_rowcount);
      END;
   BEGIN
      newset ('DEL: Delete Processing', '*');

      showcount ('before delete - individual fields');
      FOR rec IN te_emp.allbypky_cur
      LOOP
         EXIT WHEN te_emp.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);
         te_emp.del (
            rec.EMPNO,
            v_rowcount);
      END LOOP;
      showcount ('after delete');

      ROLLBACK;

      showcount ('before delete - by record');
      FOR rec IN te_emp.allbypky_cur
      LOOP
         EXIT WHEN te_emp.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);
            v_pky.empno := rec.EMPNO;
         te_emp.del (
            v_pky,
            v_rowcount);
      END LOOP;
      showcount ('after delete');

      ROLLBACK;

      IF norowset
      THEN
         showcount ('Delete "No Row"');
         te_emp.del (
            g_norow.EMPNO,
            v_rowcount);
         DBMS_OUTPUT.PUT_LINE ('Number of "no rows" deleted:' || v_rowcount);
      END IF;

   END;

   PROCEDURE load
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('LOAD: Pre-loading not performed for this table.');
   END;

END te_emp_tst;
/
