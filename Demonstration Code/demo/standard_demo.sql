declare
   subtype date is boolean;

   varchar2 integer;
   "1+2"    pls_integer;
   to_char  date := true;
   no_data_found exception;
begin
   dbms_output.put_line (
      case to_char when true then 'true' else 'false' end);

   select 1 + 2
     into "1+2"
     from dual
    where 1 = 2;
    
   /*
   select 1 + 2
     into varchar2
     from dual
    where 1 = 2;
   */
exception
   when no_data_found
   then
      dbms_output.put_line (sqlcode);
end;