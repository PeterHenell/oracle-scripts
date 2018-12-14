connect system/manager
create role updemployee;
grant updemployee to public;
connect demo/demo
grant update on employee to updemployee;
connect scott/tiger
set serveroutput on
update demo.employee set salary = salary;
create or replace procedure updsal
is
begin
   update demo.employee set salary = salary;
end;
/
exec plvvu.err
exec updsal
connect demo/demo
grant update on employee to scott;
connect scott/tiger
set serveroutput on
update demo.employee set salary = salary;
create or replace procedure updsal
is
begin
   update demo.employee set salary = salary;
end;
/
exec plvvu.err
exec updsal
connect demo/demo
revoke update on employee from scott;
connect scott/tiger
set serveroutput on
update demo.employee set salary = salary;
create or replace procedure updsalx
is
begin
   update demo.employee set salary = salary;
end;
/
exec plvvu.err
exec updsal


