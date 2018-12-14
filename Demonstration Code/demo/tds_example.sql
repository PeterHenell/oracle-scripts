PROCEDURE load_cache
IS
   /* Zagreb Sept 2007 - move temp cache to local procedure. */
   temp_employee_cache   employee_tt;

   CURSOR lots_of_cols_cur
   IS
      SELECT *
        FROM employees e, departments d, locations e1;

   TYPE lots_of_cols_cur_t
   IS
      TABLE OF lots_of_cols_cur%ROWTYPE
         INDEX BY pls_integer;

   l_all_cols            lots_of_cols_cur_t;
BEGIN
   OPEN lots_of_cols_cur;

   FETCH lots_of_cols_cur BULK COLLECT INTO l_all_cols;

   CLOSE lots_of_cols_cur;
END load_cache;