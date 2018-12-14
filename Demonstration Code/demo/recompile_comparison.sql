SET SERVEROUTPUT ON FORMAT WRAPPED

SPOOL recompile_comparison.log

CREATE OR REPLACE PACKAGE depends_on_me
IS
   PROCEDURE abc;
END;
/

CREATE OR REPLACE PACKAGE BODY depends_on_me
IS
   PROCEDURE abc
   IS
   BEGIN
      NULL;
   END;
END;
/

CREATE OR REPLACE PROCEDURE depends_on
IS
BEGIN
   depends_on_me.abc;
END;
/

DECLARE
   -- What program do you want to recompile,
   -- to force invalidation of other objects?
   g_program      VARCHAR2 (100) := 'package depends_on_me';
   --
   g_start_time   PLS_INTEGER;
   --
   l_dummy        PLS_INTEGER;

   PROCEDURE show_invalid (context_in IN VARCHAR2)
   IS
      l_invalid   PLS_INTEGER;
   BEGIN
      SELECT COUNT (*)
        INTO l_invalid
        FROM user_objects
       WHERE status = 'INVALID' AND object_name LIKE 'DEPEND%';

      DBMS_OUTPUT.put_line (
         'Invalid object count ' || context_in || ': ' || l_invalid);
   END show_invalid;

   PROCEDURE before_recompile
   IS
   BEGIN
      EXECUTE IMMEDIATE 'alter ' || g_program || ' compile reuse settings';

      show_invalid ('before');
      -- Change get_cpu_time to get_time for versions earlier than 10g
      g_start_time := DBMS_UTILITY.get_cpu_time;
   END before_recompile;

   PROCEDURE after_recompile (approach_in IN VARCHAR2)
   IS
   BEGIN
      -- Change get_cpu_time to get_time for versions earlier than 10g
      DBMS_OUTPUT.put_line (
            'Time for "'
         || approach_in
         || '" = '
         || TO_CHAR (DBMS_UTILITY.get_cpu_time - g_start_time));
      show_invalid ('after');
   END after_recompile;
BEGIN
   before_recompile;
   l_dummy := recompile (o_owner => USER, display => TRUE);
   after_recompile ('Yakobson utility');
   --
   before_recompile;
   DBMS_UTILITY.compile_schema (USER
                              , compile_all      => FALSE
                              , reuse_settings   => TRUE);
   after_recompile ('dbms_utility.compile_schema');
   --
   before_recompile;
   sys.UTL_RECOMP.recomp_serial (USER);
   after_recompile ('utl_recomp.serial');
END;
/

SPOOL OFF