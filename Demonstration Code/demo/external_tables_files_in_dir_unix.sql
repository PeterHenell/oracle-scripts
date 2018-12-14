/* Provided by Bryn Llewellyn */

CONNECT Sys/Sys@112 AS SYSDBA
declare
  procedure Create_User(Who in varchar2) is
    User_Does_Not_Exist exception;
    pragma Exception_Init(User_Does_Not_Exist, -01918);
  begin
    begin
      execute immediate 'drop user '||Who||' cascade';
    exception when User_Does_Not_Exist then null; end;
    execute immediate '

      grant
        Unlimited Tablespace,
        Create Session,
        Create Table
      to '||Who||' identified by p

';
  end Create_User; 
begin
  Create_User('Usr');
end;
/
create or replace directory Temp as '/home/bllewell/External_Tables'
/
grant Read, Write on directory Temp to Usr
/

create or replace directory Program_Directory as '/home/bllewell/Program_Directory'
/
grant Read, Execute on directory Program_Directory to Usr
/

CONNECT Usr/p@112
CLEAR SCREEN

create table Departments_Ext (
   department_id        number(6),
   department_name      varchar2(20),
   department_location  varchar2(25) 
)
organization external
(type oracle_loader
 default directory Temp
 access parameters
 (
  records delimited by newline
  badfile 'departments.bad'
  discardfile 'departments.dis'
  logfile 'departments.log'
  fields terminated by ","  optionally enclosed by '"'
  (
   department_id        integer external(6),
   department_name      char(20),
   department_location  char(25)
  )
 )
 location ('departments.ctl')
)
reject limit unlimited
/

select *
  from Departments_Ext
/

declare
   l_department   departments_ext%rowtype;
begin
   select *
     into l_department
     from departments_ext
    where department_id = 1;

   DBMS_Output.Put_Line (l_department.department_name);
end;
/
--------------------------------------------------------------------------------
-- Part 2.

create table Files_In_Temp
(
  Permissions varchar2(4000),
  No_Of_Links varchar2(4000),
  Owner varchar2(4000),
  Grp varchar2(4000),
  Bytes varchar2(4000),
  YYYY_MM_DD varchar2(4000),
  HH24_MM_SS varchar2(4000),
  TZ_Offset varchar2(4000),
  Filename varchar2(4000)
)
organization external
( 
  type oracle_loader
  default directory Temp
  access parameters
    ( 
      records delimited by newline
      preprocessor temp: 'List_Files'
      fields terminated by whitespace
    )
    location ('List_Files')
)
reject limit unlimited
/

select *
from Files_In_Temp
where Filename <> 'placeholder.txt'
/

--------------------------------------------------------------------------------
/*

The file "List_Files" (do "chmod a+x List_Files")
-----------------------------------------------------------------

/bin/ls -l --full-time /home/bllewell/Temp | /bin/grep -v '^total'

*/
