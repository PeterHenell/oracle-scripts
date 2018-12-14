SPOOL plsql_memory.log

CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'drop user Usr cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE '
    grant Create Session, Resource to Usr identified by p';

   EXECUTE IMMEDIATE '
    grant Select on sys.v_$sesstat to Usr';

   EXECUTE IMMEDIATE '
    grant Select on sys.v_$statname to Usr';
    
   EXECUTE IMMEDIATE '
    grant Select on sys.v_$session to Usr';
END;
/

CONNECT Usr/p

SET serveroutput on format wrapped

ALTER SESSION SET plsql_ccflags = 'vcsize:4000'
/

CREATE OR REPLACE PACKAGE plsql_memory_demo
IS
   TYPE strings_aat IS TABLE OF VARCHAR2 (5)                      --$$vcsize)
      INDEX BY PLS_INTEGER;

   g_strings   strings_aat;
END plsql_memory_demo;
/

CREATE OR REPLACE PROCEDURE plsql_memory_analysis (
   set_local_in    IN   BOOLEAN
 , set_global_in   IN   BOOLEAN
 , fuum_in         IN   BOOLEAN
)
IS
   c_title   CONSTANT VARCHAR2 (32767)
      :=    CASE
               WHEN set_local_in
                  THEN 'SET'
               ELSE 'NO'
            END
         || ' LOCAL - '
         || CASE
               WHEN set_global_in
                  THEN 'SET'
               ELSE 'NO'
            END
         || ' GLOBAL - '
         || CASE
               WHEN fuum_in
                  THEN 'FUUM'
               ELSE 'NO FUUM'
            END;
   l_strings          plsql_memory_demo.strings_aat;
   l_uga_start        PLS_INTEGER;
   l_pga_start        PLS_INTEGER;

   FUNCTION statval (statname_in IN VARCHAR2)
      RETURN NUMBER
   IS
      l_memory   PLS_INTEGER;
   BEGIN
      SELECT s.VALUE
        INTO l_memory
        FROM SYS.v_$sesstat s, SYS.v_$statname n, SYS.v_$session SID
       WHERE s.statistic# = n.statistic#
         AND s.SID = SID.SID
         AND n.NAME = statname_in
         AND SID.audsid = USERENV ('SESSIONID');

      RETURN l_memory;
   END statval;

   PROCEDURE show_results
   IS
   BEGIN
      DBMS_OUTPUT.put_line (c_title);
      DBMS_OUTPUT.put_line ('   Local array count = ' || l_strings.COUNT);
      DBMS_OUTPUT.put_line (   '   Packaged array count = '
                            || plsql_memory_demo.g_strings.COUNT
                           );
      DBMS_OUTPUT.put_line ('');
      DBMS_OUTPUT.put_line (   '   Change in UGA memory: '
                            || TO_CHAR (  statval ('session uga memory')
                                        - l_uga_start
                                       )
                           );
      DBMS_OUTPUT.put_line (   '   Change in PGA memory: '
                            || TO_CHAR (  statval ('session pga memory')
                                        - l_pga_start
                                       )
                           );
      DBMS_OUTPUT.put_line ('');
   END show_results;
BEGIN
   IF fuum_in
   THEN
      DBMS_SESSION.free_unused_user_memory;
   END IF;

   l_uga_start := statval ('session uga memory');
   l_pga_start := statval ('session pga memory');

   FOR i IN 1 .. 10000
   LOOP
      FOR j IN 1 .. 10
      LOOP
         IF set_local_in
         THEN
            l_strings (i + j * 100000 - 1) := TO_CHAR (i);
         END IF;

         IF set_global_in
         THEN
            plsql_memory_demo.g_strings (i + j * 100000 - 1) := TO_CHAR (i);
         END IF;
      END LOOP;
   END LOOP;

   show_results;
   plsql_memory_demo.g_strings.DELETE;
END plsql_memory_analysis;
/

CONNECT Usr/p

SET serveroutput on format wrapped

BEGIN
   plsql_memory_analysis (set_local_in       => TRUE
                        , set_global_in      => FALSE
                        , fuum_in            => TRUE
                         );
/*
SET LOCAL - NO GLOBAL - FUUM
   Local array count = 100000
   Packaged array count = 0

   Change in UGA memory: 0
   Change in PGA memory: 5439488
*/
END;
/

CONNECT Usr/p

SET serveroutput on format wrapped

BEGIN
   plsql_memory_analysis (set_local_in       => FALSE
                        , set_global_in      => TRUE
                        , fuum_in            => TRUE
                         );
/*
NO LOCAL - SET GLOBAL - FUUM
   Local array count = 0
   Packaged array count = 100000

   Change in UGA memory: 5498976
   Change in PGA memory: 5505024
*/
END;
/

CONNECT Usr/p

SET serveroutput on format wrapped

BEGIN
   plsql_memory_analysis (set_local_in       => TRUE
                        , set_global_in      => TRUE
                        , fuum_in            => TRUE
                         );
/*
SET LOCAL - SET GLOBAL - FUUM
   Local array count = 100000
   Packaged array count = 100000

   Change in UGA memory: 5498976
   Change in PGA memory: 10944512
*/
END;
/

CONNECT Sys/quest AS SYSDBA

DROP USER Usr CASCADE
/

SPOOL OFF