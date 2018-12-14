BEGIN
   RAISE NO_DATA_FOUND;
   RAISE STANDARD.NO_DATA_FOUND;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Could not find data!');
   WHEN UTL_FILE.invalid_operation
   THEN
      NULL;
   WHEN DBMS_SQL.inconsistent_type
   THEN
      NULL;
END;
/