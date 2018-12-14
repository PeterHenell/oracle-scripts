connect sys/sys
desc dual
select * from dual;
insert into dual values ('Y')
/
select count(*) from dual;
exec p.l(sysdate);
rollback;
exec p.l(sysdate);
