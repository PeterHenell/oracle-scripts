/* Formatted on 2002/05/09 09:27 (Formatter Plus v4.6.5) */

DROP table log81tab;

CREATE TABLE log81tab (
    code integer,
    text varchar2(4000),
    created_on date,
    created_by varchar2(100),
    changed_on date,
    changed_by varchar2(100),
    machine varchar2(100),
    program varchar2(100)
    );


CREATE OR REPLACE PACKAGE log81
IS 
   myvar NUMBER;
   
   PROCEDURE putline (code_in IN INTEGER, text_in IN VARCHAR2);

   PROCEDURE saveline (code_in IN INTEGER, text_in IN VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY log81
IS 
   CURSOR sess
   IS
      SELECT machine, program
        FROM v$session
       WHERE audsid = USERENV ('SESSIONID');

   rec   sess%ROWTYPE;

   PROCEDURE putline (code_in IN INTEGER, text_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('MYVAR = ' || log81.myVar);
	  
      INSERT INTO log81tab
           VALUES (code_in, text_in, SYSDATE, USER, SYSDATE, USER, rec.machine, rec.program);
   END;

   PROCEDURE saveline (code_in IN INTEGER, text_in IN VARCHAR2)
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      putline (code_in, text_in);
      COMMIT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ROLLBACK;
      WHEN OTHERS
      THEN
	     -- Table write failure, time to write to file...
         ROLLBACK;
   END;

BEGIN
   p.l ('Initializing log81...');
   OPEN sess;
   FETCH sess INTO rec;
   CLOSE sess;
END;
/
