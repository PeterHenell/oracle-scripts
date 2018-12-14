/* aqdeq2.sql - run this after aqenq1.sql */
DECLARE
   queueopts DBMS_AQ.DEQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;
   msgid aq.msgid_type; /* defined in aq.spp */
   my_msg message_type;

   /* A nested procedure to minimize code redundancy! */
   PROCEDURE getmsg (mode_in IN INTEGER)
   IS
   BEGIN
      queueopts.dequeue_mode := mode_in;

      DBMS_AQ.DEQUEUE ('msg_q', queueopts, msgprops, my_msg, msgid);

      /* Now display some of the information. */
      DBMS_OUTPUT.PUT_LINE ('Dequeued msg id is ' || RAWTOHEX (msgid));
      DBMS_OUTPUT.PUT_LINE ('Dequeued title is ' || my_msg.title);
	  DBMS_OUTPUT.PUT_LINE ('Dequeued text is ' || my_msg.text);
   END;
BEGIN
   /* Request browse, not remove, for dequeue operation. */
   getmsg (DBMS_AQ.BROWSE);

   /* Do the same thing again, this time with remove. You will dequeue
      the same entry as before. */
   getmsg (DBMS_AQ.REMOVE);

   /* Dequeue a third time, again with remove, and notice the different
      message ID. The previous message was, in fact, removed. */
   getmsg (DBMS_AQ.REMOVE);
      
   /* Finally, dequeue the third message. */
   getmsg (DBMS_AQ.REMOVE);
END;
/
