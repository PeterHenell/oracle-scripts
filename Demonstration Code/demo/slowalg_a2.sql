Two options for improvement:

1. At a minimum use ELSIF:

PROCEDURE exec_line_proc (indx IN INTEGER)
IS
BEGIN
   IF indx = 1 THEN exec_line1; 
   ELSIF indx = 2 THEN exec_line2; 
   ELSIF indx = 3 THEN exec_line3; 
   ...
   ELSIF indx = 2045 THEN exec_line2045;
   END IF;
END;

2. Even better, use dynamic PL/SQL:

*** Prior to Oracle8i, with DBMS_SQL:

PROCEDURE process_lineitem (line_in IN INTEGER)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
	fdbk PLS_INTEGER;
BEGIN
   DBMS_SQL.PARSE (
	   cur,
		'BEGIN exec_line' || line_in || '; END;',
		DBMS_SQL.NATIVE
		);

	fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_SQL.CLOSE_CURSOR (cur);
END;

*** With Oracle8i, use native dynamic SQL:

PROCEDURE process_lineitem (line_in IN INTEGER)
IS
BEGIN
   EXECUTE IMMEDIATE
		'BEGIN exec_line' || line_in || '; END;';
END;

NOTE: In both of these cases, you COULD end up with hundreds or thousands
      of different cursors (anonymous PL/SQL blocks) for each of the different
      line numbers. This can cause problems in terms of the SGA managing all
      of that information.







