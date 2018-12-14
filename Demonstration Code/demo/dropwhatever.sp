CREATE OR REPLACE PROCEDURE drop_whatever (
   nm              IN   VARCHAR2 DEFAULT '%'
 , typ             IN   VARCHAR2 DEFAULT '%'
 , just_checking   IN   BOOLEAN DEFAULT TRUE
)
AUTHID CURRENT_USER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;                             -- TCOUG 1/2002
   dropstr   VARCHAR2 (32767);

   CURSOR object_cur
   IS
      SELECT object_name, object_type
        FROM user_objects
       WHERE object_name LIKE UPPER (nm)
         AND object_type LIKE UPPER (typ)
         AND object_name <> 'DROP_WHATEVER';         -- Demanded by Zurichers.
BEGIN
   FOR rec IN object_cur
   LOOP
      dropstr :=
            'DROP '
         || rec.object_type
         || ' '
         || rec.object_name
         || CASE
               WHEN rec.object_type IN ('TABLE', 'OBJECT')
                  THEN ' CASCADE CONSTRAINTS'
               ELSE NULL
            END;                                              -- WMOUG 10/2002

      BEGIN
         IF just_checking
         THEN
            DBMS_OUTPUT.put_line (dropstr || ' - just checking!');
         ELSE
            EXECUTE IMMEDIATE dropstr;
            DBMS_OUTPUT.put_line (dropstr || ' - SUCCESSFUL!');
         END IF;

      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (dropstr || ' - FAILURE!');
            DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      END;
   END LOOP;
END;
/