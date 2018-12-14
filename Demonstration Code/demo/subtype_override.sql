DECLARE
   SUBTYPE l IS VARCHAR2 (100 BYTE);

   SUBTYPE l2 IS l (50 char);
   v l2 := 'abc';
begin
dbms_output.put_line (A => v); end;