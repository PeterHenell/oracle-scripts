CREATE OR REPLACE PACKAGE employees_cache
/*
Generated by the genaa utility - genaa.sql.

Then enhanced to demonstrate an auto-refresh capability:

The cache should never persist over a day. Employee information
is updated/reloaded each evening.
*/
IS
   FUNCTION onerow (employee_id_in IN hr.employees.employee_id%TYPE)
      RETURN hr.employees%ROWTYPE;

   FUNCTION onerow_by_emp_email_uk (email_in IN hr.employees.email%TYPE)
      RETURN hr.employees%ROWTYPE;

   PROCEDURE test_caching (override_ts_in IN VARCHAR2 DEFAULT NULL);

   PROCEDURE set_trace (tracing_in IN BOOLEAN);
END employees_cache;
/

CREATE OR REPLACE PACKAGE BODY employees_cache
IS
   g_trace            BOOLEAN          DEFAULT FALSE;
   g_last_load        VARCHAR2 (8);

   /* The main cache: each element is a full row from the table. */
   TYPE employees_aat IS TABLE OF hr.employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   emp_emp_id_pk_aa   employees_aat;

   /* The emulated index cache: each element is the index value (primary key)
      in the main cache. */
   TYPE emp_email_uk_aat IS TABLE OF hr.employees.employee_id%TYPE
      INDEX BY hr.employees.email%TYPE;

   emp_email_uk_aa    emp_email_uk_aat;

   PROCEDURE set_trace (tracing_in IN BOOLEAN)
   IS
   BEGIN
      g_trace := tracing_in;
   END set_trace;

   FUNCTION cache_ts
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN TO_CHAR (SYSDATE, 'YYYYMMDD');
   END cache_ts;

   PROCEDURE load_arrays
   IS
   BEGIN
      IF g_last_load IS NULL OR g_last_load <> cache_ts ()
      THEN
         g_last_load := cache_ts ();

         IF g_trace
         THEN
            DBMS_OUTPUT.put_line ('>> Reloading cache at ' || g_last_load);
         END IF;

         FOR rec IN (SELECT *
                       FROM hr.employees)
         LOOP
            emp_emp_id_pk_aa (rec.employee_id) := rec;
            emp_email_uk_aa (rec.email) := rec.employee_id;
         END LOOP;

         IF g_trace
         THEN
            DBMS_OUTPUT.put_line ('>> Cache count = ' || emp_emp_id_pk_aa.COUNT);
         END IF;
      END IF;
   END load_arrays;

   FUNCTION onerow (employee_id_in IN hr.employees.employee_id%TYPE)
      RETURN hr.employees%ROWTYPE
   IS
   BEGIN
      load_arrays;
      RETURN emp_emp_id_pk_aa (employee_id_in);
   END;

   FUNCTION onerow_by_emp_email_uk (email_in IN hr.employees.email%TYPE)
      RETURN hr.employees%ROWTYPE
   IS
   BEGIN
      load_arrays;
      RETURN emp_emp_id_pk_aa (emp_email_uk_aa (email_in));
   END;

   PROCEDURE test_caching (override_ts_in IN VARCHAR2 DEFAULT NULL)
   IS
      pky_rec               hr.employees%ROWTYPE;
      emp_email_uk_aa_rec   hr.employees%ROWTYPE;
   BEGIN
      IF override_ts_in IS NOT NULL
      THEN
         g_last_load := override_ts_in;
      END IF;

      load_arrays;

      FOR rec IN (SELECT *
                    FROM hr.employees)
      LOOP
         pky_rec := onerow (rec.employee_id);
         emp_email_uk_aa_rec := onerow_by_emp_email_uk (rec.email);

         IF rec.employee_id = emp_email_uk_aa_rec.employee_id
         THEN
            NULL;
            /* Only display if there is a problem.
            DBMS_OUTPUT.put_line
                                (   'EMP_EMAIL_UK lookup OK for employee ID '
                                 || rec.employee_id
                                );*/
         ELSE
            DBMS_OUTPUT.put_line
                                (   'EMP_EMAIL_UK lookup NOT OK for employee ID '
                                 || rec.employee_id
                                );
         END IF;
      END LOOP;
   END test_caching;
END employees_cache;
/