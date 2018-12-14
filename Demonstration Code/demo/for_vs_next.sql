DECLARE
	l_index	  pls_integer;
	l_source   DBMS_SQL.varchar2a;
BEGIN
	sf_timer.start_timer;

		 SELECT	 text
	BULK COLLECT INTO   l_source
			FROM	 all_source;

	sf_timer.show_elapsed_time (
		'Retrieved ' || TO_CHAR (l_source.COUNT) || ' elements'
	);
	--
	sf_timer.start_timer;

	FOR indx IN 1 .. l_source.COUNT
	LOOP
		NULL;
	END LOOP;

	sf_timer.show_elapsed_time ('FOR loop through collection');
	--
	sf_timer.start_timer;
	l_index := l_source.FIRST;

	WHILE (l_index IS NOT NULL)
	LOOP
		NULL;
		l_index := l_source.NEXT (l_index);
	END LOOP;

	sf_timer.show_elapsed_time ('Full collection scan with NEXT');
END;
/

/*
Retrieved 3079394 elements - Elapsed CPU : 11.14 seconds.
FOR loop through collection - Elapsed CPU : .05 seconds.
Full collection scan with NEXT - Elapsed CPU : .48 seconds.
*/