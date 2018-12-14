BEGIN
   sys.DBMS_OUTPUT.put_line (sys.DBMS_ASSERT.schema_name ('HR'));
   sys.DBMS_OUTPUT.put_line (sys.DBMS_ASSERT.sql_object_name ('EMPLOYEES'));
END;
/