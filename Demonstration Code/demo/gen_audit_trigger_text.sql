CREATE OR REPLACE PROCEDURE gen_audit_trigger_text (
   table_in IN VARCHAR2
 , owner_in IN VARCHAR2 := USER
 , program_name_in IN VARCHAR2 := 'process_data'
)
IS
   c_rowtype   CONSTANT VARCHAR2 (100)     := table_in || '%ROWTYPE';
   l_columns            DBMS_SQL.varchar2s;

   PROCEDURE gen_copy_proc (old_or_new_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (   'FUNCTION copy_'
                            || old_or_new_in
                            || ' RETURN '
                            || c_rowtype
                            || ' IS l_return '
                            || c_rowtype
                            || '; BEGIN '
                           );

      FOR indx IN 1 .. l_columns.COUNT
      LOOP
         DBMS_OUTPUT.put_line (   '   l_return.'
                               || l_columns (indx)
                               || ' := '
                               || ':'
                               || old_or_new_in
                               || '.'
                               || l_columns (indx)
                               || ';'
                              );
      END LOOP;

      DBMS_OUTPUT.put_line ('RETURN l_return;');
      DBMS_OUTPUT.put_line ('END copy_' || old_or_new_in || ';');
   END gen_copy_proc;
BEGIN
   SELECT LOWER (column_name) column_name
   BULK COLLECT INTO l_columns
     FROM all_tab_columns
    WHERE owner = UPPER (owner_in) AND table_name = UPPER (table_in);

   DBMS_OUTPUT.put_line ('DECLARE');
   DBMS_OUTPUT.put_line ('   my_Old ' || table_in || '%ROWTYPE;');
   DBMS_OUTPUT.put_line ('   my_New ' || table_in || '%ROWTYPE;');
   gen_copy_proc ('old');
   gen_copy_proc ('new');
   DBMS_OUTPUT.put_line ('BEGIN');
   DBMS_OUTPUT.put_line ('   my_Old := copy_Old ();');
   DBMS_OUTPUT.put_line ('   my_New := copy_New ();');
   DBMS_OUTPUT.put_line ('   ' || program_name_in || '(my_Old, my_new);');
   DBMS_OUTPUT.put_line ('END;');
END gen_audit_trigger_text;
/

BEGIN
   gen_audit_trigger_text ('employees');
END;
/