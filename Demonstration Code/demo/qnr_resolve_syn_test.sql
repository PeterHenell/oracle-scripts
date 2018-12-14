CREATE SYNONYM ls_pkg FOR pkg;
CREATE PUBLIC SYNONYM ps_pkg FOR pkg;
CREATE SYNONYM ls_ls_pkg FOR ls_pkg;
CREATE PUBLIC SYNONYM ps_ps_pkg FOR ps_pkg;
CREATE SYNONYM ls_ps_pkg FOR ps_pkg;
CREATE PUBLIC SYNONYM ps_ls_pkg FOR ls_pkg;

SET serveroutput on format wrapped

DECLARE
   PROCEDURE TEST (NAME IN VARCHAR2)
   IS
      SCHEMA        all_objects.owner%TYPE;
      object_name   all_objects.object_name%TYPE;
   BEGIN
      qnr.synonym_resolve (NAME, SCHEMA, object_name);
      dbms_output.put_line (   'Synonym "'
                            || NAME
                            || '" resolved to "'
                            || SCHEMA
                            || '.'
                            || object_name
                            || '"'
                           );
   END;
BEGIN
   TEST ('ls_pkg');
   TEST ('ps_pkg');
   TEST ('ps_pkg');
   TEST ('ls_ls_pkg');
   TEST ('ls_ps_pkg');
   TEST ('ps_ls_pkg');
   TEST ('ps_ps_pkg');
   TEST ('scott.ls_pkg');
   TEST ('scott.ps_pkg');
   TEST ('scott.ps_pkg');
   TEST ('scott.ls_ls_pkg');
   TEST ('scott.ls_ps_pkg');
   TEST ('scott.ps_ls_pkg');
   TEST ('scott.ps_ps_pkg');   
END;
/