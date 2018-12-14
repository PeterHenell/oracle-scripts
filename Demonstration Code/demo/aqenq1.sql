/* Formatted on 2001/09/10 16:33 (RevealNet Formatter v4.4.1) */
CREATE OR REPLACE PROCEDURE enqueue_example (
   name_in   IN   VARCHAR2,
   msg_in    IN   VARCHAR2
)
IS
   queueopts   DBMS_AQ.enqueue_options_t;
   msgprops    DBMS_AQ.message_properties_t;
   msgid       aq.msgid_type;
   my_msg      message_type;
BEGIN
   my_msg := message_type (name_in, msg_in);
   DBMS_AQ.enqueue ('msg_q', queueopts, msgprops, my_msg, msgid);
   DBMS_OUTPUT.put_line (RAWTOHEX (msgid));
END;
/
BEGIN
   enqueue_example ('Dublin', 'Visit with Veva during H and M disease crisis');
   enqueue_example ('TVP', 'Largest class size for trainings in 3 years');
   enqueue_example ('Mexico', 'iDevelop 2001 - a world of Java');
END;
/
