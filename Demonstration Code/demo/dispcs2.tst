create or replace package pkg1 is 
procedure proc1;
end; 
/
create or replace procedure proc1 is  
begin 
   raise_application_error (
   -20300, 'this is great', false);
end; 
/
create or replace procedure proc2 is 
begin 
   p.l ('calling proc1');
   proc1; 
end;
/
create or replace procedure proc3 is 
begin 
   p.l ('calling proc2');
   proc2; 
end;
/

rem drop package pkg1;
rem drop procedure proc1;
rem drop procedure proc2;
rem drop procedure proc3;