CREATE OR REPLACE PACKAGE frc_vpd_helper
   AUTHID CURRENT_USER
/*
| File name: frc_vpd_helper.sql
|
| Overview: When you have security policies defined on a table, the
|           row-level restrictions could be circumvented if the
|           data is retrieved through an 11g function result cache.
|           This package generates a package of static constants, one
|           each table on which a security policy you have access to
|           is defined. It then also generates conditional compilation-
|           based code that you can put inside your RELIES ON clause
|           to cause a compile failure if that table is used within
|           RELIES ON. 
|
| Author(s): Steven Feuerstein
|
| Modification History:
|   Date        Who         What
| Nov 2008      SF          Created after discussion with University
|                           of Porto (Portugal) developers
*/
IS
   PROCEDURE create_static_const_pkg (include_schema_in IN BOOLEAN);
END frc_vpd_helper;
/

CREATE OR REPLACE PACKAGE BODY frc_vpd_helper
IS
   SUBTYPE maxvarchar2_t IS VARCHAR2 (32767);

   FUNCTION hashval (str IN VARCHAR2)
      RETURN NUMBER
   IS
      maxrange   CONSTANT PLS_INTEGER := POWER (2, 31) - 1;
      strt       CONSTANT PLS_INTEGER := 0;
   BEGIN
      RETURN DBMS_UTILITY.get_hash_value (str, strt, maxrange);
   END hashval;

   PROCEDURE gen_static_const_pkg (include_schema_in IN BOOLEAN
                                 , package_spec_out   OUT DBMS_SQL.varchar2s
                                  )
   IS
      c_package_name   CONSTANT maxvarchar2_t := 'frc_vpd_warnings';

      l_spec           DBMS_SQL.varchar2s;

      l_object_name    maxvarchar2_t;
      l_name           maxvarchar2_t;

      PROCEDURE add_line (line_in IN VARCHAR2)
      IS
      BEGIN
         l_spec (l_spec.COUNT + 1) := line_in;
      END add_line;
   BEGIN
      add_line ('CREATE OR REPLACE PACKAGE ' || c_package_name || ' IS ');

      FOR policy_rec IN (SELECT object_owner, object_name
                           FROM all_policies)
      LOOP
         l_object_name :=
            CASE
               WHEN include_schema_in
               THEN
                  policy_rec.object_owner || '.' || policy_rec.object_name
               ELSE
                  policy_rec.object_name
            END;
         l_name := 'VPD' || hashval (l_object_name);
         /* Comment with code to paste for single table in RELIES ON */
         add_line (l_name || ' CONSTANT BOOLEAN DEFAULT TRUE;');
         add_line(   '/*PASTE WHEN '
                  || l_object_name
                  || 'ONLY TABLE IN RELIES_ON CLAUSE: ');
         add_line ('$IF ' || c_package_name || '.' || l_name || ' $THEN');
         add_line('$ERROR ''Likely problem with function result cache, since '
                  || 'RELIES_ON clause references '
                  || l_object_name
                  || ', on which a VPD security policy is defined.'' $END');
         add_line ('$ELSE RELIES ON (' || l_object_name || ')');
         add_line ('$END');
         add_line ('*/');
         /* Comment with code to paste for multiple tables in RELIES ON */
         add_line(   '/*PASTE WHEN '
                  || l_object_name
                  || 'ONE OF SEVERAL TABLES IN RELIES_ON CLAUSE: ');
         add_line ('$IF ' || c_package_name || '.' || l_name || ' $THEN');
         add_line('$ERROR ''Likely problem with function result cache, since '
                  || 'RELIES_ON clause references '
                  || l_object_name
                  || ', on which a VPD security policy is defined.''');
         add_line ('$ELSE ' || l_object_name || ' $END');
         add_line ('$END');
         add_line ('*/');
      END LOOP;

      add_line ('END ' || c_package_name || ';');
      package_spec_out := l_spec;
   END gen_static_const_pkg;

   PROCEDURE create_static_const_pkg (include_schema_in IN BOOLEAN)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      l_spec   DBMS_SQL.varchar2s;

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
      gen_static_const_pkg (include_schema_in, l_spec);
      compile_statement (l_spec);
   END create_static_const_pkg;
END frc_vpd_helper;
/

BEGIN
   frc_vpd_helper.create_static_const_pkg;
END;
/