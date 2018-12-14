CREATE OR REPLACE PACKAGE BODY valstd
IS
   SUBTYPE string_t IS VARCHAR2 (32767);

   TYPE string_aat IS TABLE OF string_t
      INDEX BY BINARY_INTEGER;

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
      name_aa   string_aat;
      text_aa   string_aat;
   BEGIN
      SELECT NAME || '-' || line
            ,text
      BULK COLLECT INTO name_aa
             ,text_aa
        FROM user_source
       WHERE UPPER (text) LIKE '%' || UPPER (str) || '%'
         AND NAME != 'VALSTD'
         AND NAME != 'ERRNUMS';

      disp_header ('Checking for presence of "' || str || '"');

      FOR indx IN name_aa.FIRST .. name_aa.LAST
      LOOP
         DBMS_OUTPUT.put_line (name_aa (indx) || ' - ' || text_aa (indx));
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
      name_aa    string_aat;
      refby_aa   string_aat;
   BEGIN
      SELECT   owner || '.' || NAME refs_table
              , referenced_owner || '.' || referenced_name table_referenced
      BULK COLLECT INTO name_aa
               ,refby_aa
          FROM all_dependencies
         WHERE owner = USER
           AND TYPE IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
           AND referenced_type IN ('TABLE', 'VIEW')
           AND referenced_owner NOT IN ('SYS', 'SYSTEM')
      ORDER BY owner, NAME, referenced_owner, referenced_name;

      disp_header ('Programs that reference tables or views');

      FOR indx IN name_aa.FIRST .. name_aa.LAST
      LOOP
         DBMS_OUTPUT.put_line (name_aa (indx) || ' - ' || refby_aa (indx));
      END LOOP;
   END;
END valstd;
/