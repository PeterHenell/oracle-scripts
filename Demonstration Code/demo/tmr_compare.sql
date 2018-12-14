DECLARE
   time_before BINARY_INTEGER;
   time_after BINARY_INTEGER;
BEGIN
   time_before := DBMS_UTILITY.GET_TIME;

   calc_totals;

   time_after := DBMS_UTILITY.GET_TIME;

   p.l (time_after - time_before);
END;

BEGIN
   capture_current_time;

   calc_totals;

   show_elapsed_time;
END;
