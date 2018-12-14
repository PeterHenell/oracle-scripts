create or replace procedure Ppp is cursor c1a is
    select
    1
    +
    2
    FROM
    strange_name;

  cursor c1b is select 1 + 2 from strange_name; cursor c1c is SELECT 1    +    2 FROM
    strange_name;
  
  
  
  
  
  cursor c2a is SELECT        'x'
                  from strange_name;
              procedure temp_show (
              n
              in
              number) is begin
              dbms_output.put_line (sysdate                   ); end temp_show;
  
begin
  for j in c1a loop null; end loop;
  for rec in (
  select * from employees) loop dbms_output.put_line (rec.last_name); end loop;
  for j in c1c loop null; end loop; temp_show();

end Ppp;
/

begin ppp; end;