create or replace package pkg1 is 
procedure proc1;
end; 
/
create or replace package body pkg1 is 
procedure proc1 is  begin 
raise no_data_found;
exception
when others then plvexc.recNgo;
end;
end; 
/
rem grant execute on pkg1 to scott;

rem connect scott/tiger
rem create synonym pkg1 for demo.pkg1;
rem drop synonym pkg1;
create or replace procedure proc1 is begin 
pkg1.proc1; end;
/
sho err
create or replace procedure proc2 is begin proc1; end;
/
create or replace procedure proc3 is begin proc2;end;
/
rem exec proc3;

rem drop package pkg1;
rem drop procedure proc1;
rem drop procedure proc2;
rem drop procedure proc3;