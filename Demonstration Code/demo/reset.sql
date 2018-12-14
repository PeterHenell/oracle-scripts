SET FEEDBACK OFF

CREATE OR REPLACE PACKAGE reset
IS
   holder VARCHAR2(30);
   FUNCTION name RETURN VARCHAR2;
   FUNCTION name_reset RETURN VARCHAR2;
END;
/
CREATE OR REPLACE PACKAGE BODY reset
IS
   g_user VARCHAR2(30) := USER;
   
   FUNCTION name_reset RETURN VARCHAR2
   IS BEGIN 
      DBMS_SESSION.RESET_PACKAGE; 
      RETURN g_user; 
   END;
   
   FUNCTION name RETURN VARCHAR2
   IS BEGIN 
      RETURN g_user; 
   END;
END;
/

SET SERVEROUTPUT ON
BEGIN
   p.l ('1. THISUSER ' || thisuser.name);   
END;
/
EXEC DBMS_SESSION.RESET_PACKAGE;
BEGIN
   p.l ('2. THISUSER ' || thisuser.name);   
END;

/

SET SERVEROUTPUT ON
BEGIN
   p.l ('3. THISUSER ' || thisuser.name);   
   p.l ('3. RESET ' || reset.name_reset);
END;
/
   
EXEC DBMS_SESSION.RESET_PACKAGE;
SET SERVEROUTPUT ON
BEGIN
   p.l ('4. THISUSER ' || thisuser.name);   
END;
/

SET SERVEROUTPUT ON
BEGIN
   DBMS_SESSION.RESET_PACKAGE;
   p.l ('5. THISUSER ' || thisuser.name); 
   reset.holder := thisuser.name;  
END;
/

SET SERVEROUTPUT ON
EXEC p.l ('6. HOLDER ' || reset.holder);

SET SERVEROUTPUT ON
BEGIN
   p.l ('7. THISUSER ' || thisuser.name);   
   p.l ('7. RESET ' || reset.name);
END;
/
SET FEEDBACK ON
