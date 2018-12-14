DECLARE
   l_start_time   PLS_INTEGER;
BEGIN
   time_before := DBMS_UTILITY.get_time;
   -- Do stuff here!
   DBMS_OUTPUT.put_line (DBMS_UTILITY.get_time - time_before);
END;