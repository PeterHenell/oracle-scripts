SET SERVEROUTPUT ON FORMAT WRAPPED

CREATE OR REPLACE PROCEDURE assoc_array_index_test (
   iterations_in IN PLS_INTEGER DEFAULT 10000
 , length_in IN PLS_INTEGER DEFAULT 100
)
IS
   TYPE by_integer_t IS TABLE OF employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   TYPE by_string_t IS TABLE OF employees%ROWTYPE
      INDEX BY VARCHAR2 (32767);

   l_int_index   by_integer_t;
   l_string_index    by_string_t;
   intidx_tmr      tmr_t             := tmr_t.make ('By Integer', iterations_in);
   stridx_tmr       tmr_t             := tmr_t.make ('By String', iterations_in);
   l_salary    NUMBER;
BEGIN
   DBMS_OUTPUT.put_line
                     (   'Compare String and Integer Indexing, Iterations = '
                      || iterations_in
                      || ' Length = '
                      || length_in
                     );

   FOR rec IN (SELECT *
                 FROM employees)
   LOOP
      l_int_index (rec.employee_id) := rec;
   END LOOP;

   FOR rec IN (SELECT *
                 FROM employees)
   LOOP
      l_string_index (RPAD (rec.last_name, length_in, 'x')) := rec;
   END LOOP;

   intidx_tmr.go;

   FOR indx IN 1 .. iterations_in
   LOOP
      FOR rec IN (SELECT *
                    FROM employees)
      LOOP
         l_salary := l_int_index (rec.employee_id).salary;
      END LOOP;
   END LOOP;

   intidx_tmr.STOP;
   --
   stridx_tmr.go;

   FOR indx IN 1 .. iterations_in
   LOOP
      FOR rec IN (SELECT *
                    FROM employees)
      LOOP
         l_salary := l_string_index (RPAD (rec.last_name, length_in, 'x')).salary;
      END LOOP;
   END LOOP;

   stridx_tmr.STOP;
END assoc_array_index_test;
/

BEGIN
   assoc_array_index_test (10000, 10);
   assoc_array_index_test (10000, 100);
   assoc_array_index_test (10000, 1000);
   assoc_array_index_test (10000, 10000);
/*
On 11.2

Compare String and Integer Indexing, Iterations = 10000 Length = 10
Timings in seconds for "By Integer":
Elapsed = 2.69 - per rep .000269
CPU     = 2.66 - per rep .000266
Timings in seconds for "By String":
Elapsed = 3.03 - per rep .000303
CPU     = 2.98 - per rep .000298

Compare String and Integer Indexing, Iterations = 10000 Length = 100
Timings in seconds for "By Integer":
Elapsed = 2.72 - per rep .000272
CPU     = 2.69 - per rep .000269
Timings in seconds for "By String":
Elapsed = 3.13 - per rep .000313
CPU     = 3.09 - per rep .000309

Compare String and Integer Indexing, Iterations = 10000 Length = 1000
Timings in seconds for "By Integer":
Elapsed = 2.67 - per rep .000267
CPU     = 2.65 - per rep .000265
Timings in seconds for "By String":
Elapsed = 4.33 - per rep .000433
CPU     = 4.23 - per rep .000423

Compare String and Integer Indexing, Iterations = 10000 Length = 10000
Timings in seconds for "By Integer":
Elapsed = 2.68 - per rep .000268
CPU     = 2.66 - per rep .000266
Timings in seconds for "By String":
Elapsed = 15.96 - per rep .001596
CPU     = 15.78 - per rep .001578

*/
END;
/