declare
   --v varchar2(60) := '{procpre}{del}{procsuf}';
   v varchar2(60) := '{procsuf}';
rec code%ROWTYPE; stat INTEGER;
begin
   sf_timer.start_timer;
   codecache.request_data (100);
   codecache.receive_data (rec, stat);
   p.l (rec.codedesc);
   p.l (stat);
	sf_timer.show_elapsed_time ('global cache');
end;
/
