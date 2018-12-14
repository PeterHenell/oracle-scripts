DECLARE
   PROCEDURE drop_proc
   IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP PROCEDURE plch_test';
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   PROCEDURE create_proc (code_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (code_in);

      EXECUTE IMMEDIATE code_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   PROCEDURE show_status
   IS
      v_type user_objects.object_type%TYPE;
   BEGIN
      SELECT object_type
        INTO v_type
        FROM user_objects
       WHERE object_name = 'PLCH_TEST';

      DBMS_OUTPUT.put_line ('*PROCEDURE CREATED*');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line ('*PROCEDURE NOT CREATED*');
   END;
BEGIN
   drop_proc;
   create_proc (CODE_IN => 'CREATE PROCEDURE plch_test;');
   show_status;
   --
   drop_proc;
   create_proc (CODE_IN => 'CREATE PROCEDURE plch_test AS;');
   show_status;
   --
   drop_proc;
   create_proc (CODE_IN => 'CREATE PROCEDURE plch_test NULL;');
   show_status;
   --
   drop_proc;
   create_proc (CODE_IN => 'CREATE PROCEDURE plch_test IS BEGIN NULL; END;');
   show_status;
END;
/
