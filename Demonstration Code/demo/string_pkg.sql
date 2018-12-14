ALTER SESSION SET plsql_ccflags = 'max_varchar2_length:32767'
/

CREATE OR REPLACE PACKAGE string_pkg
IS
   SUBTYPE maxvarchar2_t IS VARCHAR2 ( $$max_varchar2_length );

   TYPE maxvarchar2_aat IS TABLE OF maxvarchar2_t
      INDEX BY PLS_INTEGER;

   TYPE clob_aat IS TABLE OF CLOB
      INDEX BY PLS_INTEGER;

   FUNCTION betwnstr (
      string_in      IN   VARCHAR2
    , start_in       IN   PLS_INTEGER
    , end_in         IN   PLS_INTEGER
    , inclusive_in   IN   BOOLEAN := TRUE
   )
      RETURN VARCHAR2;

   FUNCTION list_to_collection (
      string_in   IN   VARCHAR2
    , delim_in    IN   VARCHAR2 DEFAULT ','
   )
      RETURN maxvarchar2_aat;

   FUNCTION cloblist_to_collection (
      string_in   IN   CLOB
    , delim_in    IN   VARCHAR2 DEFAULT ','
   )
      RETURN clob_aat;
END string_pkg;
/

CREATE OR REPLACE PACKAGE BODY string_pkg
IS
   FUNCTION betwnstr (
      string_in      IN   VARCHAR2
    , start_in       IN   PLS_INTEGER
    , end_in         IN   PLS_INTEGER
    , inclusive_in   IN   BOOLEAN := TRUE
   )
      RETURN VARCHAR2
   IS
      v_start PLS_INTEGER;
      v_numchars PLS_INTEGER := ABS ( end_in ) - ABS ( start_in ) + 1;
   BEGIN
      IF    string_in IS NULL
         OR ( start_in < 0 AND end_in > 0 )
         OR ( start_in > 0 AND end_in < 0 )
         OR ( start_in < 0 AND end_in > start_in )
         OR ( start_in > 0 AND end_in < start_in )
      THEN
         RETURN NULL;
      ELSE
         IF start_in < 0
         THEN
            v_start := GREATEST ( end_in, -1 * LENGTH ( string_in ));
         ELSIF start_in = 0
         THEN
            v_start := 1;
            v_numchars := ABS ( end_in ) - ABS ( v_start ) + 1;
         ELSE
            v_start := start_in;
         END IF;

         IF NOT NVL ( inclusive_in, FALSE )
         THEN
            v_start := v_start + 1;
            v_numchars := v_numchars - 2;
         END IF;

         RETURN ( SUBSTR ( string_in, v_start, v_numchars ));
      END IF;
   END betwnstr;

   FUNCTION cloblist_to_collection (
      string_in   IN   CLOB
    , delim_in    IN   VARCHAR2 DEFAULT ','
   )
      RETURN clob_aat
   IS
      l_loc PLS_INTEGER;
      l_row PLS_INTEGER := 1;
      l_startloc PLS_INTEGER := 1;
      l_return clob_aat;
   BEGIN
      IF string_in IS NOT NULL
      THEN
         LOOP
            -- Get the next item.
            l_loc := INSTR ( string_in, delim_in, l_startloc );

            IF l_loc = l_startloc
            THEN
               l_return ( l_row ) := NULL;
            ELSIF l_loc = 0
            THEN
               l_return ( l_row ) := SUBSTR ( string_in, l_startloc );
            ELSE
               l_return ( l_row ) :=
                           SUBSTR ( string_in, l_startloc, l_loc - l_startloc );
            END IF;

            -- Was that the last one?
            IF l_loc = 0
            THEN
               EXIT;
            ELSE
               l_startloc := l_loc + 1;
               l_row := l_row + 1;
            END IF;
         END LOOP;
      END IF;

      RETURN l_return;
   END cloblist_to_collection;

   FUNCTION list_to_collection (
      string_in   IN   VARCHAR2
    , delim_in    IN   VARCHAR2 DEFAULT ','
   )
      RETURN maxvarchar2_aat
   IS
      l_loc PLS_INTEGER;
      l_row PLS_INTEGER := 1;
      l_startloc PLS_INTEGER := 1;
      l_return maxvarchar2_aat;
   BEGIN
      IF string_in IS NOT NULL
      THEN
         LOOP
            -- Get the next item.
            l_loc := INSTR ( string_in, delim_in, l_startloc );

            IF l_loc = l_startloc
            THEN
               l_return ( l_row ) := NULL;
            ELSIF l_loc = 0
            THEN
               l_return ( l_row ) := SUBSTR ( string_in, l_startloc );
            ELSE
               l_return ( l_row ) :=
                           SUBSTR ( string_in, l_startloc, l_loc - l_startloc );
            END IF;

            -- Was that the last one?
            IF l_loc = 0
            THEN
               EXIT;
            ELSE
               l_startloc := l_loc + 1;
               l_row := l_row + 1;
            END IF;
         END LOOP;
      END IF;

      RETURN l_return;
   END list_to_collection;   
   
   /* Unfortunately, CLOBs are so much slower to work with than VARCHAR2s
      that we really don't want to use the cloblist_to_collection as the
      base implementation.
   FUNCTION list_to_collection (
      string_in   IN   VARCHAR2
    , delim_in    IN   VARCHAR2 DEFAULT ','
   )
      RETURN maxvarchar2_aat
   IS
      l_clobs clob_aat;
      l_return maxvarchar2_aat;
   BEGIN
      -- Parse the string as a CLOB.
      l_clobs := cloblist_to_collection ( TO_CLOB ( string_in ), delim_in );

      -- Copy the individual items to the string collection.
      -- Use SUBSTR to avoid VALUE_ERROR exceptions.
      FOR clob_index IN 1 .. l_clobs.COUNT
      LOOP
         l_return ( clob_index ) :=
                    SUBSTR ( l_clobs ( clob_index ), 1, $$max_varchar2_length );
      END LOOP;

      RETURN l_return;
   END list_to_collection;*/
END string_pkg;
/
