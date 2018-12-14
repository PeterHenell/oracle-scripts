select count(*) from v$sqlarea;

declare
    id integer;
begin
    for indx in 1.. 10
    loop
       begin
       select            employee_id into id from employee where employee_id = indx;
       exception when others then null;
       end;
    end loop;
end;
/    
select count(*) from v$sqlarea;

