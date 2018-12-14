ALTER SESSION SET plsql_ccflags = 'oe_debug:true, oe_trace_level:10, commit_OFF:true'
/

ALTER SESSION SET plsql_warnings = 'ENABLE:ALL'
/

ALTER SESSION SET plscope_settings='IDENTIFIERS:ALL'
/

CREATE OR REPLACE PROCEDURE show_parameters
IS
/* all_plsql_object_settings */
BEGIN
   IF $$plsql_debug
   THEN
      DBMS_OUTPUT.put_line ('DEBUG ON');
   ELSE
      DBMS_OUTPUT.put_line ('DEBUG OFF');
   END IF;

   DBMS_OUTPUT.put_line ('Name = ' || $$name);
   DBMS_OUTPUT.put_line ('Type = ' || $$type);
   DBMS_OUTPUT.put_line ('Opt Level = ' || $$plsql_optimize_level);
   DBMS_OUTPUT.put_line ('Code Type = ' || $$plsql_code_type);
   DBMS_OUTPUT.put_line ('Warnings Setting = ' || $$plsql_warnings);
   DBMS_OUTPUT.put_line ('NLS Length Semantics = ' || $$nls_length_semantics);
   DBMS_OUTPUT.put_line ('CC Flags = ' || $$plsql_ccflags);
   DBMS_OUTPUT.put_line ('PLScope = ' || $$plscope_settings);
END show_parameters;
/

BEGIN
   show_parameters ();
END;
/

CREATE OR REPLACE PACKAGE show_parameters_pkg
IS
   PROCEDURE show_parameters;
END;
/

CREATE OR REPLACE PACKAGE BODY show_parameters_pkg
IS
   PROCEDURE show_parameters
   IS
   BEGIN
      IF $$plsql_debug
      THEN
         DBMS_OUTPUT.put_line ('DEBUG ON');
      ELSE
         DBMS_OUTPUT.put_line ('DEBUG OFF');
      END IF;

      DBMS_OUTPUT.put_line ('Name = ' || $$name);
      DBMS_OUTPUT.put_line ('Type = ' || $$type);
      DBMS_OUTPUT.put_line ('Opt Level = ' || $$plsql_optimize_level);
      DBMS_OUTPUT.put_line ('Code Type = ' || $$plsql_code_type);
      DBMS_OUTPUT.put_line ('Warnings Setting = ' || $$plsql_warnings);
      DBMS_OUTPUT.put_line (
         'NLS Length Semantics = ' || $$nls_length_semantics);
      DBMS_OUTPUT.put_line ('CC Flags = ' || $$plsql_ccflags);
      DBMS_OUTPUT.put_line ('PLScope = ' || $$plscope_settings);
   END show_parameters;
END show_parameters_pkg;
/

BEGIN
   show_parameters_pkg.show_parameters ();
END;
/