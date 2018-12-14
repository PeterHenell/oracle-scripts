/* Create a queue of raw data. */

BEGIN 
  DBMS_AQADM.CREATE_QUEUE_TABLE
   (queue_table => 'rawmsg',
    queue_payload_type => 'RAW');


  DBMS_AQADM.CREATE_QUEUE
   (queue_name => 'rawmsgqueue',
    queue_payload_type => 'rawmsg');

  DBMS_AQADM.START_QUEUE (queue_name => 'rawmsgqueue');
END;
/

