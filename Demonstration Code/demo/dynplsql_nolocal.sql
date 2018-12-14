DECLARE
   localvar   VARCHAR2 (100);
BEGIN
   EXECUTE IMMEDIATE 'BEGIN localvar := ''abc''; END;';
END;
/

CREATE OR REPLACE PACKAGE global_vars
IS
   string   VARCHAR2 (100) := 'same old thing';
END;
/

DECLARE
   localvar   VARCHAR2 (100);
BEGIN
   pl ('BEFORE Global string = ' || global_vars.string);

   EXECUTE IMMEDIATE
      'BEGIN global_vars.string := ''amazing!''; END;';

   pl ('AFTER Global string = ' || global_vars.string);
END;
/

/* Twin Cities Sep 2007 - use OUT and USING */

DECLARE
   localvar     VARCHAR2 (100);
   localvar1    VARCHAR2 (100);
   execstring   VARCHAR2 (100);
BEGIN
   execstring := 'begin :myvar := ''abc''; end;';

   EXECUTE IMMEDIATE execstring USING OUT localvar;

   DBMS_OUTPUT.put_line (localvar);
END;
/

DECLARE
   localvar     VARCHAR2 (100);
   localvar1    VARCHAR2 (100);
   execstring   VARCHAR2 (1000);
BEGIN
   execstring :=
      'begin :myvar := ''abc''; 
           dbms_output.put_line (:value_in); 
           :myvar := ''abc''; end;';

   EXECUTE IMMEDIATE execstring
      USING OUT localvar, IN 'abc';

   DBMS_OUTPUT.put_line (localvar);
END;
/