REM
REM Demonstration script for DBMS_ALERT and DBMS_PIPE 
REM 
REM Author: Richard Bolz, dbolz@earthlink.net
REM
REM Dependencies:
REM    - Connect to SYS account
REM    - Connect to SCOTT account
REM    - Connect to SYSTEM account
REM
REM 1. Make sure we have access to the built-in packages
CONNECT sys/sys
GRANT execute on dbms_alert to public;
GRANT execute on dbms_pipe to public;
GRANT select on dbms_alert_info to public;

CREATE
PUBLIC synonym dbms_alert_info for sys.dbms_alert_info;
REM 2. Set up the log table and code elements
CONNECT scott/tiger

CREATE
TABLE log
 (LOG_KEY                                  NUMBER,
 LOG_USER                                 VARCHAR2(20),
 LOG_TIME                                 DATE,
 LOG_MSG                                  VARCHAR2(50)
 );

CREATE
SEQUENCE log_seq;

CREATE OR REPLACE
PACKAGE buffer
AS
   -- Called by consumers.  Attempt to get a message from the pipe
   -- (use timeout of 12 seconds).  If successful, then the msg is
   -- unpacked, logged and sent to caller.  If timeout occurs, the 
   -- fact is logged and the timed_out exception is raised.
   PROCEDURE get
      (msg OUT VARCHAR2);

   -- Called by producers.  The actual message is built up as the
   -- concatenation of source (user), SYSDATE, and the msg sent from
   -- the source.  This actual message is then packed and sent to
   -- the pipe.  If timeout occurs the fact is logged and the
   -- time_out exception is raised.
   PROCEDURE put
      (msg IN VARCHAR2);

   -- Inserts USER, SYSDATE and the msg into the LOG table.
   -- Displays same information on terminal of caller (USER).
   PROCEDURE log_info
      (msg IN VARCHAR2);

   -- Displays current contents of LOG table on terminal of caller.
   PROCEDURE dump_log;

   -- Called by the controlling session.  Signals the alert and
   -- deletes all rows from the LOG table.
   PROCEDURE startup;

   -- Raised in Get and Put procedures.
   timed_out EXCEPTION;
END buffer;
/

CREATE OR REPLACE
PACKAGE BODY buffer
AS
   --------------------------------------------------------------
   PROCEDURE log_info
      (msg IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE (USER || ' ' || TO_CHAR (
                                              SYSDATE,
                                              'hh:mi:ss'
                                           ) || ' ' || msg);
      INSERT INTO scott.LOG
           VALUES (log_seq.nextval, USER, SYSDATE, msg);
      COMMIT;
   END log_info;

   --------------------------------------------------------------
   PROCEDURE get
      (msg OUT VARCHAR2)
   IS
      the_message VARCHAR2(100);
      stat INTEGER;
   BEGIN
      stat := dbms_pipe.receive_message ('the_pipe', 12);

      IF stat = 1
      THEN
         -- time out
         log_info (' Timed out while attempting to RECEIVE_MESSAGE');
         RAISE timed_out;
      ELSIF stat = 0
      THEN
         -- successful
         dbms_pipe.unpack_message (the_message);
         log_info ('RECEIVED: ' || the_message);
         msg := the_message;
      ELSE
         log_info ('ERROR ' || stat);
      -- some other condition

      END IF;
   END get;

   ------------------------------------------------------------------
   PROCEDURE put
      (msg IN VARCHAR2)
   IS
      the_message VARCHAR2(100);
      stat INTEGER;
   BEGIN
      the_message := 'from ' || USER || ' at ' || TO_CHAR (
                                                     SYSDATE,
                                                     'hh:mi:ss'
                                                  ) || ' msg #' || msg;
      dbms_pipe.pack_message (the_message);
      stat := dbms_pipe.send_message ('the_pipe', 6);

      IF stat <> 0
      THEN
         log_info (the_message || ' WAS NOT SENT');
         RAISE timed_out;
      ELSE
         log_info ('SENT:     ' || the_message);
      END IF;
   END put;

   --------------------------------------------------------------
   PROCEDURE dump_log
   IS
      CURSOR log_cur
      IS
         SELECT *
           FROM scott.LOG
          ORDER BY log_key;
   BEGIN
      FOR log_rec IN log_cur
      LOOP
         dbms_output.put_line (RPAD (
            SUBSTR (log_rec.log_user, 1, 10),
            10
         ) || '  ' || RPAD (
                         TO_CHAR (log_rec.log_time, 'hh:mi:ss'),
                         10
                      ) || ' ' || SUBSTR (log_rec.log_msg, 1, 40));
      END LOOP;
   END dump_log;

   --------------------------------------------------------------
   PROCEDURE startup
   IS
   BEGIN
      dbms_alert.signal ('start_task', 'Start your engines');
      DELETE
        FROM scott.LOG;
   END startup;
END buffer;
/
GRANT execute on buffer to public;

CREATE OR REPLACE
PROCEDURE consumer
AS
   the_msg VARCHAR2(100);
   stat INTEGER;
   alert_msg VARCHAR2(100);
BEGIN
   -- Register interest, wait for startup then log startup message
   dbms_alert.register ('start_task');
   dbms_alert.waitone ('start_task', alert_msg, stat);
   buffer.log_info (alert_msg);

   -- Sleep a random time (0 .. 5 seconds), attempt to get a message.  
   -- If successful, output the message locally (don't use buffer.log_info).
   -- If timeout occurs, an exception will take you to the handler   
   LOOP
      dbms_lock.sleep (random.num * 5);
      buffer.get (the_msg);
      dbms_output.put_line (the_msg);
   END LOOP;
EXCEPTION
   WHEN buffer.timed_out
   THEN
      buffer.log_info (' finished processing');
END consumer;
/
GRANT execute on consumer to public;

CREATE OR REPLACE
PROCEDURE producer
   (num_messages IN INTEGER := 5)
AS
   stat INTEGER;
   -- an 'OUT' parm.  not used.
   msg VARCHAR2(100);
-- startup message

BEGIN
   dbms_alert.register ('start_task');
   dbms_alert.waitone ('start_task', msg, stat);
   buffer.log_info (msg);

   FOR counter IN 1 .. num_messages
   LOOP
      dbms_lock.sleep (random.num * 5);
      buffer.put (counter);
   -- this is the sent message

   END LOOP;

   buffer.log_info (' sent all messages');
EXCEPTION
   WHEN buffer.timed_out
   THEN
      -- this should not happen
      buffer.log_info (' Timed out');
END producer;
/
GRANT execute on producer to public;

CREATE OR REPLACE
PACKAGE random
AS
   FUNCTION num
      RETURN NUMBER;
END random;
/

CREATE OR REPLACE
PACKAGE BODY random
AS
   seed NUMBER := MOD (TO_CHAR (SYSDATE, 'SSSS'), 10657);

   FUNCTION num
      RETURN NUMBER
   IS
   BEGIN
      seed := MOD ((seed * 864), 10657);
      RETURN seed / 10657;
   END num;
END random;
/
GRANT execute on random to public;
REM 3. Create the user accounts
CONNECT system/manager

CREATE
USER user1 identified by user1;
GRANT resource to user1;
GRANT connect to user1;

CREATE
USER user2 identified by user2;
GRANT resource to user2;
GRANT connect to user2;

CREATE
USER user3 identified by user3;
GRANT resource to user3;
GRANT connect to user3;

CREATE
USER user4 identified by user4;
GRANT resource to user4;
GRANT connect to user4;
REM 4. Grant global access to the program elements

CREATE
PUBLIC synonym buffer for scott.buffer;

CREATE
PUBLIC synonym producer for scott.producer;

CREATE
PUBLIC synonym consumer for scott.consumer;

CREATE
PUBLIC synonym random for scott.random;
REM 5. Go back to starting schema
CONNECT scott/tiger
-- Processed by PL/Formatter v.0.7.8 BETA-3 on 1998/06/08 16:40  (04:40 PM)
