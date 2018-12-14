@pl.sp
@bpl.sp
@tabeq.sf
@ssoo
set feedback off

create table employee2 as select * from employee;

exec bpl (tabeq ('employee', 'employee2'));

delete from employee2 where rownum < 5;

exec bpl (tabeq ('employee', 'employee2'));

drop table employee2;