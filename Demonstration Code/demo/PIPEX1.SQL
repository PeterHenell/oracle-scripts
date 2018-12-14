rem *********************************************
rem  PIPEX1.SQL
rem  Examples used for DBMS_PIPE package 
rem
rem  Requirements: standard Oracle EMP table
rem                EXECUTE on DBMS_PIPE
rem *********************************************

set feedback off
BEGIN
   DBMS_PIPE.PURGE('OBIP_TEST_PIPE');
   DBMS_PIPE.RESET_BUFFER;
END;
/
set feedback on

prompt
prompt *****************************************
prompt PACK_MESSAGE example
prompt *****************************************
prompt
pause hit enter to continue...
set echo on

DECLARE
   /* 
   || PL/SQL block illustrating use of 
   || DBMS_PIPE.PACK_MESSAGE to pack and send
   || a PL/SQL record to a pipe
   */
   TYPE friend_rectype IS RECORD
      (name       VARCHAR2(60)
      ,birthdate  DATE
      ,weight_lbs NUMBER
      );

   friend_rec  friend_rectype;

   PROCEDURE pack_send_friend
      (friend_rec_IN IN friend_rectype
      ,pipename_IN IN VARCHAR2)
   IS
      call_status   INTEGER;
   BEGIN
      /* 
      ||notice the PACK_MESSAGE overloading 
      */
      DBMS_PIPE.PACK_MESSAGE(friend_rec_IN.name);
      DBMS_PIPE.PACK_MESSAGE(friend_rec_IN.birthdate);
      DBMS_PIPE.PACK_MESSAGE(friend_rec_IN.weight_lbs);
      
      call_status := DBMS_PIPE.SEND_MESSAGE
                        (pipename=>pipename_IN,timeout=>0);

   END pack_send_friend;

BEGIN
   friend_rec.name := 'John Smith';
   friend_rec.birthdate := TO_DATE('01/14/55','MM/DD/YY');
   friend_rec.weight_lbs := 175;

   pack_send_friend(friend_rec,'OBIP_TEST_PIPE');
END;
/
set echo off

prompt
prompt *****************************************
prompt UNPACK_MESSAGE example
prompt *****************************************
prompt
pause hit enter to continue...
set echo on

set serveroutput on size 100000

DECLARE
   /* 
   || PL/SQL block illustrating use of 
   || DBMS_PIPE.UNPACK_MESSAGE to receive and
   || unpack a PL/SQL record from a pipe
   */
   TYPE friend_rectype IS RECORD
      (name       VARCHAR2(60)
      ,birthdate  DATE
      ,weight_lbs NUMBER
      );

   friend_rec  friend_rectype;

   PROCEDURE receive_unpack_friend
      (friend_rec_OUT OUT friend_rectype
      ,pipename_IN IN VARCHAR2)
   IS
      call_status   INTEGER;
   BEGIN

      call_status := DBMS_PIPE.RECEIVE_MESSAGE
                        (pipename=>pipename_IN,timeout=>0);
      /* 
      ||NOTE: UNPACK_MESSAGE overloaded but we must
      ||      call the correct version 
      */
      DBMS_PIPE.UNPACK_MESSAGE(friend_rec_OUT.name);
      DBMS_PIPE.UNPACK_MESSAGE(friend_rec_OUT.birthdate);
      DBMS_PIPE.UNPACK_MESSAGE(friend_rec_OUT.weight_lbs);
      
   END receive_unpack_friend;

BEGIN
   /* OK test the procedure, get rec from other example */
   receive_unpack_friend(friend_rec,'OBIP_TEST_PIPE');

   /* display results */
   DBMS_OUTPUT.PUT_LINE('Friend name: '||friend_rec.name);
   DBMS_OUTPUT.PUT_LINE('Friend birthdate: '||
                     TO_CHAR(friend_rec.birthdate));
   DBMS_OUTPUT.PUT_LINE('Friend weight: '||
                     TO_CHAR(friend_rec.weight_lbs));   
END;
/
set echo off

set feedback off
BEGIN
   DBMS_PIPE.PURGE('OBIP_TEST_PIPE');
   DBMS_PIPE.RESET_BUFFER;
END;
/
set feedback on

prompt
prompt **************************************************
prompt PACK_MESSAGE_RAW and UNPACK_MESSAGE_RAW examples
prompt **************************************************
prompt
pause hit enter to continue...
set echo on

DECLARE
   hex_data    VARCHAR2(12):='FFEEDDCCBBAA';
   raw_data    RAW(6);
   call_status INTEGER;
BEGIN
   /* create some raw data */
   raw_data := HEXTORAW(hex_data);

   /*
   || pack and send raw data on pipe
   */
   DBMS_PIPE.PACK_MESSAGE_RAW(raw_data);
   call_status := DBMS_PIPE.SEND_MESSAGE('OBIP_TEST_PIPE');
END;
/

set serveroutput on size 100000

DECLARE
   hex_data    VARCHAR2(12);
   raw_data    RAW(6);
   call_status INTEGER;
BEGIN
   /* 
   || receive and unpack the raw message 
   */
   call_status := DBMS_PIPE.RECEIVE_MESSAGE('OBIP_TEST_PIPE');
   DBMS_PIPE.UNPACK_MESSAGE_RAW(raw_data);

   /* display results */
   hex_data := RAWTOHEX(raw_data);
   DBMS_OUTPUT.PUT_LINE('hex of raw: '||hex_data);
END;
/
set echo off

set feedback off
BEGIN
   DBMS_PIPE.PURGE('ROWID_PIPE');
   DBMS_PIPE.RESET_BUFFER;
END;
/
set feedback on

prompt
prompt *****************************************************
prompt PACK_MESSAGE_ROWID and UNPACK_MESSAGE_ROWID examples
prompt *****************************************************
prompt
pause hit enter to continue...
set echo on

CREATE OR REPLACE TRIGGER emp_AIU
   AFTER INSERT OR UPDATE ON emp
   FOR EACH ROW
DECLARE
   rowid_pipename  VARCHAR2(20) := 'ROWID_PIPE';
   call_status   INTEGER;
BEGIN
   /* 
   || pack and send the rowid to a pipe 
   */
   DBMS_PIPE.PACK_MESSAGE_ROWID(:NEW.rowid);
   call_status := DBMS_PIPE.SEND_MESSAGE(rowid_pipename);
END;
/

set echo off
UPDATE emp SET empno = empno;
COMMIT;
set echo on

set serveroutput on size 100000

DECLARE
   rowid_pipename  VARCHAR2(20) := 'ROWID_PIPE';
   temp_rowid   ROWID;
   call_status  INTEGER:=0;
BEGIN
   /* 
   || receive and unpack all rowids from pipe 
   */
   WHILE call_status = 0
   LOOP
      call_status := DBMS_PIPE.RECEIVE_MESSAGE
         (pipename=>rowid_pipename, timeout=>0);

      IF call_status = 0
      THEN
            DBMS_PIPE.UNPACK_MESSAGE_ROWID(temp_rowid);
      END IF;

      /* display rowid results */
      DBMS_OUTPUT.PUT_LINE(ROWIDTOCHAR(temp_rowid));
   END LOOP;
END;
/
set echo off

DROP TRIGGER emp_AIU;

