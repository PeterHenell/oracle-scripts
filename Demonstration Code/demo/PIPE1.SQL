CREATE OR REPLACE PROCEDURE pipe1
   (message_item_IN IN VARCHAR2)
   /*
   || Tests whether DBMS_PIPE compresses
   || string message items on packing by  
   || stuffing buffer full and counting total
   || size of message.
   ||
   || Author:  John Beresniewicz, Savant Corp
   || Created: 09/16/97
   ||
   */
IS
   test_pipename  VARCHAR2(30):='OPBIP_TEST_PIPE';
   call_status       INTEGER;

   item_counter   INTEGER :=0;
   total_msg_size  INTEGER :=0;

   buffer_full    EXCEPTION;
   PRAGMA EXCEPTION_INIT(buffer_full,-6558);

BEGIN

   /* make sure pipe is empty and buffer initialized */
   call_status := DBMS_PIPE.CREATE_PIPE(test_pipename);
   DBMS_PIPE.PURGE(test_pipename);
   DBMS_PIPE.RESET_BUFFER;

   BEGIN
      /* buffer_full exception ends the loop */
      LOOP
         DBMS_PIPE.PACK_MESSAGE(message_item_IN);

         /* 
         || increment total size:  1 byte for datatype and 
         || 2 bytes for item length 
         */
         total_msg_size := total_msg_size+3+LENGTHB(message_item_IN);
         item_counter := item_counter +1;
      END LOOP;

   EXCEPTION
      WHEN buffer_full 
         THEN
            /* test if message can send OK on buffer_full */
            call_status := DBMS_PIPE.SEND_MESSAGE(test_pipename);

            IF call_status = 0
            THEN
               /* OK, display results for this message item */
               DBMS_OUTPUT.PUT_LINE
                  ('Items Packed: '||TO_CHAR(item_counter));
               DBMS_OUTPUT.PUT_LINE
                  ('Total Msg Size: '||TO_CHAR(total_msg_size+1));
            ELSE
               DBMS_OUTPUT.PUT_LINE
                  ('Pipe Send Error, return code: '||
                                       TO_CHAR(call_status));
            END IF;
      WHEN OTHERS 
         THEN
            DBMS_OUTPUT.PUT_LINE('Oracle Error: '||TO_CHAR(SQLCODE));
   END;

END pipe1;
/

spool pipe1.log

execute pipe1('This is a long text message');

execute pipe1(RPAD(' ',2000));

execute pipe1('1');

spool off

