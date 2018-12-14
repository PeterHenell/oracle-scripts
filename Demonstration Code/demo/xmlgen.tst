DECLARE
   ctx      DBMS_XMLGEN.ctxhandle;
   result   CLOB;
BEGIN
   -- create a new context with the SQL query
   ctx := DBMS_XMLGEN.newcontext ('select * from sustenance');

   -- generate the CLOB as a result.
   result := DBMS_XMLGEN.getxml (ctx);

   -- print out the result of the CLOB
   display_clob (result); 

   -- close the context
   DBMS_XMLGEN.closecontext (ctx);
END;
