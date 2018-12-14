PROCEDURE create_file 
	(loc_in IN VARCHAR2, file_in IN VARCHAR2, line_in IN VARCHAR2 := NULL)
IS
	file_handle UTL_FILE.FILE_TYPE;
BEGIN
	/* 
	|| Open the file, write a single line and close the file.
	*/
	FILE_HANDLE := UTL_FILE.FOPEN (loc_in, file_in, 'W');
	IF line_in IS NOT NULL
	THEN
		UTL_FILE.PUT_LINE (file_handle, line_in);
	ELSE
		UTL_FILE.PUT_LINE 
			(file_handle, 'I make my disk light blink, therefore I am.');
	END IF;
	UTL_FILE.FCLOSE (file_handlee);
END;
