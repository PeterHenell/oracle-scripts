CREATE OR REPLACE PACKAGE dbms_errlog_helper
   AUTHID CURRENT_USER
/*
| File name: dbms_errlog_helper.sql
|
| Author: Steven Feuerstein, steven.feuerstein@quest.com
|         www.ToadWorld.com/SF
|
| Overview: Run this program to create a database error log table
|   (via the DBMS_ERRLOG mechanism) so that you can log errors for
|   this table and continue processing DML statements. It will also
|   generate a helper package for the specified table that you can
|   use after running the DML statement(s) so you can easily view
|   and manage any errors that are raised. Finally, it automatically
|   adds audit columns created_by and created_on so you can keep
|   track of where and when the errors were added, and a trigger is
|   defined on the table to populate those columns.
|
| TO DO
|   * Execute grants on error log table so that anyone who can make
|     a change to the DML table can insert into the log table.
|
| Modification History:
|   Date        Who         What
|
| Dec 2008      SF          Stop creating the trigger with a static name.
|                           Instead, the name varies by the table name.
|                           Add option to clear error log after retrieval.
|
| Mar 2008      SF          Create audit columns, create trigger,
|                           change to AUTHID CURRENT_USER.
|
| Feb 2008      SF          Convert to package that offers ability
|                           to immediately compile package rather
|                           than return CLOBS.
|
| Oct 3 2007    SF          Carve out from q$error_manager to make it
|                           available as a stand-alone utility.
|
*/
IS
   PROCEDURE create_objects (dml_table_name           VARCHAR2
                           , err_log_table_name       VARCHAR2 DEFAULT NULL
                           , err_log_table_owner      VARCHAR2 DEFAULT NULL
                           , err_log_table_space      VARCHAR2 DEFAULT NULL
                           , skip_unsupported         BOOLEAN DEFAULT FALSE
                           , overwrite_log_table      BOOLEAN DEFAULT TRUE
                           , err_log_package_name     VARCHAR2 DEFAULT NULL
                           , err_log_package_spec OUT DBMS_SQL.varchar2s
                           , err_log_package_body OUT DBMS_SQL.varchar2s
                            );

   PROCEDURE create_objects (dml_table_name           VARCHAR2
                           , err_log_table_name       VARCHAR2 DEFAULT NULL
                           , err_log_table_owner      VARCHAR2 DEFAULT NULL
                           , err_log_table_space      VARCHAR2 DEFAULT NULL
                           , skip_unsupported         BOOLEAN DEFAULT FALSE
                           , overwrite_log_table      BOOLEAN DEFAULT TRUE
                           , err_log_package_name     VARCHAR2 DEFAULT NULL
                           , err_log_package_spec OUT VARCHAR2
                           , err_log_package_body OUT VARCHAR2
                            );

   PROCEDURE create_objects (dml_table_name        VARCHAR2
                           , err_log_table_name    VARCHAR2 DEFAULT NULL
                           , err_log_table_owner   VARCHAR2 DEFAULT NULL
                           , err_log_table_space   VARCHAR2 DEFAULT NULL
                           , skip_unsupported      BOOLEAN DEFAULT FALSE
                           , overwrite_log_table   BOOLEAN DEFAULT TRUE
                           , err_log_package_name  VARCHAR2 DEFAULT NULL
                            );
END dbms_errlog_helper;
/

CREATE OR REPLACE PACKAGE BODY dbms_errlog_helper
IS
   SUBTYPE maxvarchar2_t IS VARCHAR2 (32767);

   PROCEDURE create_objects (dml_table_name           VARCHAR2
                           , err_log_table_name       VARCHAR2 DEFAULT NULL
                           , err_log_table_owner      VARCHAR2 DEFAULT NULL
                           , err_log_table_space      VARCHAR2 DEFAULT NULL
                           , skip_unsupported         BOOLEAN DEFAULT FALSE
                           , overwrite_log_table      BOOLEAN DEFAULT TRUE
                           , err_log_package_name     VARCHAR2 DEFAULT NULL
                           , err_log_package_spec OUT DBMS_SQL.varchar2s
                           , err_log_package_body OUT DBMS_SQL.varchar2s
                            )
   /*
   | File name: dbms_errlog_helper.sql
   |
   | Overview: Run this program to create a database error log table
   |   (via the DBMS_ERRLOG mechanism) so that you can log errors for
   |   this table and continue processing DML statements. It will also
   |   generate a helper package for the specified table that you can
   |   use after running the DML statement(s) so you can easily view
   |   and manage any errors that are raised
   |
   | Author(s): Steven Feuerstein
   |
   | Modification History:
   |   Date        Who         What
   | Feb 2008      SF          Convert to package that offers ability
   |                           to immediately compile package rather
   |                           return CLOBS.A
   | Oct 3 2007    SF          Carve out from q$error_manager to make it
   |                           available as a stand-alone utility.
   |
   */
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      c_package_name CONSTANT maxvarchar2_t
            := SUBSTR (NVL (err_log_package_name, 'ELP$_' || dml_table_name)
                     , 1
                     , 30
                      ) ;
      c_errlog_table_name CONSTANT maxvarchar2_t
            := SUBSTR (NVL (err_log_table_name, 'ERR$_' || dml_table_name)
                     , 1
                     , 30
                      ) ;
      c_qual_errlog_table_name CONSTANT maxvarchar2_t
            := CASE
                  WHEN err_log_table_owner IS NULL THEN NULL
                  ELSE err_log_table_owner || '.'
               END
               || c_errlog_table_name ;
      l_spec   DBMS_SQL.varchar2s;
      l_body   DBMS_SQL.varchar2s;

      PROCEDURE create_error_log
      IS
      BEGIN
         IF overwrite_log_table
         THEN
            BEGIN
               EXECUTE IMMEDIATE 'DROP TABLE ' || c_qual_errlog_table_name;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;

         /*
         Create the error log; any errors raised by this program will
         terminate the rest of the processing of this helper program.
         */
         DBMS_ERRLOG.create_error_log (
            dml_table_name        => dml_table_name
          , err_log_table_name    => err_log_table_name
          , err_log_table_owner   => err_log_table_owner
          , err_log_table_space   => err_log_table_space
          , skip_unsupported      => skip_unsupported
         );

         /* Alter the error log table to add audit columns. */
         EXECUTE IMMEDIATE 'ALTER TABLE ' || NVL (err_log_table_owner, USER) 
            || '.' || c_errlog_table_name || ' ADD created_by VARCHAR2(30)';

         EXECUTE IMMEDIATE 'ALTER TABLE ' || NVL (err_log_table_owner, USER) 
            || '.' || c_errlog_table_name || ' ADD created_on DATE';

         /* Add Call Stack: Thanks, IFMC! */
         EXECUTE IMMEDIATE 'ALTER TABLE ' || NVL (err_log_table_owner, USER) 
            || '.' || c_errlog_table_name || ' ADD call_stack VARCHAR2(4000)';

         /* Add the trigger to update these columns. */
         EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER ' 
         || SUBSTR (dml_table_name || '$BEF_EL', 1, 30) 
         || ' BEFORE INSERT OR UPDATE ON ' || NVL (err_log_table_owner, USER) 
         || '.' || c_errlog_table_name || ' FOR EACH ROW BEGIN :NEW.created_by := USER; ' 
         || ' :NEW.created_on := SYSDATE; ' || ' :NEW.call_stack := ' 
         || 'SUBSTR (dbms_utility.Format_call_stack (), 1, 4000); END;';
      END create_error_log;

      PROCEDURE generate_spec (package_name_in IN     VARCHAR2
                             , code_out           OUT DBMS_SQL.varchar2s
                              )
      IS
         PROCEDURE add_line (line_in IN VARCHAR2)
         IS
         BEGIN
            l_spec (l_spec.COUNT + 1) := line_in;
         END add_line;
      BEGIN
         add_line ('CREATE OR REPLACE PACKAGE ' || c_package_name || ' IS ');
         add_line(   'SUBTYPE error_log_r IS '
                  || c_qual_errlog_table_name
                  || '%ROWTYPE;');
         add_line(   'TYPE error_log_tc IS TABLE OF '
                  || c_qual_errlog_table_name
                  || '%ROWTYPE;');
         add_line ('PROCEDURE clear_error_log;');
         add_line ('FUNCTION error_log_contents (');
         add_line ('  ORA_ERR_NUMBER$_IN IN PLS_INTEGER DEFAULT NULL');
         add_line (', ORA_ERR_OPTYP$_IN IN VARCHAR2 DEFAULT NULL');
         add_line (', ORA_ERR_TAG$_IN IN VARCHAR2 DEFAULT NULL');
         add_line (', where_in IN VARCHAR2 DEFAULT NULL');
         add_line (', preserve_log_in IN BOOLEAN DEFAULT TRUE');
         add_line (') RETURN error_log_tc;');
         -- add_line ('PROCEDURE dump_error_log;');
         add_line ('END ' || c_package_name || ';');
         code_out := l_spec;
      END generate_spec;

      PROCEDURE generate_body (package_name_in IN     VARCHAR2
                             , code_out           OUT DBMS_SQL.varchar2s
                              )
      IS
         PROCEDURE add_line (line_in IN VARCHAR2)
         IS
         BEGIN
            l_body (l_body.COUNT + 1) := line_in;
         END add_line;
      BEGIN
         add_line (
            'CREATE OR REPLACE PACKAGE BODY ' || c_package_name || ' IS '
         );
         add_line ('PROCEDURE clear_error_log');
         add_line ('IS PRAGMA AUTONOMOUS_TRANSACTION; BEGIN ');
         add_line ('DELETE FROM ' || c_qual_errlog_table_name || '; COMMIT;');
         add_line ('END clear_error_log;');
         add_line ('FUNCTION error_log_contents (');
         add_line ('  ORA_ERR_NUMBER$_IN IN PLS_INTEGER DEFAULT NULL');
         add_line (', ORA_ERR_OPTYP$_IN IN VARCHAR2 DEFAULT NULL');
         add_line (', ORA_ERR_TAG$_IN IN VARCHAR2 DEFAULT NULL');
         add_line (', where_in IN VARCHAR2 DEFAULT NULL');
         add_line (', preserve_log_in IN BOOLEAN DEFAULT TRUE');
         add_line (') RETURN error_log_tc');
         add_line (' IS ');
         add_line('l_query      VARCHAR2 (32767)
         :=    ''SELECT * FROM '
                  || c_qual_errlog_table_name
                  || ' WHERE ( ora_err_number$ LIKE :ora_err_number$_in
              OR :ora_err_number$_in IS NULL');
         add_line(') AND (   ora_err_optyp$ LIKE :ora_err_optyp$_in
              OR :ora_err_optyp$_in IS NULL )');
         add_line('AND (ora_err_tag$ LIKE :ora_err_tag$_in OR :ora_err_tag$_in IS NULL)''
            || CASE WHEN where_in IS NULL');
         add_line('THEN NULL ELSE '' AND '' || REPLACE (where_in, '''''''', '''''''''''') END;
      l_log_rows   error_log_tc;');
         add_line (
            'BEGIN EXECUTE IMMEDIATE l_query BULK COLLECT INTO l_log_rows'
         );
         add_line('USING ORA_ERR_NUMBER$_IN, ORA_ERR_NUMBER$_IN,
               ORA_ERR_OPTYP$_IN, ORA_ERR_OPTYP$_IN,
               ORA_ERR_TAG$_IN, ORA_ERR_TAG$_IN; RETURN l_log_rows;');
         add_line ('IF NOT preserve_log_in THEN clear_error_log(); END IF;');
         add_line('EXCEPTION WHEN OTHERS THEN
         DBMS_OUTPUT.put_line (''Error retrieving log contents for :'');
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
         DBMS_OUTPUT.put_line (l_query);
         RAISE;');
         add_line ('END error_log_contents; END ' || c_package_name || ';');
         code_out := l_body;
      END generate_body;
   BEGIN
      create_error_log;
      generate_spec (c_package_name, err_log_package_spec);
      generate_body (c_package_name, err_log_package_body);
   END create_objects;

   PROCEDURE create_objects (dml_table_name           VARCHAR2
                           , err_log_table_name       VARCHAR2 DEFAULT NULL
                           , err_log_table_owner      VARCHAR2 DEFAULT NULL
                           , err_log_table_space      VARCHAR2 DEFAULT NULL
                           , skip_unsupported         BOOLEAN DEFAULT FALSE
                           , overwrite_log_table      BOOLEAN DEFAULT TRUE
                           , err_log_package_name     VARCHAR2 DEFAULT NULL
                           , err_log_package_spec OUT VARCHAR2
                           , err_log_package_body OUT VARCHAR2
                            )
   IS
      l_spec          DBMS_SQL.varchar2s;
      l_body          DBMS_SQL.varchar2s;
      l_spec_string   maxvarchar2_t;
      l_body_string   maxvarchar2_t;
   BEGIN
      create_objects (dml_table_name         => dml_table_name
                    , err_log_table_name     => err_log_table_name
                    , err_log_table_owner    => err_log_table_owner
                    , err_log_table_space    => err_log_table_space
                    , skip_unsupported       => skip_unsupported
                    , overwrite_log_table    => overwrite_log_table
                    , err_log_package_name   => err_log_package_name
                    , err_log_package_spec   => l_spec
                    , err_log_package_body   => l_body
                     );

      FOR indx IN 1 .. l_spec.COUNT
      LOOP
         l_spec_string :=
            CASE
               WHEN indx = 1 THEN l_spec (indx)
               ELSE l_spec_string || CHR (10) || l_spec (indx)
            END;
      END LOOP;

      FOR indx IN 1 .. l_body.COUNT
      LOOP
         l_body_string :=
            CASE
               WHEN indx = 1 THEN l_body (indx)
               ELSE l_body_string || CHR (10) || l_body (indx)
            END;
      END LOOP;

      err_log_package_spec := l_spec_string;
      err_log_package_body := l_body_string;
   END create_objects;

   PROCEDURE create_objects (dml_table_name        VARCHAR2
                           , err_log_table_name    VARCHAR2 DEFAULT NULL
                           , err_log_table_owner   VARCHAR2 DEFAULT NULL
                           , err_log_table_space   VARCHAR2 DEFAULT NULL
                           , skip_unsupported      BOOLEAN DEFAULT FALSE
                           , overwrite_log_table   BOOLEAN DEFAULT TRUE
                           , err_log_package_name  VARCHAR2 DEFAULT NULL
                            )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      l_spec   DBMS_SQL.varchar2s;
      l_body   DBMS_SQL.varchar2s;

      PROCEDURE compile_statement (array_in IN DBMS_SQL.varchar2s)
      IS
         l_cur   PLS_INTEGER := DBMS_SQL.open_cursor;
      BEGIN
         DBMS_SQL.parse (l_cur
                       , array_in
                       , 1
                       , array_in.COUNT
                       , TRUE
                       , DBMS_SQL.native
                        );
         DBMS_SQL.close_cursor (l_cur);
      END compile_statement;
   BEGIN
      create_objects (dml_table_name         => dml_table_name
                    , err_log_table_name     => err_log_table_name
                    , err_log_table_owner    => err_log_table_owner
                    , err_log_table_space    => err_log_table_space
                    , skip_unsupported       => skip_unsupported
                    , overwrite_log_table    => overwrite_log_table
                    , err_log_package_name   => err_log_package_name
                    , err_log_package_spec   => l_spec
                    , err_log_package_body   => l_body
                     );
      compile_statement (l_spec);
      compile_statement (l_body);
   END create_objects;
END dbms_errlog_helper;
/