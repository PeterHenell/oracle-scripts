create table steven1 (nm varchar2(30));
create table steven2 (nm varchar2(30));
create or replace procedure steven is begin p.l ('Hello!'); end;
/
desc steven1
desc steven2
execute steven;

set serveroutput on
execute PLVdyn.drop_object ('%', 'STEVEN%');

desc steven1
desc steven2
execute steven;

