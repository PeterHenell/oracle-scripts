/*
@@tmr81.ot
@@thisuser.pkg
*/
create or replace procedure thisuser_test (count_in in pls_integer := 100000)
is
   v VARCHAR2(30);
   --
   -- Default constructor
   func_tmr tmr_t := NEW tmr_t (NULL, NULL, NULL, NULL, count_in, 'Packaged Function');
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
/* 
Oracle 11g results:

Timings in seconds for "Packaged Function":
Elapsed = .05 - per rep .0000005
CPU     = .05 - per rep .0000005
Timings in seconds for "Packaged Constant":
Elapsed = .02 - per rep .0000002
CPU     = .01 - per rep .0000001
Timings in seconds for "USER Function":
Elapsed = 3.32 - per rep .0000332
CPU     = 3.24 - per rep .0000324

*/   
end;
/
