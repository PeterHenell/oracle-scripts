CREATE OR REPLACE FUNCTION list_to_collection (
   string_in      IN   VARCHAR2
 , delimiter_in   IN   VARCHAR2 DEFAULT ','
)
   RETURN DBMS_SQL.varchar2a
IS
   l_next_location PLS_INTEGER := 1;
   l_start_location PLS_INTEGER := 1;
   l_return DBMS_SQL.varchar2a;
BEGIN
   IF string_in IS NOT NULL
   THEN
      WHILE ( l_next_location > 0 )
      LOOP
         -- Find the next delimiter
         l_next_location := 
            NVL (INSTR ( string_in, delimiter_in, l_start_location ), 0);

         IF l_next_location = 0
         THEN
            -- No more delimiters, go to end of string
            l_return ( l_return.COUNT + 1 ) :=
                 SUBSTR ( string_in, l_start_location );
         ELSE
            $ERROR
            'list_to_collection INCOMPLETE!
             Finish extraction of next item from list.
             Go to ' || $$PLSQL_UNIT || ' at line ' || $$PLSQL_LINE
            $END
         END IF;
         l_start_location := l_next_location + 1;
      END LOOP;
   END IF;
   RETURN l_return;   
END list_to_collection;
/