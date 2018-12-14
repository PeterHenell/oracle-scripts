PACKAGE BODY remote_metadata
/*
Author: Ankur Shah [mailto:akshah@dhr.state.ga.us] 

Requirements :
¢	Directory object  ' EXPORT   defined with read, write grant to the
             user hosting REMOTE_METADATA.
¢	EXECUTE DBMS_METADATA privilege to the user hosting REMOTE_METADATA
¢	DBLINK needs to be established for the remote database.
*/
AS
-- Global Variables
   filehandle       UTL_FILE.file_type;
-- Exception initialization
   file_not_found   EXCEPTION;
   PRAGMA EXCEPTION_INIT (file_not_found, -1309);

-- Package-private routine to write a CLOB to an output file.
   PROCEDURE write_lob (doc IN CLOB)
   IS
      outstring   VARCHAR2 (32760);
      cloblen     NUMBER;
      offset      NUMBER           := 1;
      amount      NUMBER;
   BEGIN
      cloblen := DBMS_LOB.getlength (doc);

      WHILE cloblen > 0
      LOOP
         IF cloblen > 32760
         THEN
            amount := 32760;
         ELSE
            amount := cloblen;
         END IF;

         outstring := DBMS_LOB.SUBSTR (doc, amount, offset);
         UTL_FILE.put (filehandle, outstring);
         UTL_FILE.fflush (filehandle);
         offset := offset + amount;
         cloblen := cloblen - amount;
      END LOOP;

      RETURN;
   END;

-- Public routines

   -- GET_REMOTE_TABLES: Fetch DDL for <remote_schema> tables and their indexes.
   PROCEDURE get_remote_tables
   IS
      tableopenhandle    NUMBER;
      indexopenhandle    NUMBER;
      tabletranshandle   NUMBER;
      indextranshandle   NUMBER;
      schemaname         VARCHAR2 (30);
      tablename          VARCHAR2 (30);
      tableddls          SYS.ku$_ddls;
      tableddl           SYS.ku$_ddl;
      parseditems        SYS.ku$_parsed_items;
      indexddl           CLOB;
      vtablestr          VARCHAR2 (2000);
      idx                INTEGER              := 0;

      CURSOR curremotetabs
      IS
         (SELECT table_name
            FROM user_tables
          MINUS
          SELECT table_name
            FROM user_tables@dblink)
         ORDER BY table_name;
   BEGIN
--  open the output file... note that the 1st param. (dir. path) must be
--  included in the database's UTL_FILE_DIR init. parameter.
--
      BEGIN
         filehandle :=
                 UTL_FILE.fopen ('EXPORT', 'remotetablesddl.sql', 'w', 32760);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE file_not_found;
      END;

-- Open a handle for tables in the current schema.
      tableopenhandle := DBMS_METADATA.OPEN ('TABLE');
-- Call 'set_count' to request retrieval of one table at a time.
-- This call is not actually necessary because 1 is the default.
      DBMS_METADATA.set_count (tableopenhandle, 1);

-- Retrieve tables Remote Tables. When the filter is
-- 'NAME_EXPR', the filter value string must include the SQL operator. This
-- gives the caller flexibility to use LIKE, IN, NOT IN, subqueries, and so on.
/*dbms_metadata.set_filter(tableOpenHandle, 'NAME_EXPR', 'IN (''LIST OF REMOTE TABLES'')');*/
      FOR cur IN curremotetabs
      LOOP
         idx := idx + 1;

         IF idx = 1
         THEN
            vtablestr := '''' || cur.table_name || '''';
         ELSE
            vtablestr := vtablestr || ',' || '''' || cur.table_name || '''';
         END IF;
      END LOOP;

--dbms_output.put_line(substr('IN ('||vtablestr||')',1,225));
      DBMS_METADATA.set_filter (tableopenhandle
                              , 'NAME_EXPR'
                              , 'IN(' || vtablestr || ')'
                               );
-- Tell Metadata API to parse out each table's schema and name separately
-- so we can use them to set up the calls to retrieve its indexes.
      DBMS_METADATA.set_parse_item (tableopenhandle, 'SCHEMA');
      DBMS_METADATA.set_parse_item (tableopenhandle, 'NAME');
-- Add the DDL transform so we get SQL creation DDL
      tabletranshandle := DBMS_METADATA.add_transform (tableopenhandle, 'DDL');
-- Tell the XSL stylesheet we don't want physical storage information (storage,
-- tablespace, etc), and that we want a SQL terminator on each DDL. Notice that
-- these calls use the transform handle, not the open handle.

      -- dbms_metadata.set_transform_param(tableTransHandle,
        --   'SEGMENT_ATTRIBUTES', FALSE);
      DBMS_METADATA.set_transform_param (tabletranshandle
                                       , 'SQLTERMINATOR'
                                       , TRUE
                                        );

-- Ready to start fetching tables. We use the FETCH_DDL interface (rather than
-- FETCH_XML or FETCH_CLOB). This interface returns a SYS.KU$_DDLS; a table of
-- SYS.KU$_DDL objects. This is a table because some object types return
-- multiple DDL statements (like types / pkgs which have create header and
-- body statements). Each KU$_DDL has a CLOB containing the 'CREATE TABLE'
-- statement plus a nested table of the parse items specified. In our case,
-- we asked for two parse items; Schema and Name.
      LOOP
         tableddls := DBMS_METADATA.fetch_ddl (tableopenhandle);
         EXIT WHEN tableddls IS NULL;
                                     -- Get out when no more V41Tables tables
-- In our case, we know there is only one row in tableDDLs (a KU$_DDLS tbl obj)
-- for the current table. Sometimes tables have multiple DDL statements,
-- for example, if constraints are applied as ALTER TABLE statements,
-- but we didn't ask for that option.
-- So, rather than writing code to loop through tableDDLs,
-- we'll just work with the 1st row.
--
-- First, write the CREATE TABLE text to our output file, then retrieve the
-- parsed schema and table names.
         tableddl := tableddls (1);
         write_lob (tableddl.ddltext);
         parseditems := tableddl.parseditems;

-- Must check the name of the returned parse items as ordering isn't guaranteed
         FOR i IN 1 .. 2
         LOOP
            IF parseditems (i).item = 'SCHEMA'
            THEN
               schemaname := parseditems (i).VALUE;
            ELSE
               tablename := parseditems (i).VALUE;
            END IF;
         END LOOP;

-- Then use the schema and table names to set up a 2nd stream for retrieval of
-- the current table's indexes.
-- (Note that we don't have to specify a SCHEMA filter for the indexes,
-- Because SCHEMA defaults to the value of BASE_OBJECT_SCHEMA.)
         indexopenhandle := DBMS_METADATA.OPEN ('INDEX');
         DBMS_METADATA.set_filter (indexopenhandle
                                 , 'BASE_OBJECT_SCHEMA'
                                 , schemaname
                                  );
         DBMS_METADATA.set_filter (indexopenhandle
                                 , 'BASE_OBJECT_NAME'
                                 , tablename
                                  );
-- Add the DDL transform and set the same transform options we did for tables
         indextranshandle :=
                          DBMS_METADATA.add_transform (indexopenhandle, 'DDL');
   -- dbms_metadata.set_transform_param(indexTransHandle,
--                       'SEGMENT_ATTRIBUTES', FALSE);
         DBMS_METADATA.set_transform_param (indextranshandle
                                          , 'SQLTERMINATOR'
                                          , TRUE
                                           );

-- Retrieve index DDLs as CLOBs and write them to the output file.
         LOOP
            indexddl := DBMS_METADATA.fetch_clob (indexopenhandle);
            EXIT WHEN indexddl IS NULL;
            write_lob (indexddl);
         END LOOP;

-- Free resources allocated for index stream.
         DBMS_METADATA.CLOSE (indexopenhandle);
      END LOOP;

-- Free resources allocated for table stream and close output file.
      DBMS_METADATA.CLOSE (tableopenhandle);
      UTL_FILE.fclose (filehandle);
      RETURN;
   END;                                      -- of procedure get_remote_tables
END remote_metadata;