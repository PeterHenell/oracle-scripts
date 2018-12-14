declare
  v Employees.Last_Name%type;
  cursor Cur(Id in Employees.Employee_Id%type) is
    select Last_Name into v from Employees where Employee_Id > Id;


  procedure Show_Cur_Attrs is
    Invalid_Cursor exception;
    pragma Exception_Init(Invalid_Cursor, -01001);
  begin
    DBMS_Output.Put_Line('');
    if Cur%IsOpen then
      DBMS_Output.Put_Line('Cur%IsOpen: true');
    else
      DBMS_Output.Put_Line('Cur%IsOpen: false');
    end if;


    begin
      if Cur%Found then
        DBMS_Output.Put_Line('Cur%Found: true');
      else
        DBMS_Output.Put_Line('Cur%Found: false');
      end if;
    exception when Invalid_Cursor then
      DBMS_Output.Put_Line('Invalid_Cursor caught for %Found');
    end;


    begin
      DBMS_Output.Put_Line('Cur%Rowcount: '||Cur%Rowcount);
    exception when Invalid_Cursor then
      DBMS_Output.Put_Line('Invalid_Cursor caught for %Rowcount');
    end;
  end Show_Cur_Attrs;
begin
  open Cur(203);
  loop
    fetch Cur into v;
    Show_Cur_Attrs();
    exit when Cur%NotFound;
  end loop;
  close Cur;
  Show_Cur_Attrs();
  rollback;
end;
/