This file shows one possible way that you can utilize 
dynamic PL/SQL. The first version of process_lineitem
relies on an extremely long IF statement to determine 
which of the line item-specific procedures should be
executed. 

This is, by the way, a "real world" example. The 
process_lineitem procedure was so large that it often
would not even compile.

The second process_lineitem utilizes DBMS_SQL to 
squeeze the program down to a mere 3 executable statements.

PROCEDURE process_lineitem (line_in IN INTEGER)
IS
BEGIN
   IF line_in = 1
	THEN
	   process_line1; 

   ELSIF line_in = 2
	THEN
	   process_line2;
   ...
   ELSIF line_in = 2045
   THEN
      process_line2045;
   END IF;
END;

PROCEDURE process_lineitem (line_in IN INTEGER)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
	fdbk PLS_INTEGER;
BEGIN
   DBMS_SQL.PARSE (
	   cur,
		'BEGIN process_line' || line_in || '; END;',
		DBMS_SQL.NATIVE
		);
    
	fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_SQL.CLOSE_CURSOR (cur);
END;

/* Formatted on 2002/01/24 14:18 (Formatter Plus v4.6.0) */
PROCEDURE process_lineitem (line_in IN INTEGER)
IS
BEGIN
   EXECUTE IMMEDIATE    
      'BEGIN process_line '|| line_in ||'; END';
END;

