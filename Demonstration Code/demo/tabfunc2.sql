/* Formatted on 2002/01/04 15:51 (Formatter Plus v4.5.2) */
CREATE TYPE lookup_row AS OBJECT (
   idx                           NUMBER,
   text                          VARCHAR2 (20));
/
   
CREATE TYPE lookups_tab AS TABLE OF lookup_row;
/

CREATE OR REPLACE FUNCTION lookups_fn RETURN lookups_tab
/*
Code designed by Bryn Llewellyn of Oracle Corporation
*/   
IS
   v_table   lookups_tab;
BEGIN
   /*
   To extend a nested table, you must use the built-in procedure EXTEND,
   but to extend an index-by table, you just specify larger subscripts.
   */
   v_table := lookups_tab (lookup_row (1, 'ONE'));

   FOR j IN 2 .. 9
   LOOP
      v_table.EXTEND;

      IF j = 2
      THEN
         v_table (j) := lookup_row (2, 'two');
      ELSIF j = 3
      THEN
         v_table (j) := lookup_row (3, 'THREE');
      ELSIF j = 4
      THEN
         v_table (j) := lookup_row (4, 'four');
      ELSIF j = 5
      THEN
         v_table (j) := lookup_row (5, 'FIVE');
      ELSIF j = 6
      THEN
         v_table (j) := lookup_row (6, 'six');
      ELSIF j = 7
      THEN
         v_table (j) := lookup_row (7, 'SEVEN');
      ELSE
         v_table (j) := lookup_row (j, 'other');
      END IF;
   END LOOP;

   RETURN v_table;
END lookups_fn;
/

SELECT * FROM TABLE ( CAST ( Lookups_Fn() AS lookups_tab ) );