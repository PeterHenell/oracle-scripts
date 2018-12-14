CREATE OR REPLACE PROCEDURE proc1
   AUTHID CURRENT_USER
IS
BEGIN
   authid_analysis.analyze_callstack;
END;
/

CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
   proc1;
END;
/

CREATE OR REPLACE PROCEDURE proc3
   AUTHID CURRENT_USER
IS
BEGIN
   proc2;
END;
/

BEGIN
   proc3;
END;
/