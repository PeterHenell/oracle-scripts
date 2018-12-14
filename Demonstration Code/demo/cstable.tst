@@cstable.sf

create or replace procedure proc1 
is
   cs cs_tabtype;  
begin 
   cs := cstable;
   p.l (cs.count);
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

exec proc3
