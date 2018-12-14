/* Provided by Bryn Llewellyn, PL/SQL Product Manager, Bryn.Llewellyn@quest.com */

create or replace procedure Show_Implicit_Cursor_Attrs(t in varchar2) is
  c number;
begin
  DBMS_Output.Put_Line(Chr(10)||t);
  c := Sql%RowCount;
  if c is null then
    DBMS_Output.Put_Line('Sql%RowCount: null');
  else
    DBMS_Output.Put_Line('Sql%RowCount: '||c);
  end if;

  if Sql%Found then
    DBMS_Output.Put_Line('Sql%Found:    true');
  else
    DBMS_Output.Put_Line('Sql%Found:    false');
  end if;

  if Sql%IsOpen then
    DBMS_Output.Put_Line('Sql%IsOpen:   true');
  else
    DBMS_Output.Put_Line('Sql%IsOpen:   false');
  end if;
end Show_Implicit_Cursor_Attrs;
/

create or replace procedure p is
begin
  Show_Implicit_Cursor_Attrs('In dynamic call to proc before implicit sql');
  -- deletes 6 rows
  delete from Employees where Manager_Id = 146;
  Show_Implicit_Cursor_Attrs('In dynamic call to proc after implicit sql');
end p;
/

create or replace procedure t is
  v Employees.Last_Name%type;
begin
  Show_Implicit_Cursor_Attrs('At start');

  declare n pls_integer := 0;
  begin
    for j in (select Last_Name from Employees where Employee_Id > 203) loop
      n := n + 1;
    Show_Implicit_Cursor_Attrs('During implicit cursor for loop');
    end loop;
    DBMS_Output.Put_Line(n||' rows found');
    Show_Implicit_Cursor_Attrs('After implicit cursor for loop');
  end;

  select Last_Name into v from Employees where Employee_Id = 100;
  Show_Implicit_Cursor_Attrs('After static select into');

  -- deletes 8 rows
  delete from Employees where Manager_Id = 122;
  Show_Implicit_Cursor_Attrs('After static delete');

  -- deletes 5 rows
  execute immediate 'delete from Employees where Manager_Id = 108';
  Show_Implicit_Cursor_Attrs('After ex im delete');

  declare Dummy number; c number := DBMS_Sql.Open_Cursor();
  begin
    DBMS_Sql.Parse(c, 'begin p(); end;', Dbms_Sql.Native);
    Dummy := DBMS_Sql.Execute(c);
    DBMS_Sql.CLose_Cursor(c);
  end;
  Show_Implicit_Cursor_Attrs('After dynamic call to proc that does implicit sql');

  rollback;
end t;
/

begin Show_Implicit_Cursor_Attrs(''); end;
/
begin p(); end;
/
begin Show_Implicit_Cursor_Attrs(''); end;
/
rollback
/

begin
  p();
  Show_Implicit_Cursor_Attrs('');
  rollback;
end;
/

begin t(); end;
/
