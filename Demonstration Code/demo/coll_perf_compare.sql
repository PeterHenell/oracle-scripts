/* Original version from JHall62 / PL/SQL Challenge 
*/
DECLARE
   TYPE aa_t IS TABLE OF VARCHAR2 (30)
                   INDEX BY PLS_INTEGER;

   TYPE nested_table_t IS TABLE OF VARCHAR2 (30);

   TYPE varray_t IS VARRAY (1000000) OF VARCHAR2 (30);

   test_nested_table         nested_table_t;
   copy_nested_table         nested_table_t;
   nested_table_times        SYS.DBMS_SQL.interval_day_to_second_table;
   total_nested_table_time   dsinterval_unconstrained;
   --
   test_varray               varray_t;
   copy_varray               varray_t;
   varray_times              SYS.DBMS_SQL.interval_day_to_second_table;
   total_varray_time         dsinterval_unconstrained;
   --
   test_aa                   aa_t;
   copy_aa                   aa_t;
   aa_times                  SYS.DBMS_SQL.interval_day_to_second_table;
   total_aa_time             dsinterval_unconstrained;
   --
   start_ts                  timestamp_unconstrained;
   end_ts                    timestamp_unconstrained;
BEGIN
   test_nested_table := nested_table_t ();
   test_nested_table.EXTEND (1000000);
   test_varray := varray_t ();
   test_varray.EXTEND (1000000);

   FOR i IN 1 .. 1000000
   LOOP
      test_nested_table (i) := TO_CHAR (i, 'TM');
      test_varray (i) := test_nested_table (i);
      test_aa (i) := test_nested_table (i);
   END LOOP;

   FOR i IN 1 .. 10
   LOOP
      sys.DBMS_SESSION.free_unused_user_memory;
      start_ts := SYSTIMESTAMP;
      copy_nested_table := nested_table_t ();
      copy_nested_table.EXTEND (test_nested_table.COUNT);

      FOR n IN 1 .. test_nested_table.COUNT
      LOOP
         copy_nested_table (n) := test_nested_table (n);
      END LOOP;

      end_ts := SYSTIMESTAMP;
      nested_table_times (i) := end_ts - start_ts;
      --
      sys.DBMS_SESSION.free_unused_user_memory;
      start_ts := SYSTIMESTAMP;
      copy_varray := varray_t ();
      copy_varray.EXTEND (test_varray.COUNT);

      FOR n IN 1 .. test_varray.COUNT
      LOOP
         copy_varray (n) := test_varray (n);
      END LOOP;

      end_ts := SYSTIMESTAMP;
      varray_times (i) := end_ts - start_ts;
      --
      sys.DBMS_SESSION.free_unused_user_memory;
      start_ts := SYSTIMESTAMP;

      FOR n IN 1 .. test_aa.COUNT
      LOOP
         copy_aa (n) := test_aa (n);
      END LOOP;

      end_ts := SYSTIMESTAMP;
      aa_times (i) := end_ts - start_ts;
   END LOOP;

   total_nested_table_time := INTERVAL '0' DAY;
   total_varray_time := INTERVAL '0' DAY;
   total_aa_time := INTERVAL '0' DAY;
   sys.DBMS_OUTPUT.put_line ('Nested Table Time, VARRAY Time, AA Time');

   FOR i IN 1 .. nested_table_times.COUNT
   LOOP
      total_nested_table_time :=
         total_nested_table_time + nested_table_times (i);
      total_varray_time := total_varray_time + varray_times (i);
      total_aa_time := total_aa_time + aa_times (i);
      sys.DBMS_OUTPUT.
       put_line (
            nested_table_times (i)
         || ', '
         || varray_times (i)
         || ', '
         || aa_times (i));
   END LOOP;

   sys.DBMS_OUTPUT.put_line (' ');
   sys.DBMS_OUTPUT.
    put_line (
         (total_nested_table_time)
      || ', '
      || (total_varray_time)
      || ', '
      || (total_aa_time)
      || ' Total');
END;
/