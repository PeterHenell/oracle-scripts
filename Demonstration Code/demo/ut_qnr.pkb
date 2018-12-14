CREATE OR REPLACE PACKAGE BODY ut_qnr
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_name_resolve
   IS
      l_results   Qnr.name_resolve_rt;
   BEGIN
      FOR tc IN (SELECT *
                   FROM qnr_testcase)
      LOOP
         Qnr.name_resolve (tc.object_name
                          ,l_results.SCHEMA
                          ,l_results.part1
                          ,l_results.part2
                          ,l_results.dblink
                          ,l_results.part1_type
                          ,l_results.object_number
                          );
         utassert.eq (tc.NAME || '-Schema', l_results.SCHEMA, tc.SCHEMA);
         utassert.eq (tc.NAME || '-Part1'
                     ,l_results.part1
                     ,tc.part1
                     ,null_ok_in      => TRUE
                     );
         utassert.eq (tc.NAME || '-Part2'
                     ,l_results.part2
                     ,tc.part2
                     ,null_ok_in      => TRUE
                     );
         utassert.eq (tc.NAME || '-Dblink'
                     ,l_results.dblink
                     ,tc.dblink
                     ,null_ok_in      => TRUE
                     );
         utassert.eq (tc.NAME || '-Part1_type'
                     ,l_results.part1_type
                     ,tc.part1_type
                     );
      END LOOP;
   END ut_name_resolve;
END ut_qnr;
/