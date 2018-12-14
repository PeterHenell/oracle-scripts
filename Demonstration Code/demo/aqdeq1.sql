/* Simplest form of a dequeue. */

DECLARE
   queueopts   DBMS_AQ.dequeue_options_t;
   msgprops    DBMS_AQ.message_properties_t;
   
   enqueueopts DBMS_AQ.ENQUEUE_OPTIONS_T;
   
   msgid       Aq.msgid_type;                          /* defined in aq.pkg */
   my_msg      message_type;
BEGIN
   my_msg := message_type ('Pass it on',
                'It''s going to be sunny in Dublin today!'
             );
   DBMS_AQ.enqueue ('msg_q', enqueueopts, msgprops, my_msg, msgid);
   
   DBMS_AQ.dequeue ('msg_q', queueopts, msgprops, my_msg, msgid);
   
   /* Now display some of the information. */
   DBMS_OUTPUT.put_line ('Dequeued message id IS '|| RAWTOHEX (msgid));
   DBMS_OUTPUT.put_line ('Dequeued title IS '|| my_msg.title);
   DBMS_OUTPUT.put_line ('Dequeued text IS '|| my_msg.text);
END;
/
