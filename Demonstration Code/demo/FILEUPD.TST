BEGIN 
   sf_timer.start_timer;
   Upd_From_File ('d:\demo-seminar', 'fileupd.dat');
   sf_timer.show_elapsed_time ('Bulk');

   ROLLBACK;
   
   sf_timer.start_timer;
   Upd_From_File2 ('d:\demo-seminar', 'fileupd.dat');
   sf_timer.show_elapsed_time ('Individual');
   
   ROLLBACK;
/*
Lines in file: 2016
Bulk Elapsed: 2.48 seconds.
Individual Elapsed: 3.17 seconds.

.2016
.Bulk Elapsed: .89 seconds.
.Individual Elapsed: 1.34 seconds.
*/
END;
/

