/* Create a queue which supports multiple consumers. */

BEGIN
   DBMS_AQADM.CREATE_QUEUE_TABLE
      (queue_table => 'multicons',
       queue_payload_type => 'message_type',
       multiple_consumers => TRUE);

   DBMS_AQADM.CREATE_QUEUE
      (queue_name => 'multiconsqueue',
       queue_table => 'multicons');

   DBMS_AQADM.START_QUEUE (queue_name => 'multiconsqueue');

END;
/

