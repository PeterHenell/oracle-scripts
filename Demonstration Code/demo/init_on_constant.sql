CREATE OR REPLACE PACKAGE init_on_constant
IS
   a   CONSTANT NUMBER := 2;

   PROCEDURE abc;
END;
/

CREATE OR REPLACE PACKAGE BODY init_on_constant
IS
   PROCEDURE abc
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('abc');
   END;
BEGIN
   DBMS_OUTPUT.put_line ('init');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (init_on_constant.a);
   init_on_constant.abc;
END;
/
