DECLARE
   c_template varchar2(32767)
      := 
'BEGIN
   BEGIN
      EXECUTE IMMEDIATE ''DROP TABLE <copy_table_name>'';
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   EXECUTE IMMEDIATE
      ''CREATE TABLE <copy_table_name> AS
          SELECT * FROM <owner>.<exp_table_name>'';
END;';
   l_copy_table_name all_objects.object_name%TYPE := 'COPY_QUT#DMR_TABLE';
   l_table_name all_objects.object_name%TYPE := 'QUT#DMR_TABLE';
   l_owner all_objects.owner%TYPE := USER;
   l_code VARCHAR2 ( 32767 );
BEGIN
   ultrabind.clear_settings;
   ultrabind.set_delimiters ( '<', '>' );
   ultrabind.bind_text ( 'copy_table_name', l_copy_table_name );
   ultrabind.bind_text ( 'exp_table_name', l_table_name );
   ultrabind.bind_text ( 'owner', l_owner );
   l_code := ultrabind.substituted_string ( c_template );
   DBMS_OUTPUT.put_line ( l_code );
END;
