CREATE OR REPLACE PACKAGE BODY employee_bidir
IS
   g_curr_index   PLS_INTEGER := NULL;

   TYPE employee_tt IS TABLE OF employee%ROWTYPE
      INDEX BY PLS_INTEGER;

   employees      employee_tt;

   PROCEDURE assert (
      condition_in IN BOOLEAN
     ,msg_in IN VARCHAR2
   )
   IS
   BEGIN
      IF NOT (NVL (condition_in, FALSE))
      THEN
         DBMS_OUTPUT.put_line (msg_in);
         RAISE PROGRAM_ERROR;
      END IF;
   END assert;

   PROCEDURE load_cache
   IS
      temp_cache   employee_tt;
      l_row        PLS_INTEGER;
   BEGIN
      employees.DELETE;

      SELECT *
      BULK COLLECT INTO temp_cache
        FROM employee;

      l_row := temp_cache.FIRST;

      WHILE (l_row IS NOT NULL)
      LOOP
         employees (temp_cache (l_row).employee_id) := temp_cache (l_row);
         l_row := temp_cache.NEXT (l_row);
      END LOOP;

      temp_cache.DELETE;
      g_curr_index := employees.FIRST;
   END load_cache;

   /*FUNCTION index_row (
      index_in IN PLS_INTEGER
   )
      RETURN employee%rowtype
   IS
      l_row_in   PLS_INTEGER             := 0;
      l_row      PLS_INTEGER;
      retval     employee%rowtype;
   BEGIN
      if index_in = 0 then
     -- nothing to do.
     null;
     elsif abc (index_in) > employees.count
     then
     -- set to the count
     index_in < 0
     then
     l_direction
      IF direction_in = 1
      THEN
         l_row := employees.FIRST;
      ELSIF direction_in = -1
      THEN
         l_row := employees.LAST;
      ELSE
         RAISE VALUE_ERROR;
      END IF;

      LOOP
        -- index_in must be out of range.
         EXIT WHEN l_row IS NULL;

         IF l_row_in = index_in
         THEN
            retval := employees (l_row);
            EXIT;
         ELSE
            l_row_in := l_row_in + 1;

            IF direction_in = 1
            THEN
               l_row := employees.NEXT (l_row);
            ELSE
               l_row := employees.PRIOR (l_row);
            END IF;
         END IF;
      END LOOP;

      RETURN retval;
   END;
   */
   PROCEDURE set_row (
      index_in IN PLS_INTEGER
   )
   IS
   BEGIN
      assert (index_in BETWEEN employees.FIRST AND employees.LAST
             ,'init_curr_row: specified index is outside of range.'
             );
      g_curr_index := index_in;
   END set_row;

   FUNCTION row_found
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_curr_index IS NOT NULL;
   END row_found;

   FUNCTION current_row
      RETURN employee%ROWTYPE
   IS
   BEGIN
      assert (g_curr_index IS NOT NULL
             ,'current_row: you have moved past end of result set.'
             );
      RETURN employees (g_curr_index);
   END current_row;

   PROCEDURE goto_first_row
   IS
   BEGIN
      g_curr_index := employees.FIRST;
   END goto_first_row;

   PROCEDURE goto_last_row
   IS
   BEGIN
      g_curr_index := employees.LAST;
   END goto_last_row;

   PROCEDURE goto_next_row
   IS
   BEGIN
      g_curr_index := employees.NEXT (g_curr_index);
   END goto_next_row;

   PROCEDURE goto_previous_row
   IS
   BEGIN
      g_curr_index := employees.PRIOR (g_curr_index);
   END goto_previous_row;
BEGIN
   load_cache;
END employee_bidir;
/
