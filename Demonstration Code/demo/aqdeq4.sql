DECLARE
   enqueue_opts DBMS_AQ.ENQUEUE_OPTIONS_T;
   dequeue_opts DBMS_AQ.DEQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;
   msgid1 aq.msgid_type;
   msgid2 aq.msgid_type;
   my_msg message_type;
BEGIN
   /* Enqueue two messages */

   my_msg := message_type 
      ('Joy of Cooking', 'Classic Recipes for Oral Delight');
   DBMS_AQ.ENQUEUE ('msg_q', enqueue_opts, msgprops, my_msg, msgid1);

   my_msg := message_type ('Joy of Sex', 'Classic Recipes for Delight');
   DBMS_AQ.ENQUEUE ('msg_q', enqueue_opts, msgprops, my_msg, msgid2);

   /* Now dequeue the first by its message ID explicitly. */
   getmsg (msgid1);
END;
/ 
