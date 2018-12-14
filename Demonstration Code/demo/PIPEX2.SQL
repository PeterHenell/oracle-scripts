rem *********************************************
rem  PIPEX2.SQL
rem  Example for DBMS_PIPE.NEXT_ITEM_TYPE 
rem
rem  Requirements: EXECUTE on DBMS_PIPE
rem *********************************************

set serveroutput on size 100000

DECLARE
   call_stat   INTEGER;
   
   PROCEDURE unpack_all_items
   IS
      /* 
      || declare temp variables of all message item types
      */
      temp_varchar2  VARCHAR2(2000);
      temp_date      DATE;
      temp_number    NUMBER;
      temp_rowid     ROWID;
      temp_raw       RAW(2000);

      next_item      INTEGER:=0;

   BEGIN
      next_item := DBMS_PIPE.NEXT_ITEM_TYPE;

      /*
      || unpack by item type and convert to varchar2
      */
      WHILE next_item > 0
      LOOP
         IF next_item = 9
         THEN
            DBMS_PIPE.UNPACK_MESSAGE(temp_varchar2);

         ELSIF next_item = 6
         THEN
            DBMS_PIPE.UNPACK_MESSAGE(temp_number);
            temp_varchar2 := 'NUMBER: '||TO_CHAR(temp_number);

         ELSIF next_item = 11
         THEN
            DBMS_PIPE.UNPACK_MESSAGE_ROWID(temp_rowid);
            temp_varchar2 := 'ROWID: '||ROWIDTOCHAR(temp_rowid);

         ELSIF next_item = 12
         THEN
            DBMS_PIPE.UNPACK_MESSAGE(temp_date);
            temp_varchar2 := 'DATE: '||
                        TO_CHAR(temp_date,'YYYY:MM:DD:HH24:MI:SS'); 

         ELSIF next_item = 23
         THEN
            DBMS_PIPE.UNPACK_MESSAGE_RAW(temp_raw); 
            temp_varchar2 := 'RAW: '||RAWTOHEX(temp_raw);

         ELSE
            temp_varchar2 := 'Invalid item type: '||TO_CHAR(next_item);  
         END IF;

         /* 
         || display item and determine next item 
         */
         DBMS_OUTPUT.PUT_LINE(temp_varchar2);
         next_item := DBMS_PIPE.NEXT_ITEM_TYPE;

      END LOOP;
   END unpack_all_items;

BEGIN
   /* empty pipe */
   DBMS_PIPE.PURGE('OPBIP_TEST_PIPE');

   /* initialize buffer  */
   DBMS_PIPE.RESET_BUFFER;
   
   /* pack in some data of different types */
   DBMS_PIPE.PACK_MESSAGE('HELLO THERE');
   DBMS_PIPE.PACK_MESSAGE(123456789);
   DBMS_PIPE.PACK_MESSAGE(SYSDATE);
   DBMS_PIPE.PACK_MESSAGE_RAW(HEXTORAW('FFDDEE2344AA'));

   /* send and receive the message */
   call_stat := DBMS_PIPE.SEND_MESSAGE('OPBIP_TEST_PIPE');
   call_stat := DBMS_PIPE.RECEIVE_MESSAGE('OPBIP_TEST_PIPE');

   /* call the generic unpack procedure */
   unpack_all_items;
   
END;
/



