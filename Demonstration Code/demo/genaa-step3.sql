-- Step 3: Add initialization step, implement queries from
--         data dictionary, add flexibility to the parameter list.

CREATE OR REPLACE PROCEDURE genaa (
   tab_in         IN   VARCHAR2,
   sch_in         IN   VARCHAR2 := NULL,
   delim_in       IN   VARCHAR2 := '^', -- step 3: generalize the interface
   pkg_name_in    IN   VARCHAR2 := NULL, -- step 3
   do_reload_in   IN   BOOLEAN := FALSE -- step 3   
)
IS 
   v_tab        VARCHAR2 (100) := UPPER (tab_in);
   v_sch        VARCHAR2 (100) := NVL (UPPER (sch_in), USER);

   v_pky_name   VARCHAR2 (100); -- step 3

   TYPE cols_rec IS RECORD (
      NAME   VARCHAR2 (100),
      TYPE   VARCHAR2 (100)
   );

   TYPE cols_tt IS TABLE OF cols_rec
      INDEX BY BINARY_INTEGER;

   TYPE inds_tt IS TABLE OF cols_tt
      INDEX BY BINARY_INTEGER; -- user_indexes.index_name%TYPE;
   pkcols       cols_tt;
   ucols        inds_tt;

   -- step 3
   FUNCTION primary_key_name (tab_in IN VARCHAR2, sch_in IN VARCHAR2)
      RETURN VARCHAR2
   IS 
      retval   VARCHAR2 (100);
   BEGIN
      SELECT cons.constraint_name
        INTO retval
        FROM all_constraints cons
       WHERE cons.owner = sch_in
         AND cons.table_name = tab_in
         AND cons.constraint_type = 'P';

      RETURN retval;
   END;

   -- step 3
   PROCEDURE validate_and_initialize
   IS
   BEGIN
      v_pky_name := primary_key_name (v_tab, v_sch);
   END;

   -- step 3: Create another function that retrieves all 
   --         column info for the specified index. 
   FUNCTION index_columns (
      tab_in   IN   VARCHAR2,
      sch_in   IN   VARCHAR2 := NULL,
      ind_in   IN   VARCHAR2
   )
      RETURN cols_tt
   IS  
      retval   cols_tt;
   BEGIN
      SELECT   column_name, data_type
          BULK COLLECT INTO retval
          FROM all_ind_columns i, all_tab_columns t
         WHERE index_owner = indsch_in
           AND table_name = tab_in
           AND table_owner = sch_in
           AND index_name = ind_in
           AND i.table_name = t.table_name
           AND i.table_owner = t.owner
           AND i.column_name = t.column_name
      ORDER BY column_position;

      RETURN retval;
   END;

   -- step 3: not much left to do here.
   FUNCTION primary_key_columns (tab_in IN VARCHAR2, sch_in IN VARCHAR2 := NULL)
      RETURN cols_tt
   IS
   BEGIN
      RETURN index_columns (tab_in, sch_in, v_pky_name);
   END;

   -- step 3: get the SQL right, exclude the primary key. 
   FUNCTION unique_index_columns (tab_in IN VARCHAR2, sch_in IN VARCHAR2
            := NULL)
      RETURN inds_tt
   IS 
      CURSOR uinds_cur
      IS
         SELECT index_name
           FROM all_indexes
          WHERE table_name = tab_in
            AND table_owner = sch_in
            AND uniquesness = 'UNIQUE'
            AND index_name != v_pky_name;

      retval   inds_tt;
   BEGIN
      FOR rec IN uinds_cur
      LOOP
         inds_tt (NVL (inds_tt.LAST, 0) + 1) :=
                               index_columns (tab_in, sch_in, rec.index_name);
      END LOOP;

      RETURN retval;
   END;
BEGIN
   -- step 3: add initialization step
   validate_and_initialize;
   
   pkcols := primary_key_columns (v_tab, v_sch);
   
   -- Use a nested collection.
   ucols := unique_index_columns (v_tab, v_sch);
   gen_header (v_tab, v_sch);
   gen_declarations (v_tab, v_sch, pkcols, ucols);
   gen_exec_section (v_tab, v_sch, pkcols, ucols);
   gen_exc_section (v_tab, v_sch, pkcols, ucols);
   gen_closure (v_tab, v_sch);
END;
