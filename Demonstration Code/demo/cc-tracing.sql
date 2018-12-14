CREATE OR REPLACE FUNCTION list_to_collection (
   string_in      IN   VARCHAR2
 , delimiter_in   IN   VARCHAR2 DEFAULT ','
)
   RETURN DBMS_SQL.varchar2a
IS
   l_next_location PLS_INTEGER := 1;
   l_start_location PLS_INTEGER := 1;
   l_return DBMS_SQL.varchar2a;
$IF $$trace_critical OR $$trace_full $THEN
   PROCEDURE show_contents 
   IS BEGIN
      FOR indx IN 1 .. l_return.COUNT 
      LOOP
         DBMS_OUTPUT.PUT_LINE (
            'Element at index ' || indx || ' = ' || l_return(indx));   
      END LOOP;
   END show_contents;  
$END
BEGIN
   IF string_in IS NOT NULL
   THEN
      WHILE ( l_next_location > 0 )
      LOOP
         -- Find the next delimiter
         l_next_location := 
            NVL (INSTR ( string_in, delimiter_in, l_start_location ), 0);
$IF $$trace_full $THEN  
   DBMS_OUTPUT.PUT_LINE (
      '>>> Start location: ' || l_start_location );   
   DBMS_OUTPUT.PUT_LINE (
      '>>> Next location of delimiter: ' || l_next_location );   
$END            

         IF l_next_location = 0
         THEN
            -- No more delimiters, go to end of string
            l_return ( l_return.COUNT + 1 ) :=
                 SUBSTR ( string_in, l_start_location );
$IF $$trace_full $THEN  
   DBMS_OUTPUT.PUT_LINE (
      '>>> Add rest of string: "' ||
      SUBSTR ( string_in, l_start_location ) || '"');   
$END            
         ELSE
            -- Extract the string between the two delimiters
$IF $$trace_full $THEN  
   DBMS_OUTPUT.PUT_LINE (
      '>>> Between two delimiters: "' ||
      SUBSTR ( string_in
                      , l_start_location
                      , l_next_location - l_start_location
                      ) || '"');   
$END            
            l_return ( l_return.COUNT + 1 ) :=
               SUBSTR ( string_in
                      , l_start_location
                      , l_next_location - l_start_location
                      );
         END IF;
         l_start_location := l_next_location + 1;
      END LOOP;
   END IF;
$IF $$trace_critical OR $$trace_full $THEN
   show_contents;  
$END
   RETURN l_return;   
END list_to_collection;
/

ALTER FUNCTION list_to_collection COMPILE
  PLSQL_CCFLAGS = 'trace_critical:false, trace_full:false'
  REUSE SETTINGS
/

DECLARE
   l_list DBMS_SQL.varchar2a;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Trace turned off');
   l_list := list_to_collection ('a,b,c,d');
   DBMS_OUTPUT.PUT_LINE ('Count in list: ' || l_list.COUNT);
END;
/
   
ALTER FUNCTION list_to_collection COMPILE
  PLSQL_CCFLAGS = 'trace_critical:true, trace_full:false'
  REUSE SETTINGS
/

DECLARE
   l_list DBMS_SQL.varchar2a;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Trace CRITICAL Only');
   l_list := list_to_collection ('a,b,c,d');
   DBMS_OUTPUT.PUT_LINE ('Count in list: ' || l_list.COUNT);
END;
/
   
ALTER FUNCTION list_to_collection COMPILE
  PLSQL_CCFLAGS = 'trace_critical:false, trace_full:true'
  REUSE SETTINGS
/

DECLARE
   l_list DBMS_SQL.varchar2a;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Trace FULL');
   l_list := list_to_collection ('a,b,c,,d,');
   DBMS_OUTPUT.PUT_LINE ('Count in list: ' || l_list.COUNT);
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'trace_critical:FALSE,trace_full:FALSE'
/

ALTER FUNCTION list_to_collection COMPILE
/

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'FUNCTION', USER, 'LIST_TO_COLLECTION');
END;
/
