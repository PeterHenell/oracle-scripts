create or replace procedure proc0 is  
begin 
   RAISE no_data_found;
end; 
/
create or replace procedure proc1 is  
begin
   NULL; 
   p.l ('calling proc0');
   proc0; 
EXCEPTION
   WHEN OTHERS THEN RAISE DUP_VAL_ON_INDEX;   
end; 
/
create or replace procedure proc2 is 
begin 
   p.l ('calling proc1');
   proc1; 
EXCEPTION
   WHEN OTHERS THEN RAISE value_error;   
end;
/
create or replace procedure proc3 is 
begin 
   p.l ('calling proc2');
   proc2; 
exception
   when others then p.l(DBMS_UTILITY.FORMAT_ERROR_STACK);
end;
/
