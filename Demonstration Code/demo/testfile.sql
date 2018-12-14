DECLARE
   f UTL_FILE.FILE_TYPE;
BEGIN
   f := PLVfile.fopen ('new.txt', 'w');
   PLVfile.put_line (f, RPAD ('abc', 32000, 'abc'));
   PLVfile.fclose (f);
END;
/