/*
Enable performance warnings for all
program units in schema.
*/

CREATE OR REPLACE VIEW plch_perf_pkg_v
AS
   SELECT *
     FROM user_plsql_object_settings
    WHERE     plsql_warnings !=
                    'DISABLE:INFORMATIONAL,'
                 || 'ENABLE:PERFORMANCE,'
                 || 'DISABLE:SEVERE'
          AND TYPE = 'PACKAGE'
/

/* Ensure at least one program unit with "wrong" setting */

ALTER SESSION SET plsql_warnings = 
  'DISABLE:PERFORMANCE,ENABLE:SEVERE'
/

CREATE OR REPLACE PACKAGE plch_warnings
IS
   n   NUMBER;
END;
/

/* Use DBMS_WARNINGS to set the session setting
   and then recompile packages */

BEGIN
   DBMS_WARNING.set_warning_setting_string (
      'ENABLE:PERFORMANCE',
      'SESSION');

   FOR upos IN (SELECT * FROM plch_perf_pkg_v)
   LOOP
      BEGIN
         EXECUTE IMMEDIATE
            'ALTER PACKAGE "' || upos.name || '" COMPILE';
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (
               DBMS_UTILITY.format_error_stack);
      END;
   END LOOP;
END;
/

SELECT COUNT (*) FROM plch_perf_pkg_v
/

/* Can't update this view!

ORA-01031: insufficient privileges */

BEGIN
   UPDATE user_plsql_object_settings upos
      SET upos.plsql_warnings = 'ENABLE:PERFORMANCE'
    WHERE TYPE = 'PACKAGE';
END;
/

SELECT COUNT (*) FROM plch_perf_pkg_v
/

/*
PLS-00306: wrong number or types of arguments in call to 'SET_WARNING_SETTING_STRING'
*/

BEGIN
   FOR upos IN (SELECT * FROM plch_perf_pkg_v)
   LOOP
      DBMS_WARNING.set_warning_setting_string (
         USER,
         upos.name,
         upos.TYPE,
         'ENABLE:PERFORMANCE');
   END LOOP;
END;
/

SELECT COUNT (*) FROM plch_perf_pkg_v
/

/* Ensure at least one program unit with "wrong" setting */

ALTER SESSION SET plsql_warnings = 'DISABLE:PERFORMANCE,ENABLE:SEVERE'
/

CREATE OR REPLACE PACKAGE plch_warnings
IS
   n   NUMBER;
END;
/

/* Change warnings settings when recompiling */

BEGIN
   FOR upos IN (SELECT * FROM plch_perf_pkg_v)
   LOOP
      BEGIN
         EXECUTE IMMEDIATE
               'ALTER PACKAGE "' || upos.name
            || '" COMPILE PLSQL_WARNINGS=''ENABLE:PERFORMANCE''';
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (
               DBMS_UTILITY.format_error_stack);
      END;
   END LOOP;
END;
/

SELECT COUNT (*) FROM plch_perf_pkg_v
/

/* Ensure at least one program unit with "wrong" setting */

ALTER SESSION SET plsql_warnings = 'DISABLE:PERFORMANCE,ENABLE:SEVERE'
/

CREATE OR REPLACE PACKAGE plch_warnings
IS
   n   NUMBER;
END;
/

/* This call to DBMS_WARNINGS ADDs the setting, does not replace it,
   So "DISABLE:INFORMATIONAL,ENABLE:PERFORMANCE,ENABLE:SEVERE" is
   the warnings setting.
*/

BEGIN
   DBMS_WARNING.ADD_WARNING_SETTING_CAT ('PERFORMANCE',
                                         'ENABLE',
                                         'SESSION');

   FOR upos IN (SELECT * FROM plch_perf_pkg_v)
   LOOP
      BEGIN
         EXECUTE IMMEDIATE
            'ALTER PACKAGE "' || upos.name || '" COMPILE';
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (
               DBMS_UTILITY.format_error_stack);
      END;
   END LOOP;
END;
/

SELECT COUNT (*) FROM plch_perf_pkg_v
/

SELECT * FROM plch_perf_pkg_v
/

/* Clean up */

DROP PACKAGE plch_warnings
/

DROP VIEW plch_perf_pkg_v
/