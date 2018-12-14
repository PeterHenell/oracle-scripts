-- Version 1: maximum concatenation

DECLARE
/*
Need to generate code like this:

BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE COPY_QUT#DMR_TABLE';
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   EXECUTE IMMEDIATE
      'CREATE TABLE COPY_QUT#DMR_TABLE AS
          SELECT * FROM HR.QUT#DMR_TABLE';
END;

*/
   l_copy_table_name all_objects.object_name%TYPE := 'COPY_QUT#DMR_TABLE';
   l_table_name all_objects.object_name%TYPE := 'QUT#DMR_TABLE';
   l_owner all_objects.owner%TYPE := USER;
   l_code VARCHAR2 ( 32767 );
BEGIN
   l_code :=
         'BEGIN'
      || CHR ( 10 )
      || '   BEGIN'
      || CHR ( 10 )
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
/

-- Version 2: minimal concatenation

DECLARE
/*
Need to generate code like this:

BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE COPY_QUT#DMR_TABLE';
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   EXECUTE IMMEDIATE
      'CREATE TABLE COPY_QUT#DMR_TABLE AS
          SELECT * FROM HR.QUT#DMR_TABLE';
END;

*/
   l_copy_table_name all_objects.object_name%TYPE := 'COPY_QUT#DMR_TABLE';
   l_table_name all_objects.object_name%TYPE := 'QUT#DMR_TABLE';
   l_owner all_objects.owner%TYPE := USER;
   l_code VARCHAR2 ( 32767 );
BEGIN
   l_code :=
         'BEGIN
   BEGIN
      EXECUTE IMMEDIATE ''DROP TABLE '
      || l_copy_table_name
      || ''';
      EXCEPTION WHEN OTHERS THEN NULL;
   END;
   EXECUTE IMMEDIATE
      ''CREATE TABLE '
      || l_copy_table_name
      || '    AS 
SELECT * FROM '
      || l_owner
      || '.'
      || l_table_name
      || ''';
END;';
   DBMS_OUTPUT.put_line ( l_code );
END;
