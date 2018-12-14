set serveroutput on

CREATE OR REPLACE PACKAGE globals
IS
   pubval NUMBER := 10;
END;
/
CREATE OR REPLACE PACKAGE BODY globals
IS
   privval NUMBER := 100;
   
BEGIN
   /* Package initialization! */
   p.l ('Here we go with globals!');
   
   pubval := privval;
END;
/
CREATE OR REPLACE PROCEDURE modvals
IS
   local_val NUMBER := 10;

BEGIN
   p.l ('modify global and local values');
   globals.pubval := globals.pubval + 1;
   local_val := local_val + 1;
   p.l ('local',local_val);
   p.l ('global', globals.pubval);
END;
/