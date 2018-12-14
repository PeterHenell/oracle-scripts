 create table pkysone
 (a integer primary key, b date, c varchar2(25))
/
 rem drop table pkysmult;
 create table pkysmult
 (a integer, b date, c varchar2(25), multilat integer, hiredate date
 default sysdate, lastsal number default 0,
 constraint pkmult primary key (a, b, c))
/    
create index pk1 on pkysmult(multilat);
create unique index pk2 on pkysmult(lastsal);
declare
it plvinds.ind_tabtype;
ct plvinds.indcol_tabtype;
r plvinds.indcol_rectype;
begin
   plvinds.fortab ('pkysmult', it, ct);
   for i in it.first .. it.last
   loop
      p.l (it(i).index_name);
      p.l (it(i).table_type);
      for j in 1 .. it(i).column_count
      loop
         r := plvinds.nthcol (ct, i, j);
         p.l (r.column_name);
      end loop; 
   end loop;
END;
/   
 