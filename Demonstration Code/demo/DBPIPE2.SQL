CREATE TABLE pipetalk_debug
   (message_date  DATE
   ,message       VARCHAR2(2000)
   )
   TABLESPACE user_data
   STORAGE (initial 2 next 2 pctincrease 0);

CREATE OR REPLACE PACKAGE pipetalk
AS
   /*
   || Illustrates the use of DBMS_PIPE to implement 
   || communications between a PL/SQL background server 
   || program and client programs.  
   ||
   || Clients communicate requests over a database pipe
   || on which the server listens and receive responses
   || on pipes unique to each session.
   ||
   || The server can be set to place debugging info into a
   || table.
   ||
   || Author:  John Beresniewicz
   ||
   || 10/04/97: created
   ||
   || Compilation Requirements: 
   ||
   || EXECUTE on DBMS_PIPE
   ||
   || Execution Requirements:
   ||
   */

   /* 
   || simple server program which listens indefinitely on 
   || database pipe for instructions
   */
   PROCEDURE server;

   /*
   || Client programs
   */

   /* stop the server */
   PROCEDURE server_stop;

   /* turn server debug mode toggle on or off */
   PROCEDURE server_debug_on;
   PROCEDURE server_debug_off;

   /* get and display server status using DBMS_OUTPUT */
   PROCEDURE server_status;


END pipetalk;
/


CREATE OR REPLACE PACKAGE BODY pipetalk
AS

   /* used as a tag for this application */
   app_id   VARCHAR2(10) := 'OPBIP$';

   /* identifiers for message protocols */
   request_protocol VARCHAR2(20) := app_id||'REQUEST$';
   status_protocol  VARCHAR2(20) := app_id||'STATUS$';

   /* server listens on this pipe */
   request_pipe VARCHAR2(30) := app_id||'SERVER$';

   /* client responses come on this pipe, unique to each client */
   my_response_pipe VARCHAR2(100) := app_id|| 
                                    DBMS_PIPE.UNIQUE_SESSION_NAME;

   /* boolean toggles debug mode for server */
   debug_TF BOOLEAN := FALSE;

   /* boolean to end server loop */
   terminate_TF   BOOLEAN := FALSE;

   /* 
   || service request literals 
   */
   stop_req     VARCHAR2(10)  := 'STOP';
   debugon_req  stop_req%TYPE := 'DEBUG_ON';
   debugoff_req stop_req%TYPE := 'DEBUG_OFF';
   status_req   stop_req%TYPE := 'STATUS';


   /* 
   || requests to server made in this format, 
   || should never need to override response_pipe
   */
   TYPE request_rectype IS RECORD
         (response_pipe VARCHAR2(100) := my_response_pipe 
         ,service  stop_req%TYPE
         );

   /* 
   || server reports status in this format
   */
   TYPE status_rectype IS RECORD
         (start_date    DATE 
         ,total_requests   INTEGER := 0
         ,debug_status  VARCHAR2(5) := 'OFF'
         );

   /* private global for server current status */
   status_rec status_rectype;

   /* 
   || private program to put debug messages into table
   || if boolean is TRUE, or if force_IN is TRUE
   || NOTE: commits after inserting row
   */
   PROCEDURE debug
      (message_IN IN VARCHAR2
      ,force_TF_IN IN BOOLEAN := FALSE)
   IS
   BEGIN
      IF debug_TF OR force_TF_IN
      THEN
         INSERT INTO pipetalk_debug
         VALUES (SYSDATE, message_IN);
         COMMIT;
      END IF;
   END debug;

   /*
   || private program to put service request on pipe,
   || called by client programs
   */
   PROCEDURE pack_send_request
      (request_rec_IN IN request_rectype
      ,return_code_OUT OUT NUMBER)
   IS
   BEGIN
      /* discard any previous unsent message items */
      DBMS_PIPE.RESET_BUFFER;

      /* pack message in standard order */
      DBMS_PIPE.PACK_MESSAGE(request_protocol);
      DBMS_PIPE.PACK_MESSAGE(request_rec_IN.response_pipe);
      DBMS_PIPE.PACK_MESSAGE(request_rec_IN.service);

      /*
      || send message to request pipe nowait
      */
      return_code_OUT := DBMS_PIPE.SEND_MESSAGE
                           (pipename => request_pipe
                           ,timeout  => 0);
   END pack_send_request;

   /*
   || private program to receive request on the 
   || request pipe
   */
   PROCEDURE receive_unpack_request
      (timeout_IN IN INTEGER
      ,request_rec_OUT OUT request_rectype
      ,return_code_OUT OUT NUMBER)
   IS
      /* temp variables */
      temp_protocol  request_protocol%TYPE;
      temp_return_code  NUMBER;

   BEGIN

      temp_return_code := DBMS_PIPE.RECEIVE_MESSAGE
                             (pipename => request_pipe
                             ,timeout  => timeout_IN);

      IF temp_return_code = 0
      THEN
         /* check if expected protocol */
         DBMS_PIPE.UNPACK_MESSAGE(temp_protocol);
      
         IF temp_protocol = request_protocol
         THEN
            DBMS_PIPE.UNPACK_MESSAGE(request_rec_OUT.response_pipe);
            DBMS_PIPE.UNPACK_MESSAGE(request_rec_OUT.service);
         ELSE
            /* pipe message has unexpected protocol */
            temp_return_code := -1;
            debug('UNKNOWN PROTOCOL: '||temp_protocol);
            DBMS_PIPE.RESET_BUFFER;
         END IF;
      END IF;

      return_code_OUT := temp_return_code;

   EXCEPTION
      WHEN OTHERS THEN
         return_code_OUT := SQLCODE;
         debug('RECEIVE REQUEST EXCP: '||SQLERRM
              ,force_TF_IN=>TRUE);
         DBMS_PIPE.RESET_BUFFER;

   END receive_unpack_request;

   /*
   || private program to put request on pipe,
   || called by client programs
   */
   PROCEDURE pack_send_status
      (status_rec_IN IN status_rectype
      ,response_pipe_IN IN my_response_pipe%TYPE
      ,return_code_OUT OUT NUMBER)
   IS

   BEGIN
      /* discard any previous unsent message items */
      DBMS_PIPE.RESET_BUFFER;

      /* pack message in standard order */
      DBMS_PIPE.PACK_MESSAGE(status_protocol);
      DBMS_PIPE.PACK_MESSAGE(status_rec_IN.start_date);
      DBMS_PIPE.PACK_MESSAGE(status_rec_IN.total_requests);
      DBMS_PIPE.PACK_MESSAGE(status_rec_IN.debug_status);

      /*
      || send message to response pipe nowait
      */
      return_code_OUT := DBMS_PIPE.SEND_MESSAGE
                           (pipename => response_pipe_IN
                           ,timeout  => 0);
   END pack_send_status;

   /*
   || private program to receive status on unique
   || session pipe
   */
   PROCEDURE receive_unpack_status
      (timeout_IN IN INTEGER
      ,status_rec_OUT OUT status_rectype
      ,return_code_OUT OUT NUMBER)
   IS
      /* temp variables */
      temp_protocol  request_protocol%TYPE;
      temp_return_code  NUMBER;

   BEGIN
      /* client receives status on my_response_pipe */
      temp_return_code := DBMS_PIPE.RECEIVE_MESSAGE
                             (pipename => my_response_pipe
                             ,timeout  => timeout_IN);

      IF temp_return_code = 0
      THEN
         /* check if expected protocol */
         DBMS_PIPE.UNPACK_MESSAGE(temp_protocol);
      
         IF temp_protocol = status_protocol
         THEN
            DBMS_PIPE.UNPACK_MESSAGE(status_rec_OUT.start_date);
            DBMS_PIPE.UNPACK_MESSAGE(status_rec_OUT.total_requests);
            DBMS_PIPE.UNPACK_MESSAGE(status_rec_OUT.debug_status);
         ELSE
            /* pipe message has unexpected protocol */
            temp_return_code := -1;
            DBMS_PIPE.RESET_BUFFER;
         END IF;
      END IF;

      return_code_OUT := temp_return_code;

   EXCEPTION
      WHEN OTHERS THEN
         return_code_OUT := SQLCODE;
         debug('RECEIVE STATUS EXCP: '||SQLERRM
              ,force_TF_IN=>TRUE);
         DBMS_PIPE.RESET_BUFFER;

   END receive_unpack_status;

   /*
   || private program to encapsulate request processing
   || logic (lots of IF...THEN stuff)
   */
   PROCEDURE process_request
      (request_rec_IN IN request_rectype)
   IS
      temp_return_code NUMBER;

   BEGIN
      /* increment total */
      status_rec.total_requests := status_rec.total_requests +1;

      IF request_rec_IN.service = stop_req
      THEN 
         terminate_TF := TRUE;

      ELSIF request_rec_IN.service = debugon_req
      THEN
         debug_TF := TRUE;
         status_rec.debug_status := 'ON';

      ELSIF request_rec_IN.service = debugoff_req
      THEN
         debug_TF := FALSE;
         status_rec.debug_status := 'OFF';

      ELSIF request_rec_IN.service = status_req
      THEN
         pack_send_status
            (status_rec_IN=>status_rec
            ,response_pipe_IN=> request_rec_IN.response_pipe
            ,return_code_OUT=> temp_return_code);

         debug('SEND STATUS: '||temp_return_code);

      /* unrecognized request */
      ELSE
         DBMS_PIPE.RESET_BUFFER;
         debug('UNKNOWN REQUEST: '||request_rec_IN.service);
      END IF;
   END process_request;


   PROCEDURE server 
   IS
      request_rec     request_rectype;
      temp_return_code  NUMBER;
      
   BEGIN
      /* create pipe */
      temp_return_code := DBMS_PIPE.CREATE_PIPE(request_pipe);

      /* initialize status rec */
      status_rec.start_date := SYSDATE;
      status_rec.total_requests := 0;
      status_rec.debug_status := 'OFF';

      /* 
      || loop forever and process requests 
      */
      WHILE NOT terminate_TF 
      LOOP
         receive_unpack_request
            (timeout_IN => DBMS_PIPE.maxwait
            ,request_rec_OUT=> request_rec
            ,return_code_OUT => temp_return_code);

         IF temp_return_code != 0
         THEN
            DBMS_PIPE.PURGE(request_pipe);
            debug('REQUEST PIPE STAT: '||temp_return_code);
         ELSE
            process_request(request_rec);
            debug('REQUEST PROCESSED');
         END IF;
      END LOOP;

      /* 
      || terminating: remove pipe and exit 
      */
      temp_return_code := DBMS_PIPE.REMOVE_PIPE(request_pipe);

   EXCEPTION
      WHEN OTHERS THEN
         debug('SERVER EXCP: '||SQLERRM, force_TF_IN=>TRUE);
         temp_return_code := DBMS_PIPE.REMOVE_PIPE(request_pipe);

   END server;

   /*
   || private program to make simple service requests,
   || if request_rectype gets more complex or need more
   || flexibility use pack_send_request instead  
   */
   PROCEDURE client_request(request_IN IN stop_req%TYPE)
   IS
      request_rec request_rectype;
      temp_return_code  NUMBER;

   BEGIN
      request_rec.service := request_IN;

      pack_send_request
         (request_rec_IN => request_rec
         ,return_code_OUT => temp_return_code);

   END client_request;

   PROCEDURE server_stop
   IS
   BEGIN
      client_request(stop_req);
   END server_stop;


   PROCEDURE server_status
   IS
      status_rec  status_rectype;
      temp_return_code  NUMBER;

   BEGIN
      client_request(status_req);

      /* wait for up to 1 minute for response */
      receive_unpack_status
         (timeout_IN => 60
         ,status_rec_OUT => status_rec
         ,return_code_OUT => temp_return_code);
 
      /* display results */
      IF temp_return_code =0
      THEN
         DBMS_OUTPUT.PUT_LINE('Server Info...');
         DBMS_OUTPUT.PUT_LINE('start date: '||
            TO_CHAR(status_rec.start_date,'YYYY:MM:DD:HH24:MI:SS') );
         DBMS_OUTPUT.PUT_LINE('total requests: '||
            TO_CHAR(status_rec.total_requests) );
         DBMS_OUTPUT.PUT_LINE('debug status: '||
            status_rec.debug_status);
      ELSE
         DBMS_OUTPUT.PUT_LINE('status request fail, return code: '||
            TO_CHAR(temp_return_code));
      END IF;
      
   END server_status;

   PROCEDURE server_debug_on
   IS
   BEGIN
      client_request(debugon_req);
   END server_debug_on;

   PROCEDURE server_debug_off
   IS
   BEGIN
      client_request(debugoff_req);
   END server_debug_off;

END pipetalk;
/


