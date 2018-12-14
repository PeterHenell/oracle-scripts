DROP TABLE pt_id_name
/
CREATE TABLE pt_id_name (
   ID NUMBER,
   name VARCHAR2(100))
/
CREATE UNIQUE INDEX pt_id_name_index1 ON pt_id_name (ID)
/
CREATE UNIQUE INDEX pt_id_name_index2 ON pt_id_name (name)
/
DROP TABLE gtt_id_name
/
CREATE GLOBAL TEMPORARY TABLE gtt_id_name (
   ID NUMBER,
   name VARCHAR2(100))
/
CREATE UNIQUE INDEX gtt_id_name_index1 ON gtt_id_name (ID)
/
CREATE UNIQUE INDEX gtt_id_name_index2 ON gtt_id_name (name)
/

DECLARE
   c_size PLS_INTEGER := 100000;

   TYPE id_name_aat IS TABLE OF pt_id_name%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_id_name id_name_aat;

   --
   TYPE by_name_aat IS TABLE OF pt_id_name%ROWTYPE
      INDEX BY pt_id_name.name%TYPE;

   l_by_name by_name_aat;
   --
   l_record pt_id_name%ROWTYPE;
   --
   l_start PLS_INTEGER;
   l_count PLS_INTEGER;
   l_index pt_id_name.name%TYPE;

   PROCEDURE show_memory
   /*
   SELECT privileges required on:
      SYS.v_$session
      SYS.v_$sesstat
      SYS.v_$statname

   Here are the statements you should run from a SYSDBA account:

   GRANT SELECT ON SYS.v_$sesstat TO schema;
   GRANT SELECT ON SYS.v_$statname TO schema;
   */
   IS
      l_memory VARCHAR2 ( 100 );
   BEGIN
      SELECT nm.name || ': ' || TO_CHAR ( st.VALUE , '999,999,999,999')
        INTO l_memory
        FROM SYS.v_$sesstat st, SYS.v_$statname nm
       WHERE st.statistic# = nm.statistic#
         AND st.SID = SYS_CONTEXT ( 'USERENV', 'SID' )
         AND nm.name = 'session pga memory';

      DBMS_OUTPUT.put_line ( l_memory );
   END show_memory;

   PROCEDURE show_elapsed ( NAME_IN IN VARCHAR2 )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    '"'
                             || NAME_IN
                             || '": '
                             || TO_CHAR (   (   DBMS_UTILITY.get_cpu_time
                                              - l_start
                                            )
                                          / 100
                                        )
                             || ' seconds'
                           );
   END show_elapsed;
BEGIN
   DBMS_SESSION.free_unused_user_memory;
   DBMS_OUTPUT.put_line
      (    'Compare persistent table, global temporary table and collection for '
        || c_size
        || ' rows of data'
      );
   show_memory;
   --
   -- POPULATE STRUCTURES
   --
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      INSERT INTO pt_id_name
           VALUES ( indx, 'WOW' || indx );
   END LOOP;

   show_elapsed ( 'Populate persistent table' );
   show_memory;
   --
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      INSERT INTO gtt_id_name
           VALUES ( indx, 'WOW' || indx );
   END LOOP;

   show_elapsed ( 'Populate temporary table' );
   show_memory;
   --
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      l_id_name ( indx ).ID := indx;
      l_id_name ( indx ).name := 'WOW' || indx;
   END LOOP;

   show_elapsed ( 'Populate collection' );
   show_memory;
   --
   -- COUNT OF ROWS
   --
   DBMS_OUTPUT.put_line ( '' );
   l_start := DBMS_UTILITY.get_cpu_time;

   SELECT COUNT ( * )
     INTO l_count
     FROM pt_id_name;

   show_elapsed ( 'Get count of rows in persistent table' );
   l_start := DBMS_UTILITY.get_cpu_time;

   SELECT COUNT ( * )
     INTO l_count
     FROM gtt_id_name;

   show_elapsed ( 'Get count of rows in temporary table' );
   l_start := DBMS_UTILITY.get_cpu_time;
   l_count := l_id_name.COUNT;
   show_elapsed ( 'Get count of rows in collection' );
   --
   -- LOOKUP ROW BY INDEX
   --
   DBMS_OUTPUT.put_line ( '' );
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      SELECT *
        INTO l_record
        FROM pt_id_name
       WHERE ID = indx;
   END LOOP;

   show_elapsed ( 'Read each row in persistent table' );
   --
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      SELECT *
        INTO l_record
        FROM gtt_id_name
       WHERE ID = indx;
   END LOOP;

   show_elapsed ( 'Read each row in temporary table' );
   --
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      l_record := l_id_name ( indx );
   END LOOP;

   show_elapsed ( 'Read each row in collection' );
   --
   -- LOOKUP ROW BY NAME
   --
   DBMS_OUTPUT.put_line ( '' );
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      SELECT *
        INTO l_record
        FROM pt_id_name
       WHERE name = 'WOW' || indx;
   END LOOP;

   show_elapsed ( 'Lookup row in persistent table by name (unique index)' );
   --
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      SELECT *
        INTO l_record
        FROM gtt_id_name
       WHERE name = 'WOW' || indx;
   END LOOP;

   show_elapsed ( 'Lookup row in temporary table by name (unique index)' );
   --
   l_start := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_size
   LOOP
      l_by_name ( l_id_name ( indx ).name ) := l_id_name ( indx );
   END LOOP;

   l_index := l_by_name.FIRST;

   WHILE ( l_index IS NOT NULL )
   LOOP
      l_record := l_by_name ( l_index );
      l_index := l_by_name.NEXT ( l_index );
   END LOOP;

   show_elapsed ( 'Lookup row in collection by name (work from copy)' );
   --
   ROLLBACK;
/*
10g Release 2 Results:

Compare persistent table, global temporary table and collection for 100000 rows of data

session pga memory:        1,105,492
"Populate persistent table": 7.49 seconds
session pga memory:        1,236,564
"Populate temporary table": 5.89 seconds
session pga memory:        1,105,492
"Populate collection": .17 seconds
session pga memory:       29,351,508

"Get count of rows in persistent table": 0 seconds
"Get count of rows in temporary table": .02 seconds
"Get count of rows in collection": 0 seconds

"Read each row in persistent table": 3.95 seconds
"Read each row in temporary table": 4.06 seconds
"Read each row in collection": .05 seconds

"Lookup row in persistent table by name (unique index)": 3.94 seconds
"Lookup row in temporary table by name (unique index)": 4.03 seconds
"Lookup row in collection by name (work from copy)": .4 seconds

*/   
END;
/
