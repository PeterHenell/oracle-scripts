CREATE OR REPLACE PACKAGE dbpipe
   /*
   || Package of interesting utilities illustrating use of
   || DBMS_PIPE programs.  Includes a forwarding program to 
   || pass pipe messages from one pipe to another, a peek
   || program to inspect and replace pipe messages, and
   || generic unpack and pack programs.
   ||
   || Author:  John Beresniewicz
   ||
   || 10/10/97: added purge_all_pipes
   || 10/10/97: made cannot_use_pipe a public
   ||           exception
   || 10/05/97: added makepipe and closepipe
   || 09/28/97: added invalid_item_type exception to
   ||           unpack_to_tbl
   || 09/25/97: added safe or cool mode to forward
   || 09/21/97: created
   ||
   || Compilation Requirements: 
   ||
   || EXECUTE on DBMS_PIPE
   || EXECUTE on DBMS_SESSION
   || SELECT  on SYS.V_$DB_PIPES
   ||
   || Execution Requirements:
   ||
   */
AS

   /*
   || declare exception raised by various DBMS_PIPE
   || programs when user cannot access a private pipe
   */ 
   cannot_use_pipe   EXCEPTION;
   PRAGMA EXCEPTION_INIT(cannot_use_pipe,-23322);

   /*
   || message_rectype records can capture any single
   || item which can be packed into a DBMS_PIPE message
   */
   TYPE message_rectype IS RECORD
      (item_type  INTEGER
      ,Mvarchar2  VARCHAR2(4093)
      ,Mdate      DATE
      ,Mnumber    NUMBER
      ,Mrowid     ROWID
      ,Mraw       RAW(4093)
      );

   /*
   || message_tbltype tables can hold an ordered list of 
   || message items, thus any message can be captured
   */
   TYPE message_tbltype IS TABLE OF message_rectype
      INDEX BY BINARY_INTEGER;

   /*
   || unpacks message buffer into table,
   || optionally displays message to screen
   */
   PROCEDURE unpack_to_tbl
      (message_tbl_OUT OUT message_tbltype
      ,display_TF IN BOOLEAN := FALSE);

   /*
   || packs message buffer from message table
   */
   PROCEDURE pack_from_tbl 
      (message_tbl_IN IN message_tbltype);

   /*
   || forward a message from one pipe to another,
   || supports two techniques (safe and cool)
   */
   PROCEDURE forward
      (from_pipename_IN IN VARCHAR2
      ,to_pipename_IN IN VARCHAR2
      ,timeout_secs_IN IN INTEGER := 10
      ,safe_mode_IN IN BOOLEAN := FALSE);

   /*
   || takes sample message from a pipe and displays the
   || contents, replaces message back into pipe if
   || boolean parameter is TRUE
   */
   PROCEDURE peek
      (pipename_IN IN VARCHAR2
      ,timeout_secs_IN IN INTEGER := 60
      ,replace_message_TF IN BOOLEAN := TRUE);

   /*
   || covers DBMS_PIPE.CREATE_PIPE and returns 
   || FALSE if ORA-23322 is raised indicating
   || the pipename is already used and not accessible
   || to the caller
   */
   FUNCTION makepipe
	   (pipename_IN IN VARCHAR2
	   ,maxsize_bytes_IN IN INTEGER DEFAULT 8192
	   ,private_IN IN BOOLEAN DEFAULT TRUE)
   RETURN BOOLEAN;

   /* 
   || covers DBMS_PIPE.REMOVE_PIPE and returns 
   || FALSE if ORA-23322 is raised indicating
   || the pipename exists and is not removable
   || by the caller
   */
   FUNCTION closepipe
	   (pipename_IN IN VARCHAR2)
   RETURN BOOLEAN;

   /*
   || purges all pipes the caller can access
   */
   PROCEDURE purge_all_pipes;

END dbpipe;
/

CREATE OR REPLACE PACKAGE BODY dbpipe
AS

   /* raised by unpack_to_tbl */
   invalid_item_type  EXCEPTION;

   PROCEDURE unpack_to_tbl
      (message_tbl_OUT OUT message_tbltype
      ,display_TF IN BOOLEAN := FALSE)
   IS
      /*
      || NOTE: this procedure should only be called after
      || a successful call to DBMS_PIPE.RECEIVE_MESSAGE
      */

      /* empty table to flush output table on exception */
      null_message_tbl message_tbltype;
      
      /*
      || temp display variable extra long to account
      || for RAWTOHEX conversion that can double size
      */
      temp_varchar2  VARCHAR2(8186);
   
      next_item      INTEGER;
      item_count     INTEGER := 0;
   
   BEGIN

      next_item := DBMS_PIPE.NEXT_ITEM_TYPE;
      
      /*
      || loop through all items, unpacking each by item
      || type and convert to varchar2 for display
      */
      WHILE next_item > 0
      LOOP
         /*
         || increment item count and store item type
         */
         item_count := item_count + 1;
         message_tbl_OUT(item_count).item_type := next_item;

         /*
         || now use next_item to call correct unpack procedure,
         || saving item to message_tbl
         ||
         || also stuff temp_varchar2 with string conversion
         || of the item
         */
         IF next_item = 9
         THEN
            DBMS_PIPE.UNPACK_MESSAGE
               (message_tbl_OUT(item_count).Mvarchar2);
            
            temp_varchar2 := 'VARCHAR2: '||
                     message_tbl_OUT(item_count).Mvarchar2;
         ELSIF next_item = 6
         THEN
            DBMS_PIPE.UNPACK_MESSAGE
               (message_tbl_OUT(item_count).Mnumber);
            
            temp_varchar2 := 'NUMBER: '||
                  TO_CHAR(message_tbl_OUT(item_count).Mnumber);

         ELSIF next_item = 11
            THEN
            DBMS_PIPE.UNPACK_MESSAGE_ROWID
               (message_tbl_OUT(item_count).Mrowid);
               
            temp_varchar2 := 'ROWID: '||
                  ROWIDTOCHAR(message_tbl_OUT(item_count).Mrowid);

         ELSIF next_item = 12
         THEN
            DBMS_PIPE.UNPACK_MESSAGE
               (message_tbl_OUT(item_count).Mdate);
         
            temp_varchar2 := 'DATE: '||
               TO_CHAR(message_tbl_OUT(item_count).Mdate,
                                 'YYYY:MM:DD:HH24:MI:SS'); 

         ELSIF next_item = 23
         THEN
            DBMS_PIPE.UNPACK_MESSAGE_RAW
               (message_tbl_OUT(item_count).Mraw);
             
            temp_varchar2 := 'RAW: '||
               RAWTOHEX(message_tbl_OUT(item_count).Mraw);

         ELSE
            temp_varchar2 := 'Invalid item type: '||
                                 TO_CHAR(next_item);

            RAISE invalid_item_type;
         END IF;

         /* 
         || display results and get next item type
         */
         IF display_TF
         THEN
            DBMS_OUTPUT.PUT_LINE(temp_varchar2);
         END IF;
         
         next_item := DBMS_PIPE.NEXT_ITEM_TYPE;

      END LOOP;

   EXCEPTION
      WHEN invalid_item_type
      THEN
         message_tbl_OUT := null_message_tbl;
      
   END unpack_to_tbl;


   PROCEDURE pack_from_tbl 
      (message_tbl_IN IN message_tbltype)
   IS
      /*
      || packs the session message buffer from a generic
      || message table
      */
   BEGIN
      FOR i IN message_tbl_IN.FIRST..message_tbl_IN.LAST
      LOOP
         IF message_tbl_IN(i).item_type = 9
         THEN
            DBMS_PIPE.PACK_MESSAGE(message_tbl_IN(i).Mvarchar2);
            
         ELSIF message_tbl_IN(i).item_type = 6
         THEN
            DBMS_PIPE.PACK_MESSAGE(message_tbl_IN(i).Mnumber);
            
         ELSIF message_tbl_IN(i).item_type = 12
         THEN
            DBMS_PIPE.PACK_MESSAGE(message_tbl_IN(i).Mdate);
            
         ELSIF message_tbl_IN(i).item_type = 11
         THEN
            DBMS_PIPE.PACK_MESSAGE_ROWID(message_tbl_IN(i).Mrowid);
           
         ELSIF message_tbl_IN(i).item_type = 23
         THEN
            DBMS_PIPE.PACK_MESSAGE_RAW(message_tbl_IN(i).Mraw);

         END IF;
               
      END LOOP;


   END pack_from_tbl;

   PROCEDURE forward
      (from_pipename_IN IN VARCHAR2
      ,to_pipename_IN IN VARCHAR2
      ,timeout_secs_IN IN INTEGER := 10
      ,safe_mode_IN IN BOOLEAN := FALSE)
   IS
      call_status    INTEGER;
      message_tbl    message_tbltype;
      
   BEGIN
      /* initialize buffer  */
      DBMS_PIPE.RESET_BUFFER;
   
      IF NOT safe_mode_IN
      THEN
         /*
         || do an initial pack so COOL mode forwarding will work,
         || why this is necessary is unknown
         */
         DBMS_PIPE.PACK_MESSAGE('bogus message');
      END IF;

      /*
      || receive the message on from_pipename, if success
      || then forward on to_pipename
      */
      call_status := DBMS_PIPE.RECEIVE_MESSAGE
                        (pipename=>from_pipename_IN
                        ,timeout=>timeout_secs_IN);

      IF call_status = 0
      THEN
         /*
         || safe mode does full unpack and repack
         */
         IF safe_mode_IN
         THEN
            unpack_to_tbl(message_tbl);
            pack_from_tbl(message_tbl);
         END IF;
            
         /*
         || OK, now send on to_pipename
         */
         call_status := DBMS_PIPE.SEND_MESSAGE
                           (pipename=>to_pipename_IN
                           ,timeout=>timeout_secs_IN);
       END IF;
      
   END forward;


   PROCEDURE peek
      (pipename_IN IN VARCHAR2
      ,timeout_secs_IN IN INTEGER := 60
      ,replace_message_TF IN BOOLEAN := TRUE)
   IS
      /*
      || Takes a sample message from a pipe, unpacks and displays
      || contents using unpack_to_tbl procedure.
      ||
      || If replace_message_TF parameter is TRUE (the default),
      || then the message is replaced into the pipe.  NOTE: this 
      || will change message order in the pipe.
      */

      message_tbl    message_tbltype;
      call_status    INTEGER;
   
      /* empty table used to free and release memory */
      null_message_tbl  message_tbltype;

   BEGIN

      call_status := DBMS_PIPE.RECEIVE_MESSAGE
         (pipename=>pipename_IN, timeout=>timeout_secs_IN);

      IF call_status = 0
      THEN
         unpack_to_tbl(message_tbl, display_TF=>TRUE);
         
         IF replace_message_TF
         THEN
            /*
            || repack message into initialized buffer
            */
            DBMS_PIPE.RESET_BUFFER;
            pack_from_tbl(message_tbl);
            
            /*
            || replace message on the pipe
            */
            call_status := DBMS_PIPE.SEND_MESSAGE
                        (pipename=>pipename_IN, timeout=>0);
         END IF;
      
         /*
         || empty message_tbl and free memory
         */
         message_tbl := null_message_tbl;
         DBMS_SESSION.FREE_UNUSED_USER_MEMORY;

      END IF;
   
   END peek;

   FUNCTION makepipe
      (pipename_IN IN VARCHAR2
      ,maxsize_bytes_IN IN INTEGER DEFAULT 8192
      ,private_IN IN BOOLEAN DEFAULT TRUE)
   RETURN BOOLEAN
   IS
      call_status  INTEGER;

   BEGIN
	   call_status := DBMS_PIPE.CREATE_PIPE
                        (pipename_IN
                        ,maxsize_bytes_IN
                        ,private_IN);

      RETURN call_status = 0;

   EXCEPTION
      WHEN cannot_use_pipe 
      THEN
         RETURN FALSE;
   END makepipe;


   FUNCTION closepipe
	   (pipename_IN IN VARCHAR2)
   RETURN BOOLEAN
   IS
      call_status  INTEGER;

   BEGIN
	   call_status := DBMS_PIPE.REMOVE_PIPE(pipename_IN);

      RETURN call_status = 0;

   EXCEPTION
      WHEN cannot_use_pipe 
      THEN
         RETURN FALSE;
   END closepipe;

   PROCEDURE purge_all_pipes
   IS
      /* gets names of all pipes */
      CURSOR all_pipes_cur
      IS
      SELECT name
        FROM sys.v_$db_pipes;

   BEGIN
      FOR all_pipes_rec IN all_pipes_cur
      LOOP
         BEGIN
            DBMS_PIPE.PURGE(all_pipes_rec.name);

         /* ignore cannot_use_pipe exception */
         EXCEPTION
            WHEN cannot_use_pipe
            THEN
               null;
            WHEN OTHERS
            THEN
               RAISE;
         END;
      END LOOP;
   END purge_all_pipes;

END dbpipe;
/

