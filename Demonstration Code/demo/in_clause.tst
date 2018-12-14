/*
Must first run:

in_clause_setup.sql
in_clause.pks
in_clause.pkb

*/

DECLARE
   iterations_in BINARY_INTEGER;
   show_timing_in BOOLEAN;
   show_data_in BOOLEAN;
BEGIN
   iterations_in := 1000;
   show_timing_in := TRUE;
   show_data_in := FALSE;
   in_clause.test_varieties(
                             iterations_in,
                             '1,2,3,4,5,6',
                             show_timing_in,
                             show_data_in
   );


   COMMIT;
END;
/

/* MEMBER OF still slow in 11 

Output from NDS_LIST
  Elapsed CPU time: 115
Output from NDS_BULK_LIST
  Elapsed CPU time: 114
Output from NDS_BULK_LIST2
  Elapsed CPU time: 126
Output from DBMS_SQL_LIST
  Elapsed CPU time: 130
Output from NESTED_TABLE_LIST
  Elapsed CPU time: 109
Output from NESTED_TABLE_LIST - Join
  Elapsed CPU time: 109
Output from MEMBER_OF_LIST
  Elapsed CPU time: 437
Output from STATIC_IN_LIST
  Elapsed CPU time: 142
Output from STATIC_IN_LIST_SMALL(50)
  Elapsed CPU time: 139
  
*/