DECLARE
   profile_id INTEGER;
BEGIN
   DBMS_PROFILER.START_PROFILER ('SWYG', 'GEN', profile_id);
   mg_build_pkg.initialize (USER);
   mg_build_pkg.gen_grp;

   DBMS_PROFILER.STOP_PROFILER;
END;
/
   
