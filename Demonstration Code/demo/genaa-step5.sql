-- Step 5: add self-test/display mechanism, fine-tune interface
--         for initialization.

CREATE OR REPLACE PROCEDURE genaa (
   tab_in         IN   VARCHAR2,
   sch_in         IN   VARCHAR2 := NULL,
   delim_in       IN   VARCHAR2 := '^',
   pkg_name_in    IN   VARCHAR2 := NULL,
   do_reload_in   IN   BOOLEAN := FALSE ,
   display_in     IN   BOOLEAN := FALSE -- step 5: built-in validation
)
IS 
   -- step 5: avoid hard-coded varchar2 lengths
   subtype identifier_t is varchar2(100);
   
   v_tab        identifier_t := UPPER (tab_in);
   v_sch        identifier_t := NVL (UPPER (sch_in), USER);
   v_pky_name   identifier_t;
   v_pkg_name   identifier_t := NVL (pkg_name_in, tab_in || '_cache');

   TYPE cols_rec IS RECORD (
      NAME   identifier_t,
      TYPE   identifier_t
   );

   TYPE cols_tt IS TABLE OF cols_rec
      INDEX BY BINARY_INTEGER;

   TYPE inds_tt IS TABLE OF cols_tt
      INDEX BY /*BINARY_INTEGER; --*/ identifier_t;
   pkcols       cols_tt;
   ucols        inds_tt;
   
   -- step 5: add local utility display procedure.
   PROCEDURE pl (
      str         IN   VARCHAR2,
      len         IN   INTEGER := 80,
      expand_in   IN   BOOLEAN := TRUE
   )
   IS 
      v_len   PLS_INTEGER     := LEAST (len, 255);
      v_str   VARCHAR2 (2000);
   BEGIN
      IF LENGTH (str) > v_len
      THEN
         v_str := SUBSTR (str, 1, v_len);
         DBMS_OUTPUT.put_line (v_str);
         pl (SUBSTR (str, len + 1), v_len, expand_in);
      ELSE
         v_str := str;
         DBMS_OUTPUT.put_line (v_str);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF expand_in
         THEN
            DBMS_OUTPUT.ENABLE (1000000);
            DBMS_OUTPUT.put_line (v_str);
         ELSE
            RAISE;
         END IF;
   END;

   FUNCTION primary_key_name (tab_in IN VARCHAR2, sch_in IN VARCHAR2)
      RETURN VARCHAR2
   IS 
      retval   identifier_t;
   BEGIN
      SELECT cons.constraint_name
        INTO retval
        FROM all_constraints cons
       WHERE cons.owner = sch_in
         AND cons.table_name = tab_in
         AND cons.constraint_type = 'P';

      RETURN retval;
   END;
   -- Create another function that retrieves all 
   -- column info for the specified index. 
   FUNCTION index_columns (
      tab_in   IN   VARCHAR2,
      sch_in   IN   VARCHAR2 := NULL,
      ind_in   IN   VARCHAR2
   )
      RETURN cols_tt
   IS 
      retval   cols_tt;
   BEGIN
      SELECT   i.column_name, t.data_type
          BULK COLLECT INTO retval
          FROM all_ind_columns i, all_tab_columns t
         WHERE i.index_owner = sch_in
           AND i.table_name = tab_in
           AND i.table_owner = sch_in
           AND i.index_name = ind_in
           AND i.table_name = t.table_name
           AND i.table_owner = t.owner
           AND i.column_name = t.column_name
      ORDER BY column_position;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN retval;
   END;

   FUNCTION primary_key_columns (tab_in IN VARCHAR2, sch_in IN VARCHAR2 := NULL)
      RETURN cols_tt
   IS
   BEGIN
      RETURN index_columns (tab_in, sch_in, v_pky_name);
   END;

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
            AND uniqueness = 'UNIQUE'
            AND index_name != v_pky_name;

      retval   inds_tt;
   BEGIN
      FOR rec IN uinds_cur
      LOOP
         retval (rec.index_name) := index_columns (
                                       tab_in,
                                       sch_in,
                                       rec.index_name
                                    );
      END LOOP;

      RETURN retval;
   END;

   PROCEDURE validate_and_initialize
   IS
      indx identifier_t;
   BEGIN
      v_pky_name := primary_key_name (v_tab, v_sch);
      pkcols := primary_key_columns (v_tab, v_sch);
      -- Use a nested collection.
      ucols := unique_index_columns (v_tab, v_sch);

      -- step 5: built-in test/verification
      IF display_in
      THEN
         pl ('Columns for primary key on ' || v_sch || '.' || v_tab);
		 
         FOR indx IN 1 .. pkcols.COUNT
         LOOP
            pl (pkcols (indx).NAME || ' - ' || pkcols (indx).TYPE);
         END LOOP;

         pl ('');
		 
		 indx := ucols.FIRST;		 
         LOOP
		    EXIT WHEN indx IS NULL;
            pl ('Columns for Index ' || indx);

            FOR cindx IN 1 .. pkcols.COUNT
            LOOP
               pl (
                     ucols (indx)(cindx).NAME
                  || ' - '
                  || ucols (indx)(cindx).TYPE
               );
            END LOOP;
			indx := ucols.NEXT (indx);
         END LOOP;
      END IF;
   END;

   PROCEDURE gen_header (
      tab_in   IN   VARCHAR2,
      sch_in   IN   VARCHAR2,
      pkg_in   IN   VARCHAR2
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE gen_declarations (
      tab_in       IN   VARCHAR2,
      sch_in       IN   VARCHAR2,
      pkycols_in   IN   cols_tt,
      ucols_in     IN   inds_tt
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE gen_exec_section (
      tab_in       IN   VARCHAR2,
      sch_in       IN   VARCHAR2,
      pkycols_in   IN   cols_tt,
      ucols_in     IN   inds_tt
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE gen_exc_section (
      tab_in       IN   VARCHAR2,
      sch_in       IN   VARCHAR2,
      pkycols_in   IN   cols_tt,
      ucols_in     IN   inds_tt
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE gen_closure (
      tab_in   IN   VARCHAR2,
      sch_in   IN   VARCHAR2,
      pkg_in   IN   VARCHAR2
   )
   IS
   BEGIN
      NULL;
   END;
BEGIN
   -- step 5: move population of collections to init program
   validate_and_initialize;
   gen_header (v_tab, v_sch, v_pkg_name);
   gen_declarations (v_tab, v_sch, pkcols, ucols);
   gen_exec_section (v_tab, v_sch, pkcols, ucols);
   gen_exc_section (v_tab, v_sch, pkcols, ucols);
   gen_closure (v_tab, v_sch, v_pkg_name);
END;
