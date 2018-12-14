CREATE TYPE message_type AS OBJECT
   (title VARCHAR2(30),
    text VARCHAR2(2000));
/
BEGIN

 DBMS_AQADM.CREATE_QUEUE_TABLE
   (queue_table => 'msg_qt',
    queue_payload_type => 'message_type');


 DBMS_AQADM.CREATE_QUEUE
   (queue_name => 'msg_q',
    queue_table => 'msg_qt');

 DBMS_AQADM.START_QUEUE (queue_name => 'msg_q');

END;
/


