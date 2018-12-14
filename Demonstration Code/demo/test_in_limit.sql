CREATE OR REPLACE PROCEDURE test_in_limit (
   table_in        IN   VARCHAR2
  ,int_column_in   IN   VARCHAR2
  ,limit_in        IN   PLS_INTEGER
)
IS
   v_sql   VARCHAR (32767);
   i integer;
BEGIN
   v_sql :=
         'SELECT ' || int_column_in || ' FROM ' || table_in ||
         ' WHERE ' || int_column_in || ' IN (1';

   FOR indx IN 2 .. limit_in
   LOOP

         v_sql := v_sql || ',' || indx;
   END LOOP;

   v_sql := v_sql || ')';

   EXECUTE IMMEDIATE v_sql into i;
END test_in_limit;
/

BEGIN
   test_in_limit ('sg_script', 'id', 1001);
END;
/
