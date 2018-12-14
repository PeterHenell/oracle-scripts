SET SERVEROUTPUT ON FORMAT WRAPPED

CREATE OR REPLACE PROCEDURE first_last_vs_indices_of_test (
   list_size_in IN PLS_INTEGER DEFAULT 10000
)
IS
   TYPE ids_aat IS TABLE OF employees.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   l_ids    ids_aat;
   fl_tmr   tmr_t   := tmr_t.make ('FIRST to LAST', 1);
   iotmr    tmr_t   := tmr_t.make ('INDICES OF', 1);
BEGIN
   DBMS_OUTPUT.put_line
      (   'Compare FORALL with FIRST to LAST and INDICES OF with list size = '
       || list_size_in
      );

   FOR indx IN 1 .. list_size_in
   LOOP
      l_ids (indx) := 137;
   END LOOP;

   fl_tmr.go;
   FORALL upd_index IN l_ids.FIRST .. l_ids.LAST
      UPDATE employees
         SET salary = 10000
       WHERE employee_id = l_ids (upd_index);
   fl_tmr.STOP;
   --
   iotmr.go;
   FORALL upd_index IN INDICES OF l_ids
      UPDATE employees
         SET salary = 10000
       WHERE employee_id = l_ids (upd_index);
   iotmr.STOP;
END first_last_vs_indices_of_test;
/

BEGIN
   first_last_vs_indices_of_test (10000);
   -- TAKES AT LEAST FIVE MINUTES! first_last_vs_indices_of_test (100000);
/*
Compare FORALL with FIRST to LAST and INDICES OF with list size = 10000

Timings in seconds for "FIRST to LAST":
Elapsed  = .56
CPU      = .49

Timings in seconds for "INDICES OF":
Elapsed  = .46
CPU      = .45
*/
   
END;
/