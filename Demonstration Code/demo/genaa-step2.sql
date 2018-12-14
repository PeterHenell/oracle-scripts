-- Step 2: define needed data structures (first round implementation,
--         anyway) and local variables. 

CREATE OR REPLACE PROCEDURE genaa (
   tab_in   IN   VARCHAR2,
   sch_in   IN   VARCHAR2 := NULL
)
IS 
   v_tab    VARCHAR2 (100) := UPPER (tab_in);
   v_sch    VARCHAR2 (100) := NVL (UPPER (sch_in), USER);

   TYPE cols_rec IS RECORD (
      NAME   VARCHAR2 (100),
      TYPE   VARCHAR2 (100)
   );

   TYPE cols_tt IS TABLE OF cols_rec
      INDEX BY BINARY_INTEGER;

   TYPE inds_tt IS TABLE OF cols_tt
      INDEX BY user_indexes.index_name%TYPE;
	  
   pkcols   cols_tt;
   ucols    inds_tt;

   FUNCTION primary_key_columns (tab_in IN VARCHAR2, sch_in IN VARCHAR2 := NULL)
      RETURN cols_tt
   IS
   BEGIN
      RETURN NULL;
   END;

   FUNCTION unique_index_columns (tab_in IN VARCHAR2, sch_in IN VARCHAR2
            := NULL)
      RETURN cols_tt
   IS
   BEGIN
      RETURN NULL;
   END;
BEGIN
   pkcols := primary_key_columns (v_tab, v_sch);
   -- Use a nested collection.
   ucols := unique_index_columns (v_tab, v_sch);
   gen_header (v_tab, v_sch);
   gen_declarations (v_tab, v_sch, pkcols, ucols);
   gen_exec_section (v_tab, v_sch, pkcols, ucols);
   gen_exc_section (v_tab, v_sch, pkcols, ucols);
   gen_closure (v_tab, v_sch);
END;
