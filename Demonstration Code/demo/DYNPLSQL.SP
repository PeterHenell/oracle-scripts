CREATE OR REPLACE PROCEDURE exec_dynplsql (blk_in     IN VARCHAR2
                                         , trace_in   IN BOOLEAN:= FALSE
                                         , reraise_in IN BOOLEAN:= TRUE
                                          )
   AUTHID CURRENT_USER
IS
   -- Guarantee a valid PL/SQL block.
   mycode   VARCHAR2 (32767) := 'BEGIN ' || RTRIM (blk_in, ';') || '; END;';
BEGIN
   IF trace_in
   THEN
      DBMS_OUTPUT.put_line (mycode);
   END IF;

   -- Assumes no bind variables...
   EXECUTE IMMEDIATE mycode;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Dynamic PL/SQL Error!');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      DBMS_OUTPUT.put_line ('In block:');
      DBMS_OUTPUT.put_line (mycode);

      IF reraise_in
      THEN
         RAISE;
      END IF;
END;
/