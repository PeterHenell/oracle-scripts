/*
@@tmr81.ot
@@thisuser.pkg
*/
create or replace procedure thisuser_test (count_in in pls_integer := 100000)
is
   v VARCHAR2(30);
   --
   -- Default constructor
   func_tmr tmr_t := NEW tmr_t (NULL, NULL, NULL, NULL, count_in,'Packaged Function');
   --
   -- Replacement for constructor
   constant_tmr tmr_t := tmr_t.make ('Packaged Constant',count_in);
   --
   -- User-defined constructor (9iR2 only)
   every_tmr tmr_t := NEW tmr_t ('USER Function', count_in);
BEGIN
   func_tmr.go;
   FOR indx IN 1 .. count_in
   LOOP
      v := thisuser.name;
   END LOOP;
   func_tmr.stop;

   constant_tmr.go;
   FOR indx IN 1 .. count_in
   LOOP
      v := thisuser.cname;
   END LOOP;
   constant_tmr.stop;
   
   every_tmr.go;
   FOR indx IN 1 .. count_in
   LOOP
      v := USER;
   END LOOP;
   every_tmr.stop;
END;
/
begin
   thisuser_test (1000);
   thisuser_test (100000);
end;
/
