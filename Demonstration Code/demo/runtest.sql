set serveroutput on
set verify off

declare
  filename varchar2(100) := '&1';
  dot pls_integer;
  slash pls_integer;
begin

  --Strip off the directory
  slash := instr(filename, '\', -1, 1);
  if slash <> 0 then
    filename := substr(filename, slash + 1);
  end if;

  --Strip off the extension
  dot := instr(filename, '.', 1, 1);
  if dot <> 0 then
    filename := substr(filename, 1, dot - 1);
  end if;
  
  --Strip off ut prefix 
  if filename like utconfig.prefix || '%' then
    filename := substr(filename, length(utconfig.prefix) + 1);
  end if;
  
  --Now run the test
  utplsql.test(filename);

end;
/

pause Press any key to close

exit
