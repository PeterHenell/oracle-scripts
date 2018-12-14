/*
Results on large table query:

SQL> @open_fetch
Elapsed time for "OPEN" = 0 seconds.
Elapsed time for "FETCH?" = 141.97 seconds.

*/

@ssoo
DECLARE
   otmr tmr_t :=
      tmr_t.make ('OPEN');
   ftmr tmr_t :=
      tmr_t.make ('FETCH?');
   
   CURSOR lots_stuff
   IS
      select * 
        from plsql_profiler_data, employee
        ORDER BY total_time DESC;

   lots_rec lots_stuff%ROWTYPE;      
BEGIN
   otmr.go;
   OPEN lots_stuff;
   otmr.stop;
   ftmr.go;
   FETCH lots_stuff INTO lots_rec;
   ftmr.stop;
END;
/
