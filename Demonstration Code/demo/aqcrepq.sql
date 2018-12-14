/* Create a prioritized queue. */

BEGIN
 DBMS_AQADM.CREATE_QUEUE_TABLE
   (queue_table => 'raw_msg',
    queue_payload_type => 'RAW');


 DBMS_AQADM.CREATE_QUEUE
   (queue_name => 'raw_msgqueue',
    queue_payload_type => 'raw_msg');

 DBMS_AQADM.START_QUEUE (queue_name => 'raw_msgqueue');
END;
/

