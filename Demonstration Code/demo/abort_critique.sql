
CONNECT scott/tiger@orcl102
create package CC_Control is
  high_ambition   constant boolean := true;
  ideal_for_high  constant boolean := true;
end CC_Control;
/
create table log_table (seq integer, text varchar2(4000))
/
create sequence log_table_seq
/
create trigger log_table_trg
  before
  insert
  on log_table
  for each row
begin
  select log_table_seq.nextval into :new.seq from dual;
end log_table_trg;
/
create package Error_Logging is
  procedure Reset;
  $if CC_Control.high_ambition $then
    procedure Deep_Level_Logger (unit in varchar2, info in varchar2);
  $else
    procedure Top_Level_Logger;
  $end
end Error_Logging;
/
create package body Error_Logging is
  first_time boolean;
  procedure Reset is
  begin
    first_time := true;
  end Reset;


  procedure Log_It (t in varchar2) is
    pragma autonomous_transaction;
  begin
    insert into log_table (text) values (t);
    commit;
  end Log_It;


  $if CC_Control.high_ambition $then
    procedure Deep_Level_Logger (unit in varchar2, info in varchar2) is
    begin
      Log_It (Chr(10)||Rpad ('Deep error log from '||unit||' ', 80, '-'));
      Log_It ('Info: '||info);


      if first_time then
        Log_It (Dbms_Utility.Format_Error_Stack());
        Log_It (Dbms_Utility.Format_Error_Backtrace());
        Log_It (Dbms_Utility.Format_Call_Stack());
        first_time := false;
      end if;


      $if not CC_Control.ideal_for_high $then
        raise program_error;
      $end
    end Deep_Level_Logger;


  $else
    procedure Top_Level_Logger is
    begin
      Log_It (Chr(10)||Rpad ('Top level error log ', 80, '-')||Chr(10));
      Log_It (Dbms_Utility.Format_Error_Stack());
      -- Backtrace not very interesting while we've done "raise"
      -- after each call to Error_Logging.Deep_Level_Logger()
      Log_It (Dbms_Utility.Format_Error_Backtrace());
      Log_It (Rpad ('-', 80, '-')||Chr(10));
    end Top_Level_Logger;
  $end
end Error_Logging;
/


create procedure Bad is
begin
  raise too_many_rows;


$if CC_Control.high_ambition $then
  exception when others then
    Error_Logging.Deep_Level_Logger ('Bad', 'some stuff about "Bad"');
    $if CC_Control.ideal_for_high $then
      raise;
    $end
$end
end Bad;
/
create procedure P1 is
begin
  Bad();
$if CC_Control.high_ambition $then
  exception when others then
    Error_Logging.Deep_Level_Logger ('P1', 'some stuff about "P1"');
    $if CC_Control.ideal_for_high $then
      raise;
    $end
$end
end P1;
/
create procedure P2 is
begin
  P1();
$if CC_Control.high_ambition $then
  exception when others then
    Error_Logging.Deep_Level_Logger ('P2', 'some stuff about "P2"');
    $if CC_Control.ideal_for_high $then
      raise;
    $end
$end
end P2;
/
create procedure P3 is
begin
  P2();
$if CC_Control.high_ambition $then
  exception when others then
    Error_Logging.Deep_Level_Logger ('P3', 'some stuff about "P3"');
    $if CC_Control.ideal_for_high $then
      raise;
    $end
$end
end P3;
/
create procedure Top_Level_Call is
begin
  Error_Logging.Reset();
  P3();
exception when others then
  $if CC_Control.high_ambition $then
    null;
  $else
    Error_Logging.Top_Level_Logger();
  $end
  Dbms_Output.Put_Line ('We''re sorry we can''t process your request right now.
                         Please try again later');
end Top_Level_Call;
/


select 'No invalid objects' t from dual
  where not exists (select 1 from user_objects where status <> 'VALID')
union
select 'Invalid objects' t from dual
  where exists (select 1 from user_objects where status <> 'VALID')
union
select object_type||': '||object_name t
  from user_objects where status <> 'VALID'
union
select Rpad ('-', 80, '-') t from dual
/



PROMPT
PROMPT __ NOT high_ambition ____________________________________________________________________
PROMPT
create or replace package CC_Control is
  high_ambition constant boolean := false;
end CC_Control;
/
alter procedure Top_Level_Call compile reuse settings
/
CONNECT scott/tiger@orcl102
PROMPT Exception bubbles up to client
begin P3(); end;
/
-- truncate not actually needed. log_table has no rows here.
truncate table log_table
/
begin Top_Level_Call(); end;
/
select text from log_table order by seq
/


PROMPT
PROMPT __ ideal_for_high _______________________________________________________________________
PROMPT
create or replace package CC_Control is
  high_ambition   constant boolean := true;
  ideal_for_high  constant boolean := true;
end CC_Control;
/
alter procedure Top_Level_Call compile reuse settings
/
truncate table log_table
/
CONNECT scott/tiger@orcl102
begin Top_Level_Call(); end;
/
select text from log_table order by seq
/


PROMPT
PROMPT __ Not ideal_for_high ___________________________________________________________________
PROMPT
create or replace package CC_Control is
  high_ambition   constant boolean := true;
  ideal_for_high constant boolean := false;
end CC_Control;
/
alter procedure Top_Level_Call compile reuse settings
/
truncate table log_table
/
CONNECT scott/tiger@orcl102
begin Top_Level_Call(); end;
/
select text from log_table order by seq
/