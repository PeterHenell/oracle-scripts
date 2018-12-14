PROCEDURE exec_line_proc (line IN INTEGER)
IS
BEGIN
   IF line = 1 THEN exec_line1; END IF;
   IF line = 2 THEN exec_line2; END IF;
   IF line = 3 THEN exec_line3; END IF;
   ...
   IF line = 2045 THEN exec_line2045; END IF;
END;