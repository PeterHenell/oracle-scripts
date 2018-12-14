DECLARE
   l_start_time   PLS_INTEGER;
   l_end_time     PLS_INTEGER;
BEGIN
   l_start_time := DBMS_UTILITY.get_time;
   DBMS_OUTPUT.put_line (l_start_time);

   FOR indx IN 1 .. 1000000
   LOOP
      l_end_time := DBMS_UTILITY.get_time;
   END LOOP;

   l_end_time := DBMS_UTILITY.get_time;
   DBMS_OUTPUT.put_line (l_end_time);

   DBMS_OUTPUT.put_line (l_end_time - l_start_time);
END;
/

/* Encapsulated format */

DECLARE
   l_end_time     PLS_INTEGER;
BEGIN
   sf_timer.start_timer;

   FOR indx IN 1 .. 1000000
   LOOP
      l_end_time := DBMS_UTILITY.get_time;
   END LOOP;

   sf_timer.show_elapsed_time ('Call gt 1000000 times');
END;
/