-- Step 1: first pass at high level view of executable section. 

CREATE OR REPLACE PROCEDURE genaa (
   tab_in   IN   VARCHAR2,
   sch_in   IN   VARCHAR2 := NULL
)
IS 
BEGIN
   -- Get all the columns in the primary key
   pkcols := primary_key_columns (tab_in, sch_in);
   
   -- Use a nested collection for columns in each index.
   ucols := unique_index_columns (tab_in, sch_in);
   
   gen_header (tab_in, sch_in);
   gen_declarations (tab_in, sch_in, pkcols, ucols);
   gen_exec_section (tab_in, sch_in, pkcols, ucols);
   gen_exc_section (tab_in, sch_in, pkcols, ucols);
   gen_closure (tab_in, sch_in);
END;
