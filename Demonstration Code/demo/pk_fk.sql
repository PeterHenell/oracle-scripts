/* Original and bulk of script by Bryn Llewellyn, PL/SQL Product Manager */

drop table lov CASCADE CONSTRAINTS 
/

create table Lov(
  Lov_Member integer constraint Lov_PK primary key,
  Val varchar2(10))
/

drop table Things CASCADE CONSTRAINTS
/

create table Things(
  PK integer constraint Things_PK primary key,
  Lov_Member integer,
  constraint Things_FK foreign key (Lov_Member) references Lov(Lov_Member))
/


begin
  insert into Lov(Lov_Member, Val) values(0, 'zero');
  insert into Lov(Lov_Member, Val) values(1, 'one');
  insert into Lov(Lov_Member, Val) values(2, 'two');
  insert into Lov(Lov_Member, Val) values(3, 'three');
  insert into Lov(Lov_Member, Val) values(4, 'four');
  insert into Lov(Lov_Member, Val) values(5, 'five');
  insert into Lov(Lov_Member, Val) values(6, 'six');
  insert into Lov(Lov_Member, Val) values(7, 'seven');
  insert into Lov(Lov_Member, Val) values(8, 'eight');
  insert into Lov(Lov_Member, Val) values(9, 'nine');
end;
/
declare
  n pls_integer := -1;
begin
  for j in 1..100000 loop
    for k in 0..9 loop
      n := n + 1;
      insert into Things(PK, Lov_Member) values (n, k);
    end loop;
  end loop;
  commit;
end;
/


<<Approach_1>>declare
  cursor Cur is
    select PK, Val
      from Things inner join LoV using (Lov_Member)
      where PK between 1004 and 10130
      order by PK;
  type Results_t is table of Cur%rowtype;
  Results Results_t;
  v varchar2(100);
  s number;
begin
  s := dbms_utility.get_cpu_time;
  open Cur;
  fetch Cur bulk collect into Results;
  for j in 1..Results.Count() loop
    v := Lpad(Results(j).PK, 5)||' '||Results(j).Val;
  end loop;
  close Cur;
  dbms_output.put_line ('Join of tables elapsed time = ' || to_char (dbms_utility.get_cpu_time - s));
end Approach_1;
/


<< Approach_2>>declare
  cursor Lov_Cur is
    select Lov_Member, Val from Lov;
  type My_Lov_t is table of Lov_Cur%rowtype;
  My_Lov My_Lov_t;


  type My_Lov2_t is table of Lov.Val%type index by pls_integer;
  My_Lov2 My_Lov2_t;


  cursor Things_Cur is
    select PK, Lov_Member
      from Things
      where PK between 1004 and 1013
      order by PK;
  type My_Things_t is table of Things_Cur%rowtype;
  My_Things My_Things_t;
  v varchar2(100);
  s number;
begin
  s := dbms_utility.get_cpu_time;
  -- Get the Lov once and for all.
  open Lov_Cur;
  fetch Lov_Cur bulk collect into My_Lov;
  close Lov_Cur;
  for j in 1..My_Lov.Count() loop
    declare n pls_integer := My_Lov(j).Lov_Member;
    begin
      My_Lov2(n) := My_Lov(j).Val;
    end;
  end loop;


  -- Now avoid the join query...
  open Things_Cur;
  fetch Things_Cur bulk collect into My_Things;
  close Things_Cur;


  -- ...and instead map Lov_Member to Val using a PL/SQL table.
  for j in 1..My_Things.Count() loop
    v := Lpad(My_Things(j).PK, 5)||' '||My_Lov2(My_Things(j).Lov_Member);
  end loop;
  dbms_output.put_line ('Cache and no join elapsed time = ' || to_char (dbms_utility.get_cpu_time - s));
end Approach_2;
/