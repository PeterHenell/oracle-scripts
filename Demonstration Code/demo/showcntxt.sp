CREATE OR REPLACE PROCEDURE show_context_info 
IS
   context_info DBMS_SESSION.AppCtxTabTyp;
   info_count PLS_INTEGER;
   indx PLS_INTEGER;
BEGIN
   DBMS_SESSION.LIST_CONTEXT (
      context_info,
      info_count);
   indx := context_info.FIRST;   
   LOOP
      EXIT WHEN indx IS NULL;
      DBMS_OUTPUT.PUT_LINE (
         context_info(indx).namespace || '.' ||
         context_info(indx).attribute || ' = ' ||
         context_info(indx).value);
      indx := context_info.NEXT (indx);
   END LOOP;   
END;
/