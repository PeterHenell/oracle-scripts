CREATE TABLE dmr_table_copy AS SELECT * FROM dmr_table WHERE 1 = 2
/

CREATE OR REPLACE PROCEDURE test_delete_mult_rows (
   low_in IN PLS_INTEGER
 , high_in IN PLS_INTEGER
)
IS
   PROCEDURE initialize
   IS
   BEGIN
      INSERT INTO dmr_table_copy
         SELECT *
           FROM dmr_table
          WHERE n NOT BETWEEN low_in AND high_in;
   END initialize;

   PROCEDURE compare_tables
   IS
      CV         sys_refcursor;
      l_return   PLS_INTEGER;
   BEGIN
      OPEN CV FOR
         SELECT 1
           FROM DUAL
          WHERE EXISTS (
                   ((SELECT *
                       FROM dmr_table_copy)
                    MINUS
                    (SELECT *
                       FROM dmr_table))
                   UNION ALL
                   ((SELECT *
                       FROM dmr_table)
                    MINUS
                    (SELECT *
                       FROM dmr_table_copy)));

      FETCH CV
       INTO l_return;

      IF CV%NOTFOUND
      THEN
         DBMS_OUTPUT.put_line
                          (   'DELETE_MULT_ROWS succeeded for low and high: '
                           || low_in
                           || '-'
                           || high_in
                          );
      ELSE
         DBMS_OUTPUT.put_line
                             (   'DELETE_MULT_ROWS failed for low and high: '
                              || low_in
                              || '-'
                              || high_in
                             );
      END IF;
   END compare_tables;
BEGIN
   initialize ();
   --
   delete_mult_rows (low_in, high_in);
   --
   compare_tables ();
END test_delete_mult_rows;