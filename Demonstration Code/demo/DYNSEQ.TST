CREATE OR REPLACE PROCEDURE test_seq_nextval (counter IN INTEGER)
IS
   n integer;
begin
   sf_timer.start_timer ('static');
   for i in 1 .. counter
   loop
      select aseq.nextval into n from dual;
   end loop;
   sf_timer.show_elapsed_time;

   sf_timer.start_timer ('dynamic');
   n := PLVdyn.nextseq ('aseq', counter); 
   sf_timer.show_elapsed_time;
end;
/