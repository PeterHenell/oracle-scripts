/* Advanced Queuing demo, main script
*/

@noaq

CONNECT sys/sys;

PAUSE

/* Create a user who is the AQ administrator.
|| The username is arbitrary.
*/

CREATE USER aqadmin IDENTIFIED BY aqadmin;

PAUSE

/* The AQ administrator should have the following roles.
|| [AQ_ADMINISTRATOR_ROLE is built-in.]
*/
GRANT AQ_ADMINISTRATOR_ROLE, CONNECT, RESOURCE TO aqadmin;

PAUSE

/* Cannot inherit the following from a role, so it must
|| be granted explicitly to any user who is going to enqueue
|| and dequeue messages.
*/
GRANT EXECUTE ON SYS.DBMS_AQ TO aqadmin;

PAUSE

/* This built-in assigns various privileges to the AQ
|| administrator.
*/
EXECUTE dbms_aqadm.grant_type_access('aqadmin');

PAUSE

CONNECT aqadmin/aqadmin
@login

PAUSE

/* Create a message type that will hold our "payload." */
CREATE TYPE aqadmin.Event_t AS OBJECT (
   eventname VARCHAR2(64),
   details VARCHAR2(512),
   username VARCHAR2(30),
   timestamp DATE,
   STATIC FUNCTION make (details_in IN VARCHAR2) RETURN Event_t
);
/

PAUSE

/* Create the type body. Note the pseudo-constructor.
*/
CREATE OR REPLACE TYPE BODY aqadmin.Event_t AS
   STATIC FUNCTION make  (details_in IN VARCHAR2) RETURN Event_t
   IS
   BEGIN
      RETURN Event_t(DBMS_STANDARD.SYSEVENT, details_in,
         DBMS_STANDARD.LOGIN_USER, SYSDATE);
   END;
END;
/

PAUSE


/* Create an object typed queue table
|| Note: create_queue_table will fail in 8.0.4 if you have created
||       the payload's object type body before this point
||       (Due to a bug)
*/

BEGIN
   DBMS_AQADM.CREATE_QUEUE_TABLE (
      QUEUE_TABLE => 'aqadmin.loginQtab',
      QUEUE_PAYLOAD_TYPE => 'aqadmin.Event_t',
      COMPATIBLE => '8.1.5',
      STORAGE_CLAUSE => 
         'STORAGE (INITIAL 100K NEXT 100K PCTINCREASE 0)');
END;
/

PAUSE

/* Now we can create and start the queue */
BEGIN
   DBMS_AQADM.CREATE_QUEUE (
      queue_name => 'loginQ',
      queue_table => 'aqadmin.loginQtab');

   DBMS_AQADM.START_QUEUE (
      queue_name => 'loginQ');
END;
/

PAUSE

/* The "oraevent" package that will call the enqueue and dequeue
|| functions.
*/
CREATE OR REPLACE PACKAGE oraevent 
AS
   PROCEDURE put (details_in IN VARCHAR2);
   FUNCTION getnext RETURN Event_t;
   PROCEDURE shownext;
END;
/

PAUSE

CREATE OR REPLACE PACKAGE BODY oraevent 
AS
   PROCEDURE put (details_in IN VARCHAR2) IS
      q_opts DBMS_AQ.ENQUEUE_OPTIONS_T;
      msg_props DBMS_AQ.MESSAGE_PROPERTIES_T;
      msg_handle RAW(16);
      event_l Event_t;
   BEGIN
      /* Setting visibility to IMMEDIATE will
      || force the queue to "commit" before the
      || client transaction commits.
      */
      q_opts.visibility := DBMS_AQ.IMMEDIATE;
      event_l := Event_t.make(details_in);

      DBMS_AQ.ENQUEUE(queue_name => 'aqadmin.loginQ',
         enqueue_options => q_opts,
         message_properties => msg_props,
         payload => event_l,
         msgid => msg_handle);
   END;

   FUNCTION getnext RETURN Event_t IS
      q_opts DBMS_AQ.DEQUEUE_OPTIONS_T;
      msg_props DBMS_AQ.MESSAGE_PROPERTIES_T;
      msg_handle RAW(16);
      event_l Event_t;
   BEGIN
      DBMS_AQ.DEQUEUE(queue_name => 'aqadmin.loginQ',
         dequeue_options => q_opts,
         message_properties => msg_props,
         payload => event_l,
         msgid => msg_handle);
      RETURN event_l;
   END;

   PROCEDURE shownext IS
      event_l Event_t;
   BEGIN
      event_l := getnext();
      DBMS_OUTPUT.PUT_LINE('Event    : ' || event_l.eventname);
      DBMS_OUTPUT.PUT_LINE('Details  : ' || event_l.details);
      DBMS_OUTPUT.PUT_LINE('Username : ' || event_l.username);
      DBMS_OUTPUT.PUT_LINE('Timestamp: ' || event_l.timestamp);
   END;

END;
/

PAUSE

/* Oracle8i provides queue-level security (in 8.0, anyone with
|| "execute" privilege on DBMS_AQ can read or write to any queue)
|| that you grant as follows.
*/
BEGIN
   DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(privilege => 'ALL',
      queue_name => 'aqadmin.loginQ',
      grantee => 'SYSTEM',
      grant_option => TRUE);
END;
/

PAUSE
/* Must grant privilege explicitly to SYSTEM to refer to
|| package oraevent in system event trigger
*/
GRANT EXECUTE ON oraevent TO SYSTEM;

CONNECT SYSTEM/MANAGER
@login

/* Create a database event trigger that we want to publish.
*/
CREATE OR REPLACE TRIGGER publish_logon
AFTER logon ON DATABASE
BEGIN
   aqadmin.oraevent.put('This was a log on');
END;
/

PAUSE

/* Start another window (this is the NT syntax.) from which you
|| can dequeue and display the events 
*/
host start sqlplus aqadmin/aqadmin @aqshow

PAUSE

DISCONNECT

@conn


REM  Copyright (c) 1999 DataCraft, Inc. and William L. Pribyl
REM  All Rights Reserved
