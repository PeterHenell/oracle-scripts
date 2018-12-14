spool aa_vs_nt.log

connect hr/hr

set serveroutput on

DECLARE
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
                            INDEX BY PLS_INTEGER;

   l_aat   employees_aat;

   TYPE employees_nt IS TABLE OF employees%ROWTYPE;

   l_nt    employees_nt;

   PROCEDURE start_test (t VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (t);
      DBMS_SESSION.free_unused_user_memory;
      plsql_memory.start_analysis;
      sf_timer.start_timer;
   END;
BEGIN
   start_test ('Associative memory');

   SELECT e1.*
     BULK COLLECT INTO l_aat
     FROM employees, employees, employees e1;

   DBMS_OUTPUT.put_line (l_aat.COUNT);
   sf_timer.show_elapsed_time;
   plsql_memory.show_memory_usage;
   l_aat.delete;
END;
/

connect hr/hr

set serveroutput on

DECLARE
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
                            INDEX BY PLS_INTEGER;

   l_aat   employees_aat;

   TYPE employees_nt IS TABLE OF employees%ROWTYPE;

   l_nt    employees_nt;

   PROCEDURE start_test (t VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (t);
      DBMS_SESSION.free_unused_user_memory;
      plsql_memory.start_analysis;
      sf_timer.start_timer;
   END;
BEGIN
   start_test ('Nested table');

   SELECT e1.*
     BULK COLLECT INTO l_nt
     FROM employees, employees, employees e1;

   DBMS_OUTPUT.put_line (l_nt.COUNT);
   sf_timer.show_elapsed_time;
   plsql_memory.show_memory_usage;
END;
/

spool off

/*
First run:

SQL> @c:\work\demo-seminar\aa_vs_nt
Connected.

Associative memory
1225043
- Elapsed CPU : 2.46 seconds.
Change in UGA memory: 65512 (Current = 373096)
Change in PGA memory: 485556224 (Current = 487133412)

PL/SQL procedure successfully completed.

Connected.

Nested table
1225043
- Elapsed CPU : 2.59 seconds.
Change in UGA memory: 65512 (Current = 373096)
Change in PGA memory: 485490688 (Current = 486150372)

Second run:

SQL> @c:\work\demo-seminar\aa_vs_nt
Connected.
Associative memory
1225043
- Elapsed CPU : 3.02 seconds.
Change in UGA memory: 65512 (Current = 373096)
Change in PGA memory: 485490688 (Current = 486150372)

PL/SQL procedure successfully completed.

Connected.
Nested table
1225043
- Elapsed CPU : 2.82 seconds.
Change in UGA memory: 65512 (Current = 373096)
Change in PGA memory: 485490688 (Current = 486150372)
*/