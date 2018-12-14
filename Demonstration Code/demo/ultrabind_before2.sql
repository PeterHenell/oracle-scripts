DECLARE
/*
Need to generate code like this:

DECLARE
   TYPE my_rec_t IS RECORD (
      employee_id NUMBER,
	  last_name VARCHAR2(25),
	  etc. 
	  for each column in employees table
	  );
   l_record my_rec_t;	  
BEGIN	  
   NULL;
END;   
*/
   l_copy_table_name all_objects.object_name%TYPE := 'COPY_QUT#DMR_TABLE';
   l_table_name all_objects.object_name%TYPE := 'QUT#DMR_TABLE';
   l_owner all_objects.owner%TYPE := USER;
   l_code VARCHAR2 ( 32767 );
BEGIN
   l_code :=
         'DECLARE'
      || CHR ( 10 )
      || '   TYPE '
      || l_rec_name || ' IS RECORD ('
      || CHR ( 10 );
	  -- Gen declaration for each column in table
	  l_code := l_code || CHR ( 10 )
      || '   );'|| CHR ( 10 )
	  || '   l_record ' || l_rec_type
      || '      EXECUTE IMMEDIATE ''DROP TABLE '
      || l_copy_table_name
      || ''';'
      || CHR ( 10 )
      || '   EXCEPTION WHEN OTHERS THEN NULL;'
      || CHR ( 10 )
      || '   END;'
      || CHR ( 10 )
      || '   EXECUTE IMMEDIATE'
      || CHR ( 10 )
      || '      ''CREATE TABLE '
      || l_copy_table_name
      || '    AS '
      || CHR ( 10 )
      || '      SELECT * FROM '
      || l_owner
      || '.'
      || l_table_name
      || ''';'
      || CHR ( 10 )
      || 'END;';
   DBMS_OUTPUT.put_line ( l_code );
END;
