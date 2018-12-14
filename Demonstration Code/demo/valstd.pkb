CREATE OR REPLACE PACKAGE BODY valstd
IS
   PROCEDURE pl (str1 IN VARCHAR2, str2 IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (str1 || ' - ' || str2);
   END pl;

   PROCEDURE disp_header (str_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('==================');
      DBMS_OUTPUT.put_line ('VALIDATE STANDARDS');
      DBMS_OUTPUT.put_line ('==================');
      DBMS_OUTPUT.put_line (str_in);
      DBMS_OUTPUT.put_line ('');
   END disp_header;

   PROCEDURE progwith (str IN VARCHAR2)
   IS
      TYPE info_rt IS RECORD
      (
         name   user_source.name%TYPE
       , text   user_source.text%TYPE
      );

      TYPE info_aat IS TABLE OF info_rt
                          INDEX BY PLS_INTEGER;

      info_aa   info_aat;
   BEGIN
      disp_header ('Checking for presence of "' || str || '"');

      FOR rec
         IN (SELECT name || '-' || line name, text
               FROM user_source
              WHERE     UPPER (text) LIKE '%' || UPPER (str) || '%'
                    AND name != 'VALSTD'
                    AND name != 'ERRNUMS')
      LOOP
         pl (rec.name, rtrim (rec.text, CHR(10)));
      END LOOP;
   END progwith;

   PROCEDURE exception_handling
   IS
   BEGIN
      progwith ('RAISE_APPLICATION_ERROR');
      progwith ('EXCEPTION_INIT');
      progwith ('-20');
   END;

   PROCEDURE encap_compliance
   IS
      SUBTYPE qualified_name_t IS VARCHAR2 (200);

      TYPE refby_rt IS RECORD
      (
         name            qualified_name_t
       , referenced_by   qualified_name_t
      );

      TYPE refby_aat IS TABLE OF refby_rt
                           INDEX BY PLS_INTEGER;

      refby_aa   refby_aat;
   BEGIN
        SELECT owner || '.' || name refs_table
             , referenced_owner || '.' || referenced_name table_referenced
          BULK COLLECT INTO refby_aa
          FROM all_dependencies
         WHERE     owner = USER
               AND TYPE IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
               AND referenced_type IN ('TABLE', 'VIEW')
               AND referenced_owner NOT IN ('SYS', 'SYSTEM')
      ORDER BY owner
             , name
             , referenced_owner
             , referenced_name;

      disp_header ('Programs that reference tables or views');

      FOR indx IN refby_aa.FIRST .. refby_aa.LAST
      LOOP
         pl (refby_aa (indx).name, refby_aa (indx).referenced_by);
      END LOOP;
   END;
END valstd;
/