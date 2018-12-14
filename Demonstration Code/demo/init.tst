/* 
   The first time this is run, especially after a fresh compile, 
   you should see the first access take more time, and then the
	second access less time (probably 0 hundredths of seconds, actually).

   If you the script a second time, both accesses with take "no" time.
*/
begin
   sf_timer.start_timer;
   p.l (sessinit.printer);
   p.l (sessinit.show_lov);
   sf_timer.show_elapsed_time;
   
   sf_timer.start_timer;
   p.l (sessinit.printer);
   p.l (sessinit.show_lov);
   sf_timer.show_elapsed_time;
end;
/
