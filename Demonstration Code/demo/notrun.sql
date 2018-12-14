DECLARE
   /* Displays the lines of code in a routine that were never executed.
      You must first run the program unit through the profiler with
      a block something like this:

      BEGIN
         DBMS_OUTPUT.put_line (DBMS_PROFILER.START_PROFILER ('run name'));
         your_code_here;
         DBMS_OUTPUT.put_line (DBMS_PROFILER.STOP_PROFILER);
      END;
   */
   CURSOR lines_cur (
      nm IN VARCHAR2)
   IS
      SELECT owner, name, line
        FROM all_source
       WHERE name LIKE UPPER (nm)
      MINUS
      SELECT unit_owner, unit_name, p1.line#
        FROM plsql_profiler_data p1, plsql_profiler_units p2
       WHERE     p1.runid = p2.runid
             AND p2.unit_number = p1.unit_number
             AND p2.unit_name LIKE UPPER (nm);

   v_text   all_source.text%TYPE;
BEGIN
   DBMS_OUTPUT.put_line ('Code in "&&firstparm" that was not run');

   FOR rec IN lines_cur ('&&firstparm')
   LOOP
      SELECT text
        INTO v_text
        FROM all_source
       WHERE owner = rec.owner AND name = rec.name AND line = rec.line;

      IF (RTRIM (v_text) IS NOT NULL)
      THEN
         DBMS_OUTPUT.put_line (RTRIM (v_text, CHR (10)));
      END IF;
   END LOOP;
END;
/