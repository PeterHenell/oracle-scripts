PROCEDURE file_to_table 
   (loc_in IN VARCHAR2, file_in IN VARCHAR2, table_in IN names_tabtype)
IS
	/* Open file and get handle right in declaration */
	names_file CONSTANT UTL_FILE.FILE_TYPE := 
		UTL_FILE.FOPEN (loc_in, file_in, 'R');

	/* counter used to create the Nth name. */
	line_counter INTEGER := 1;

   end_of_file BOOLEAN := FALSE;
BEGIN
	WHILE NOT end_of_file
	LOOP
		get_nextline (names_file, table_in(line_counter), end_of_file);
		line_counter := line_counter + 1;
	END LOOP;
	UTL_FILE.FCLOSE (names_file);
END;
