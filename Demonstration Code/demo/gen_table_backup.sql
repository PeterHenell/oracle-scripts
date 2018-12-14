CREATE OR REPLACE PROCEDURE gen_table_backup (
   table_name_in IN VARCHAR2
 , copy_prefix_in IN VARCHAR2 DEFAULT NULL
 , copy_suffix_in IN VARCHAR2 DEFAULT '_COPY'
 , create_now_in IN BOOLEAN DEFAULT FALSE
)
IS
   l_column_names   DBMS_SQL.varchar2s;

   FUNCTION column_names (table_name_in IN VARCHAR2)
      RETURN DBMS_SQL.varchar2s
   IS
      l_names   DBMS_SQL.varchar2s;
   BEGIN
      SELECT column_name
      BULK COLLECT INTO l_names
        FROM user_tab_columns
       WHERE table_name = table_name_in;

      RETURN l_names;
   END column_names;

   FUNCTION copy_table_name (table_name_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN copy_prefix_in || table_name_in || copy_suffix_in;
   END copy_table_name;

   PROCEDURE show_and_create (string_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (string_in);
      DBMS_OUTPUT.put_line ('/');

      IF create_now_in
      THEN
         EXECUTE IMMEDIATE string_in;
      END IF;
   END show_and_create;

   PROCEDURE make_copy (one_table_name_in IN VARCHAR2)
   IS
      l_ddl   VARCHAR2 (32767);
   BEGIN
      l_ddl :=
            'create table '
         || copy_table_name (one_table_name_in)
         || ' as select * from '
         || one_table_name_in
         || ' where 1 = 2';
      show_and_create (l_ddl);
      show_and_create
         (   'ALTER TABLE '
          || copy_table_name (one_table_name_in)
          || ' ADD (changed_on DATE, changed_by VARCHAR2(30), change_type VARCHAR2(6))'
         );
   END make_copy;

   PROCEDURE make_trigger (one_table_name_in IN VARCHAR2)
   IS
      l_ddl   VARCHAR2 (32767);

      FUNCTION insert_statement (change_type_in IN VARCHAR2)
         RETURN VARCHAR2
      IS
         l_insert   VARCHAR2 (32767);
      BEGIN
         l_insert :=
               'INSERT INTO '
            || copy_table_name (one_table_name_in)
            || ' VALUES (';

         FOR indx IN 1 .. l_column_names.COUNT
         LOOP
            l_insert :=
                  l_insert
               || CASE
                     WHEN indx = 1
                        THEN NULL
                     ELSE ','
                  END
               || ':'
               || CASE
                     WHEN change_type_in = 'INSERT'
                        THEN 'NEW'
                     ELSE 'OLD'
                  END
               || '.'
               || l_column_names (indx);
         END LOOP;

         l_insert := l_insert || ', sysdate, user, l_change_type);';
         RETURN l_insert;
      END insert_statement;
   BEGIN
      l_ddl :=
            'create or replace trigger '
         || one_table_name_in
         || '_audit before insert or update or delete on '
         || one_table_name_in
         || ' FOR EACH ROW DECLARE l_change_type VARCHAR2(6); BEGIN '
         || ' CASE WHEN INSERTING THEN l_change_type := ''INSERT'';
                   WHEN UPDATING THEN l_change_type := ''UPDATE'';
                   WHEN DELETING THEN l_change_type := ''DELETE'';
              END CASE; IF INSERTING THEN '
         || insert_statement ('INSERT')
         || ' ELSE '
         || insert_statement ('OTHER')
         || ' END IF; END;';
      show_and_create (l_ddl);
   END make_trigger;
BEGIN
   FOR table_rec IN (SELECT table_name
                       FROM user_tables
                      WHERE table_name LIKE table_name_in)
   LOOP
      l_column_names := column_names (table_rec.table_name);
      make_copy (table_rec.table_name);
      make_trigger (table_rec.table_name);
   END LOOP;
END gen_table_backup;
/