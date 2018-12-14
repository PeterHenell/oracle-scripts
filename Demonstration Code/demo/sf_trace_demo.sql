CREATE OR REPLACE FUNCTION betwnstr (string_in   IN VARCHAR2,
                                     start_in    IN INTEGER,
                                     end_in      IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   /* Check to see if trace is turned on before calling
      the trace procedure, to minimize runtime overhead
      when tracing is disabled. */

   IF sf_trace_pkg.trace_is_on
   THEN
      sf_trace_pkg.trace_activity ('betwnstr string', string_in);
   END IF;

   sf_trace_pkg.trace_activity_force ('betwnstr start-end',
                                      start_in || '-' || end_in);

   RETURN (SUBSTR (string_in, start_in, end_in - start_in + 1));
END betwnstr;
/

BEGIN
   sf_trace_pkg.turn_on_trace;
   sf_trace_pkg.put_line (betwnstr ('abcdefg', 3, 5));
   sf_trace_pkg.turn_on_trace (context_filter_in => 'xyz');
   sf_trace_pkg.put_line (betwnstr ('abcdefg', 3, 5));
   sf_trace_pkg.turn_off_trace;
END;
/

  SELECT context || '-' || text
    FROM sf_trace
ORDER BY created_on
/

DELETE FROM sf_trace
/

COMMIT
/

/* Now write to screen */

BEGIN
   sf_trace_pkg.turn_on_trace (
      context_filter_in   => 'betwnstr',
      send_trace_to_in    => sf_trace_pkg.c_to_screen);
   sf_trace_pkg.put_line (betwnstr ('abcdefg', 3, 5));
   sf_trace_pkg.turn_off_trace;
END;
/

/* Demonstrate replacement for dbms_output.put_line */

BEGIN
   sf_trace_pkg.put_line ('abc');
   sf_trace_pkg.put_line (SYSDATE);
   sf_trace_pkg.put_line (TRUE);
END;
/

/* Generate trace of IN arguments */

BEGIN
   sf_trace_pkg.gen_trace_call ('BETWNSTR');
END;
/