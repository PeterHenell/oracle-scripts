DECLARE
   l_start PLS_INTEGER;

   PROCEDURE mark_start
   IS
   BEGIN
      l_start := DBMS_UTILITY.get_cpu_time;
   END mark_start;

   PROCEDURE show_elapsed ( NAME_IN IN VARCHAR2 )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    '"'
                             || NAME_IN
                             || '" elapsed CPU time: '
                             || TO_CHAR ( (DBMS_UTILITY.get_cpu_time - l_start ) / 100 )
                             || ' seconds'
                           );
   END show_elapsed;
BEGIN
   mark_start;

   -- Put your code here

   show_elapsed ( 'test-description' );
END;
/
