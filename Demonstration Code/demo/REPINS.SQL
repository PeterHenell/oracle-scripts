drop table empshort;

create table Empshort (ssn varchar2(9), name varchar2(20));

insert into empshort values ('999999999', 'Steven');

declare
   repid integer := plvrep.dbtabid('scott.empshort', '=empshort', true, true);

begin
   plvrep.open(repid, plvrep.c_readwrite);

   --plvrep.setseg(repid, 1, '123456789');
   --plvrep.setseg(repid, 2, 'sschulze');
   plvrep.put(repid);

   plvrep.destroy(repid);

end;
/
select * from empshort;