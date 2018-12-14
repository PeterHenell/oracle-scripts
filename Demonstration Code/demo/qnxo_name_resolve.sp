CREATE OR REPLACE PROCEDURE qnxo_name_resolve (
   NAME            IN       VARCHAR2
  ,SCHEMA          OUT      VARCHAR2
  ,part1           OUT      VARCHAR2
  ,part2           OUT      VARCHAR2
  ,dblink          OUT      VARCHAR2
  ,part1_type      OUT      NUMBER
  ,object_number   OUT      NUMBER
)
AUTHID CURRENT_USER
IS
   -- Maximum context allowed by NAME_RESOLVE
   c_max_context   CONSTANT PLS_INTEGER := 8;
   -- Test context value
   l_context                PLS_INTEGER := 0;
   --
   l_resolved               BOOLEAN     := FALSE;
BEGIN
   /* Break down the name into its components */
   WHILE (NOT l_resolved AND l_context <= c_max_context)
   LOOP
      BEGIN
         DBMS_UTILITY.name_resolve (NAME
                                   ,l_context
                                   ,SCHEMA
                                   ,part1
                                   ,part2
                                   ,dblink
                                   ,part1_type
                                   ,object_number
                                   );
         l_resolved := TRUE;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_context := l_context + 1;
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Qnxo_Name_Resolve cannot resolve "' || NAME
                            || '"'
                           );
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END qnxo_name_resolve;
/