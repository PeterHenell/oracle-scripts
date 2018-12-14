REM FROM Bryn Llewellyn

connect sys/sys as sysdba
grant resource, connect to big_hr identified by big_hr;

connect scott/tiger
grant select on employees to big_hr;
grant select on departments to big_hr;

connect big_hr/big_hr
drop table employees;
drop table departments;
create table employees as select * from scott.employees;
create index employees_department_id on employees ( department_id );

create table departments (
  department_id    number not null,
  department_name  varchar2(30) not null,
  manager_id       number(6),
  location_id      number(4) );

insert into departments ( select * from scott.departments );

--------------------------------------------------------------------------------

declare /* stamp out 2 million rows */
  type departments_t is table of departments%rowtype;
  v_departments departments_t;
begin
  select *
    bulk collect into v_departments
    from departments;

  for j in 1..100000 loop
    forall j in v_departments.First()..v_departments.Last()
      insert into departments values v_departments(j);
  end loop;
end;
/
update departments set department_id = rownum;
select count(*) from departments /* 2,800,028 */;
commit;

--------------------------------------------------------------------------------

create or replace procedure P ( p_salary in employees.salary%type ) is
begin
  for j in (
    select employee_id from employees
      where salary > p_salary
      and department_id in
        (
          select department_id from departments
            where Lower(department_name) like '%sales%'
            or    Lower(department_name) like '%market%'
        )
      order by employee_id
  )
  loop
    Dbms_Output.Put_Line ( j.employee_id );
  end loop;
end P;
/
Set ServerOutput On
declare
  t0 number; t1 number;
begin
  t0 := Dbms_Utility.Get_Time();
  P ( 8000 );
  t1 := Dbms_Utility.Get_Time();
  Dbms_Output.Put_Line ( 'ellapsed: ' || To_Char( (t1-t0)/100.0 ) );
end;
/
-- ellapsed: 12.2
-- ellapsed: 12.09
-- ellapsed: 12.11
--------------------------------------------------------------------------------

create or replace type department_ids_tab is
  table of number;
/

create or replace package Pkg_1 is
  procedure P ( p_salary in employees.salary%type );
end Pkg_1;
/
create or replace package body Pkg_1 is
  g_department_ids department_ids_tab;

  procedure P ( p_salary in employees.salary%type ) is
  begin
    for j in (
      select employee_id from employees
        where salary > p_salary
        and department_id in
        (
          select * from
            table ( cast ( g_department_ids as department_ids_tab ))
        )
      order by employee_id
    )
    loop
      Dbms_Output.Put_Line ( j.employee_id );
    end loop;
  end P;

begin
  select distinct department_id
    bulk collect into g_department_ids
    from departments
    where Lower(department_name) like '%sales%'
    or    Lower(department_name) like '%market%';
  Dbms_Output.Put_Line ( g_department_ids.Count() );
end Pkg_1;
/

Set ServerOutput On
declare
  t0 number; t1 number;
begin
  t0 := Dbms_Utility.Get_Time();
  Pkg_1.P ( 8000 );
  t1 := Dbms_Utility.Get_Time();
  Dbms_Output.Put_Line ( 'ellapsed: ' || To_Char( (t1-t0)/100.0 ) );
end;
/
-- ellapsed: 15.09 FIRST TIME
-- ellapsed: 2.58 2nd
-- ellapsed: 2.61 3rd time
-- ellapsed: 2.62 4th time
--------------------------------------------------------------------------------

drop table t;
create global temporary table t
  on commit preserve rows
  as select department_id from departments where 1=2;

create or replace package Pkg_2 is
  procedure P ( p_salary in employees.salary%type );
end Pkg_2;
/
create or replace package body Pkg_2 is
  procedure P ( p_salary in employees.salary%type ) is
  begin
    for j in (
      select employee_id from employees
        where salary > p_salary
        and department_id in ( select * from t )
        order by employee_id )
    loop
      Dbms_Output.Put_Line ( j.employee_id );
    end loop;
  end P;
begin
  execute immediate 'truncate table t';
  insert into t (
    select distinct department_id
      from departments
      where Lower(department_name) like '%sales%'
      or    Lower(department_name) like '%market%' );
end Pkg_2;
/

Set ServerOutput On
declare
  t0 number; t1 number;
begin
  t0 := Dbms_Utility.Get_Time();
  Pkg_2.P ( 8000 );
  t1 := Dbms_Utility.Get_Time();
  Dbms_Output.Put_Line ( 'ellapsed: ' || To_Char( (t1-t0)/100.0 ) );
end;
/
-- ellapsed: 35.58 FIRST TIME
-- ellapsed: 1.59 2nd time
-- ellapsed: 1.61 3rd time
-- ellapsed: 1.58 4th
