BEGIN 
   --vsesstat.begin_measure_all;
   p.l (vsesstat.start_cpu);
   
   PLVddd.tbl (user, 'employee');

   --vsesstat.show_all_stats;
   p.l (vsesstat.end_cpu); 
   
   sf_timer.start_timer;
   PLVddd.tbl (user, 'employee');
   sf_timer.show_elapsed_time;
END;
/

