/* aqenq2.sql */
DECLARE
   queueopts DBMS_AQ.ENQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;
   msgid1 aq.msgid_type;
   msgid2 aq.msgid_type;
   my_msg message_type;
BEGIN
   my_msg := message_type ('First Enqueue', 'May there be many more...');

   /* Delay first message by three days, but otherwise rely on defaults. */

   msgprops.delay := 3 * 60 * 60  * 24; 
 
   DBMS_AQ.ENQUEUE ('msg_q', queueopts, msgprops, my_msg, msgid1);

   /* Now use the same properties record, but modify the enqueue options
      to deviate from the normal sequence. */

   my_msg := message_type ('Second Enqueue', 'And this one goes first...');

   queueopts.sequence_deviation := DBMS_AQ.BEFORE;
   queueopts.relative_msgid := msgid1;

   DBMS_AQ.ENQUEUE ('msg_q', queueopts, msgprops, my_msg, msgid2);
END;
/ 
