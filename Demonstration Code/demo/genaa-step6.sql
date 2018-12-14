-- Step 6: Restructure gen stubs; we are generating a package,
--         not a procedure!

CREATE OR REPLACE PROCEDURE genaa (
   tab_in         IN   VARCHAR2,
   sch_in         IN   VARCHAR2 := NULL,
   delim_in       IN   VARCHAR2 := '^',
   pkg_name_in    IN   VARCHAR2 := NULL,
   do_reload_in   IN   BOOLEAN := FALSE ,
   display_in     IN   BOOLEAN := FALSE
)
IS 
   SUBTYPE identifier_t IS VARCHAR2 (100);

   v_tab        identifier_t := UPPER (tab_in);
   v_sch        identifier_t := NVL (UPPER (sch_in), USER);
   v_pkg_name   identifier_t := NVL (pkg_name_in, tab_in || '_cache');

   TYPE cols_rec IS RECORD (
      NAME   identifier_t,
      TYPE   identifier_t
   );

   TYPE cols_tt IS TABLE OF cols_rec
      INDEX BY BINARY_INTEGER;

   TYPE inds_tt IS TABLE OF cols_tt
      INDEX BY BINARY_INTEGER; --identifier_t;
   pkcols       cols_tt;
   ucols        inds_tt;

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

   FUNCTION primary_key_columns (
      tab_in   IN   VARCHAR2,
      sch_in   IN   VARCHAR2,
      pky_in   IN   VARCHAR2
   )
      RETURN cols_tt
   IS
   BEGIN
      RETURN index_columns (tab_in, sch_in, pky_in);
   END;

   FUNCTION unique_index_columns (
      tab_in   IN   VARCHAR2,
      sch_in   IN   VARCHAR2,
      pky_in   IN   VARCHAR2
   )
      RETURN inds_tt
   IS 
      CURSOR uinds_cur
      IS
         SELECT index_name
           FROM all_indexes
          WHERE table_name = tab_in
            AND table_owner = sch_in
            AND uniqueness = 'UNIQUE'
            AND index_name != pky_in;

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
   -- step 6: improve the interfaces
   PROCEDURE validate_and_initialize (
      pkycols_out   IN OUT   cols_tt,
      ucols_out     IN OUT   inds_tt
   )
   IS 
      -- step 6: move declaration closer to its use.
      v_pky_name   identifier_t;
      indx         identifier_t;
   BEGIN
      v_pky_name := primary_key_name (v_tab, v_sch);
      pkycols_out := primary_key_columns (v_tab, v_sch, v_pky_name);
      -- Use a nested collection.
      ucols_out := unique_index_columns (v_tab, v_sch, v_pky_name);

      IF display_in
      THEN
         pl ('Columns for primary key on ' || v_sch || '.' || v_tab);

         FOR indx IN 1 .. pkycols_out.COUNT
         LOOP
            pl (pkycols_out (indx).NAME || ' - ' || pkycols_out (indx).TYPE);
         END LOOP;

         pl ('');
         indx := ucols_out.FIRST;

         LOOP
            EXIT WHEN indx IS NULL;
            pl ('Columns for Index ' || indx);

            FOR cindx IN ucols_out (indx).FIRST .. ucols_out (indx).LAST
            LOOP
               pl (
                     ucols_out (indx) (cindx).NAME
                  || ' - '
                  || ucols_out (indx) (cindx).TYPE
               );
            END LOOP;

            indx := ucols_out.NEXT (indx);
         END LOOP;
      END IF;
   END;
   -- step 6: whoops! We are generating a PACKAGE!

   PROCEDURE gen_package_spec (
      tab_in       IN   VARCHAR2,
      sch_in       IN   VARCHAR2,
      pkg_in       IN   VARCHAR2,
      pkycols_in   IN   cols_tt,
      ucols_in     IN   inds_tt
   )
   IS 
      PROCEDURE gen_declarations
      IS
      BEGIN
         -- Declare a named type for each concatenated index/pkey
         NULL;
      END;

      PROCEDURE gen_retrieval_functions
      IS
      BEGIN
         -- Declare a function for each index and pkey
         NULL;
      END;

      PROCEDURE gen_reload_logic
      IS
      BEGIN
         IF do_reload_in
         THEN
            -- Include headers to load and set reload interval.
            NULL;
         END IF;
      END;
   BEGIN
      pl ('create or replace package ' || pkg_in || ' is ');
      gen_declarations;
      gen_retrieval_functions;
      gen_reload_logic;
      pl ('end package ' || pkg_in || ';');
   END;

   PROCEDURE gen_package_body (
      tab_in       IN   VARCHAR2,
      sch_in       IN   VARCHAR2,
      pkg_in       IN   VARCHAR2,
      pkycols_in   IN   cols_tt,
      ucols_in     IN   inds_tt
   )
   IS 
      -- step 6: move gen procedures INSIDE gen_package_body
      PROCEDURE gen_declarations
      IS
      BEGIN
         -- Global package variables
         -- Associative Array types and actual arrays
         NULL;
      END;

      PROCEDURE gen_retrieval_functions
      IS
      BEGIN
          -- For the primary key, a function to return one row
         -- from the cached data array.
         NULL;
         -- For each unique index, a function to return one row
         -- using a separate associative array to locate the
         -- data in the primary key array.
         NULL;
      END;

      PROCEDURE gen_reload_logic
      IS
      BEGIN
         IF do_reload_in
         THEN
            -- Include headers to load and set reload interval.
            NULL;
         END IF;
      END;

      PROCEDURE gen_init_section
      IS
      BEGIN
         NULL;
      END;
   BEGIN
      pl ('create or replace package body ' || pkg_in || ' is ');
      gen_declarations;
	  gen_retrieval_functions;
	  gen_reload_logic;
	  gen_init_section;
      pl ('end package ' || pkg_in || ';');
   END;
BEGIN
   validate_and_initialize (pkcols, ucols);
   
   -- step 6: Whoops! We are generating a package!
   --         Time to refine my stepwise refinement.

   gen_package_spec (v_tab, v_sch, v_pkg_name, pkcols, ucols);
   gen_package_body (v_tab, v_sch, v_pkg_name, pkcols, ucols);
END;
