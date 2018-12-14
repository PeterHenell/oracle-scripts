CONNECT scott/tiger

CREATE OR REPLACE PROCEDURE analyze_vc2_memory_usage (
   varchar2_size_in   IN   PLS_INTEGER
 , spread_in          IN   PLS_INTEGER DEFAULT 0
 , iterations_in      IN   PLS_INTEGER DEFAULT 1000
)
IS
   TYPE t20 IS TABLE OF VARCHAR2 (20)
      INDEX BY BINARY_INTEGER;

   TYPE t4000 IS TABLE OF VARCHAR2 (4000)
      INDEX BY BINARY_INTEGER;

   TYPE t4001 IS TABLE OF VARCHAR2 (4001)
      INDEX BY BINARY_INTEGER;

   TYPE t32767 IS TABLE OF VARCHAR2 (32767)
      INDEX BY BINARY_INTEGER;

   v20      t20;
   v4000    t4000;
   v4001    t4001;
   v32767   t32767;

   PROCEDURE initialize (
      next_header_in   IN   VARCHAR2
    , compare_in       IN   BOOLEAN DEFAULT TRUE
   )
   IS
   BEGIN
      IF compare_in
      THEN
         my_session.MEMORY (pga_only => TRUE, compare_to_last => TRUE);
      END IF;

      DBMS_OUTPUT.put_line (next_header_in || ' with spread ' || spread_in);
      DBMS_SESSION.free_unused_user_memory;
      my_session.MEMORY (pga_only => TRUE, compare_to_last => FALSE);
   END initialize;
BEGIN
   IF varchar2_size_in = 20
   THEN
      initialize (   'Memory for strings with max length '
                  || varchar2_size_in
                  || ' in T20'
                , compare_in      => FALSE
                 );

      FOR i IN 1 .. iterations_in
      LOOP
         v20 (i + spread_in) := RPAD ('a', varchar2_size_in, 'b');
      END LOOP;
   ELSIF varchar2_size_in = 4000
   THEN
      initialize (   'Memory for strings with max length '
                  || varchar2_size_in
                  || ' in T4000'
                 );

      FOR i IN 1 .. iterations_in
      LOOP
         v4000 (i + spread_in) := RPAD ('a', varchar2_size_in, 'b');
      END LOOP;
   ELSIF varchar2_size_in = 4001
   THEN
      initialize (   'Memory for strings with max length '
                  || varchar2_size_in
                  || ' in T4001'
                 );

      FOR i IN 1 .. iterations_in
      LOOP
         v4001 (i + spread_in) := RPAD ('a', varchar2_size_in, 'b');
      END LOOP;
   ELSIF varchar2_size_in = 32767
   THEN
      initialize (   'Memory for strings with max length '
                  || varchar2_size_in
                  || ' in T32767'
                 );

      FOR i IN 1 .. iterations_in
      LOOP
         v32767 (i + spread_in) := RPAD ('a', varchar2_size_in, 'b');
      END LOOP;
   END IF;

   my_session.MEMORY (pga_only => TRUE);
END analyze_vc2_memory_usage;
/

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (20, 0, 1000);

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (20, 1000, 1000);

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (4000, 0, 1000);

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (4000, 1000, 1000);

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (4001, 0, 1000);

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (4001, 1000, 1000);

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (32767, 0, 1000);

CONNECT scott/tiger
SET serveroutput on
EXEC analyze_vc2_memory_usage (32767, 1000, 1000);
