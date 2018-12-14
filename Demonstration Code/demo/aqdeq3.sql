CREATE OR REPLACE PROCEDURE getmsg (msgid_in IN RAW)
IS
   queueopts DBMS_AQ.DEQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;
   msgid aq.msgid_type; /* defined in aq.spp */
   my_msg message_type;
BEGIN
   queueopts.msgid := msgid_in;

   DBMS_AQ.DEQUEUE ('msg_q',
      queueopts, msgprops, my_msg, msgid);

   /* Now display some of the information. */
   DBMS_OUTPUT.PUT_LINE 
      ('Requested message id is ' || RAWTOHEX (msgid_in));
   DBMS_OUTPUT.PUT_LINE 
      ('Dequeued message id is  ' || RAWTOHEX (msgid));
   DBMS_OUTPUT.PUT_LINE ('Dequeued title is ' || my_msg.title);
END;
/