CREATE OR REPLACE PROCEDURE replace_onerow (
   table_name_in IN VARCHAR2
)
IS
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE ' || table_name_in;
   EXCEPTION WHEN OTHERS THEN NULL;
   END;

   EXECUTE IMMEDIATE    'CREATE TABLE '
                     || table_name_in
                     || ' (dummy VARCHAR2(1))';

   EXECUTE IMMEDIATE 
      'CREATE OR REPLACE TRIGGER onerow_' || table_name_in || 
      '  BEFORE INSERT
         ON ' || table_name_in || '
      DECLARE
         PRAGMA AUTONOMOUS_TRANSACTION;
         l_count PLS_INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO l_count
           FROM ' || table_name_in || ';
      
         IF l_count = 1
         THEN
            raise_application_error
                            (-20000
                           , ''The ' || table_name_in || ' table can only have one row.''
                            );
         END IF;
      END;';

   EXECUTE IMMEDIATE    'BEGIN INSERT INTO '
                     || table_name_in
                     || ' VALUES (''X''); COMMIT; END;';

   EXECUTE IMMEDIATE    'GRANT SELECT ON '
                     || table_name_in
                     || ' TO PUBLIC';

   EXECUTE IMMEDIATE    'CREATE PUBLIC SYNONYM '
                     || table_name_in
                     || '  FOR '
                     || table_name_in;

   EXECUTE IMMEDIATE  
     'CREATE OR REPLACE FUNCTION next_pky (seq_in IN VARCHAR2)
         RETURN PLS_INTEGER AUTHID CURRENT_USER
      IS
         retval PLS_INTEGER;
      BEGIN
         EXECUTE IMMEDIATE ''SELECT '' || seq_in
                           || ''.NEXTVAL FROM ' || table_name_in || 
                           '|| ''INTO retval;
      
         RETURN retval;
      END next_pky;';

END replace_onerow;
/
