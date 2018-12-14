CREATE TABLE messages (
   text VARCHAR2(2000),
   machine VARCHAR2(100),
   program VARCHAR2(100),
   created_by VARCHAR2(100),
   created_on DATE
   );
   
CREATE OR REPLACE PROCEDURE logger (msg IN VARCHAR2)
AS
   PRAGMA AUTONOMOUS_TRANSACTION;
   CURSOR sCur IS
       SELECT MACHINE, PROGRAM, USERNAME, SYSDATE
         FROM V$SESSION
        WHERE AUDSID = USERENV('SESSIONID');
    sRec sCur%ROWTYPE;
BEGIN
   OPEN sCur;
   FETCH sCur INTO sRec;
   CLOSE sCur;

   INSERT INTO messages VALUES (msg, sRec.machine, sRec.program,
      sRec.username, sRec.SYSDATE);

   COMMIT;
   EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
END;