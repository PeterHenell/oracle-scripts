CREATE OR REPLACE PROCEDURE gen_row_exists (
   tab_in        IN   VARCHAR2 -- name of table against which to generate the code
,  sch_in        IN   VARCHAR2 DEFAULT NULL -- owner of table, default to USER
 , pkg_name_in   IN   VARCHAR2 DEFAULT NULL -- name of package generated, default is <table>_re
 , to_file_in    IN   BOOLEAN DEFAULT FALSE -- enter TRUE to send package def to file, otherwise to screen
,  file_in       IN   VARCHAR2 DEFAULT NULL  -- name of file, default is <table>_re.pkg
 , dir_in        IN   VARCHAR2 DEFAULT NULL  -- directory to which the file will be written
)
IS
   SUBTYPE identifier_t IS VARCHAR2 ( 100 );

   l_tab identifier_t := UPPER ( tab_in );
   l_sch identifier_t := NVL ( UPPER ( sch_in ), USER );
   l_pkg_name identifier_t := NVL ( pkg_name_in, tab_in || '_re' );
   -- Send g_output to file or screen?
   l_to_screen BOOLEAN := NVL ( NOT to_file_in, TRUE );
   l_file VARCHAR2 ( 1000 ) := l_pkg_name || '.pkg';

   -- Array of g_output for package
   TYPE lines_t IS TABLE OF VARCHAR2 ( 32767 )
      INDEX BY PLS_INTEGER;

   g_output lines_t;

   TYPE pky_rec IS RECORD (
      name identifier_t
    , column_name identifier_t
    , column_type identifier_t
    , array_name identifier_t
   );

   pky_info pky_rec;

   TYPE cols_rec IS RECORD (
      name identifier_t
    , TYPE identifier_t
    , aa_index_type identifier_t
   );

   TYPE cols_tt IS TABLE OF cols_rec
      INDEX BY BINARY_INTEGER;

   -- Additional fields to avoid hard-coding and unnecessary overhead
   TYPE inds_rec IS RECORD (
      name identifier_t
    , numcols PLS_INTEGER
    , array_name identifier_t
    , subtype_name identifier_t
    , val_for_name identifier_t
    , cols cols_tt
   );

   TYPE inds_tt IS TABLE OF inds_rec
      INDEX BY identifier_t;

   ucols inds_tt;

   -- Now pl simply writes to the array.
   PROCEDURE pl ( str IN VARCHAR2 )
   IS
   BEGIN
      g_output ( g_output.COUNT + 1 ) := str;
   END;

   -- Dump to screen or file.
   PROCEDURE dump_output
   IS
   BEGIN
      IF l_to_screen
      THEN
         FOR indx IN g_output.FIRST .. g_output.LAST
         LOOP
            DBMS_OUTPUT.put_line ( g_output ( indx ));
         END LOOP;
      ELSE
         -- Send g_output to the specified file.
         DECLARE
            fid UTL_FILE.file_type;
         BEGIN
            fid := UTL_FILE.fopen ( dir_in, l_file, 'W' );

            FOR indx IN g_output.FIRST .. g_output.LAST
            LOOP
               UTL_FILE.put_line ( fid, g_output ( indx ));
            END LOOP;

            UTL_FILE.fclose ( fid );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (    'Failure to write g_output to '
                                      || dir_in
                                      || '/'
                                      || l_file
                                    );
               UTL_FILE.fclose ( fid );
         END;
      END IF;
   END dump_output;

   PROCEDURE assert ( condition_in IN BOOLEAN, msg_in IN VARCHAR2 )
   IS
   BEGIN
      IF NOT condition_in OR condition_in IS NULL
      THEN
         raise_application_error ( -20000
                                 ,    'GENRE Error on '
                                   || l_sch
                                   || '.'
                                   || l_tab
                                   || ': '
                                   || msg_in
                                 );
      END IF;
   END;

   FUNCTION primary_key_name ( tab_in IN VARCHAR2, sch_in IN VARCHAR2 )
      RETURN VARCHAR2
   IS
      retval identifier_t;
   BEGIN
      SELECT cons.constraint_name
        INTO retval
        FROM all_constraints cons
       WHERE cons.owner = sch_in
         AND cons.table_name = tab_in
         AND cons.constraint_type = 'P';

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;

   -- Create another function that retrieves all
   -- column info for the specified index.
   FUNCTION index_columns (
      tab_in   IN   VARCHAR2
    , sch_in   IN   VARCHAR2 := NULL
    , ind_in   IN   VARCHAR2
   )
      RETURN cols_tt
   IS
      retval cols_tt;
   BEGIN
      SELECT   i.column_name
             , t.data_type
             , DECODE ( t.data_type
                      , 'INTEGER', 'PLS_INTEGER'
                      , sch_in || '.' || tab_in || '.' || i.column_name
                        || '%TYPE'
                      )
      BULK COLLECT INTO retval
          FROM all_ind_columns i
             , ( SELECT column_name, data_type
                  FROM all_tab_columns
                 WHERE table_name = tab_in AND owner = sch_in ) t
         WHERE i.index_owner = sch_in
           AND i.table_name = tab_in
           AND i.table_owner = sch_in
           AND i.index_name = ind_in
           AND i.column_name = t.column_name
      ORDER BY column_position;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN retval;
   END;

   FUNCTION primary_key_columns (
      tab_in   IN   VARCHAR2
    , sch_in   IN   VARCHAR2
    , pky_in   IN   VARCHAR2
   )
      RETURN cols_tt
   IS
   BEGIN
      RETURN index_columns ( tab_in, sch_in, pky_in );
   END;

   FUNCTION unique_index_columns (
      tab_in   IN   VARCHAR2
    , sch_in   IN   VARCHAR2
    , pky_in   IN   VARCHAR2
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
            AND (index_name != pky_in OR pky_in IS NULL);

      retval inds_tt;
   BEGIN
      FOR rec IN uinds_cur
      LOOP
         retval ( rec.index_name ).name := rec.index_name;
         retval ( rec.index_name ).array_name := rec.index_name || '_aa';
         retval ( rec.index_name ).subtype_name := rec.index_name || '_t';
         retval ( rec.index_name ).val_for_name :=
                                                 'val_for_' || rec.index_name;
         retval ( rec.index_name ).cols :=
                             index_columns ( tab_in, sch_in, rec.index_name );
         retval ( rec.index_name ).numcols :=
                                         retval ( rec.index_name ).cols.COUNT;
      END LOOP;

      RETURN retval;
   END;

   PROCEDURE validate_and_initialize (
      pky_info_out   IN OUT   pky_rec
    , ucols_out      IN OUT   inds_tt
   )
   IS
      indx identifier_t;
      pkycols cols_tt;
   BEGIN
      -- Set primary key information: just the first row of info!
      pky_info_out.name := primary_key_name ( l_tab, l_sch );

      IF pky_info_out.name IS NOT NULL
      THEN
         pkycols := primary_key_columns ( l_tab, l_sch, pky_info_out.name );
         pky_info_out.column_name := pkycols ( pkycols.FIRST ).name;
         pky_info_out.column_type := pkycols ( pkycols.FIRST ).TYPE;
         pky_info_out.array_name := pky_info_out.name || '_aa';
      END IF;

      -- Obtain unique index information.
      ucols_out := unique_index_columns ( l_tab, l_sch, pky_info_out.name );
   END;

   PROCEDURE gen_package_spec (
      tab_in        IN   VARCHAR2
    , sch_in        IN   VARCHAR2
    , pkg_in        IN   VARCHAR2
    , pky_info_in   IN   pky_rec
    , ucols_in      IN   inds_tt
   )
   IS
      l_fulltab identifier_t := l_sch || '.' || l_tab;

      PROCEDURE gen_retrieval_function_headers
      IS
         indx identifier_t := ucols_in.FIRST;
      BEGIN
         -- Declare a function for each index and pkey
         IF pky_info_in.column_name IS NOT NULL
         THEN
            pl (    'FUNCTION ex_for_pky ( '
                 || pky_info_in.column_name
                 || '_in IN '
                 || l_fulltab
                 || '.'
                 || pky_info_in.column_name
                 || '%TYPE) RETURN BOOLEAN;'
               );
         END IF;

         WHILE indx <= ucols_in.LAST
         LOOP
            -- Generic VARCHAR2-indexed tables...
            pl ( 'FUNCTION ex_for_' || ucols_in ( indx ).name || ' ( ' );

            FOR cindx IN
               ucols_in ( indx ).cols.FIRST .. ucols_in ( indx ).cols.LAST
            LOOP
               pl (    ucols_in ( indx ).cols ( cindx ).name
                    || '_in IN '
                    || l_fulltab
                    || '.'
                    || ucols_in ( indx ).cols ( cindx ).name
                    || '%TYPE'
                  );

               IF cindx < ucols_in ( indx ).cols.LAST
               THEN
                  pl ( ',' );
               END IF;
            END LOOP;

            pl ( ') RETURN BOOLEAN;' );
            indx := ucols_in.NEXT ( indx );
         END LOOP;
      END;
   BEGIN
      pl ( 'CREATE OR REPLACE PACKAGE ' || pkg_in || ' IS ' );
      gen_retrieval_function_headers;
      pl ( 'END ' || pkg_in || ';' );
      pl ( '/' );
   END gen_package_spec;

   PROCEDURE gen_package_body (
      tab_in        IN   VARCHAR2
    , sch_in        IN   VARCHAR2
    , pkg_in        IN   VARCHAR2
    , pky_info_in   IN   pky_rec
    , ucols_in      IN   inds_tt
   )
   IS
      l_fulltab identifier_t := l_sch || '.' || l_tab;

      FUNCTION rowval (
         ind_in      IN   inds_rec
       , prefix_in   IN   VARCHAR2
       , suffix_in   IN   VARCHAR2
      )
         RETURN VARCHAR2
      IS
         retval VARCHAR2 ( 32767 );
      BEGIN
         -- If single column return that column name.
         -- If > 1 column, return call to function val_for
         --   for each of the input values.
         IF ind_in.numcols = 1
         THEN
            retval :=
               prefix_in || ind_in.cols ( ind_in.cols.FIRST ).name
               || suffix_in;
         ELSE
            retval := ind_in.val_for_name || '(';

            FOR cindx IN 1 .. ind_in.cols.COUNT
            LOOP
               retval :=
                  retval || prefix_in || ind_in.cols ( cindx ).name
                  || suffix_in;

               IF cindx < ind_in.cols.LAST
               THEN
                  retval := retval || ',';
               END IF;
            END LOOP;

            retval := retval || ')';
         END IF;

         RETURN retval;
      END;

      PROCEDURE gen_retrieval_functions
      IS
         indx identifier_t := ucols_in.FIRST;
      BEGIN
         IF pky_info_in.column_name IS NOT NULL
         THEN
            pl (    'FUNCTION ex_for_pky ( '
                 || pky_info_in.column_name
                 || '_in IN '
                 || l_fulltab
                 || '.'
                 || pky_info_in.column_name
                 || '%TYPE) RETURN BOOLEAN IS l_dummy PLS_INTEGER; BEGIN '
                 || 'SELECT 1 INTO l_dummy FROM '
                 || l_fulltab
                 || ' WHERE '
                 || pky_info_in.column_name
                 || ' = '
                 || pky_info_in.column_name
                 || '_in; RETURN TRUE; '
                 || ' EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;'
                 || ' WHEN TOO_MANY_ROWS THEN RETURN TRUE; END;'
               );
         END IF;

         WHILE indx <= ucols_in.LAST
         LOOP
            -- Generic VARCHAR2-indexed tables...
            pl ( 'FUNCTION ex_for_' || ucols_in ( indx ).name || ' ( ' );

            FOR cindx IN
               ucols_in ( indx ).cols.FIRST .. ucols_in ( indx ).cols.LAST
            LOOP
               pl (    ucols_in ( indx ).cols ( cindx ).name
                    || '_in IN '
                    || l_fulltab
                    || '.'
                    || ucols_in ( indx ).cols ( cindx ).name
                    || '%TYPE'
                  );

               IF cindx < ucols_in ( indx ).cols.LAST
               THEN
                  pl ( ',' );
               END IF;
            END LOOP;

            pl (    ') RETURN BOOLEAN IS l_dummy PLS_INTEGER; BEGIN '
                 || 'SELECT 1 INTO l_dummy FROM '
                 || l_fulltab
                 || ' WHERE '
               );

            FOR cindx IN
               ucols_in ( indx ).cols.FIRST .. ucols_in ( indx ).cols.LAST
            LOOP
               pl (    ucols_in ( indx ).cols ( cindx ).name
                    || '_in = '
                    || ucols_in ( indx ).cols ( cindx ).name
                  );

               IF cindx < ucols_in ( indx ).cols.LAST
               THEN
                  pl ( ' AND ' );
               END IF;
            END LOOP;

            pl (    '; RETURN TRUE; '
                 || ' EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;'
                 || ' WHEN TOO_MANY_ROWS THEN RETURN TRUE; END;'
               );
            indx := ucols_in.NEXT ( indx );
         END LOOP;
      END;
   BEGIN
      pl ( 'CREATE OR REPLACE PACKAGE BODY ' || pkg_in || ' IS ' );
      gen_retrieval_functions;
      pl ( 'END ' || pkg_in || ';' );
      pl ( '/' );
      dump_output;
   END gen_package_body;
BEGIN
   validate_and_initialize ( pky_info, ucols );
   gen_package_spec ( l_tab, l_sch, l_pkg_name, pky_info, ucols );
   gen_package_body ( l_tab, l_sch, l_pkg_name, pky_info, ucols );
END gen_row_exists;
/
