CREATE OR REPLACE PROCEDURE show_queue (queue IN VARCHAR2)
IS
/* A generic program to dequeue in browse mode from a queue to
   display its current contents.

   YOU MUST MODIFY THIS FOR YOUR SPECIFIC OBJECT TYPE.
*/
   obj <YOUR OBJECT TYPE>;
   v_msgid aq.msgid_type;

   queueopts DBMS_AQ.DEQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;

   first_dequeue BOOLEAN := TRUE;
BEGIN
   LOOP
      /* Non-destructive dequeue */
      queueopts.dequeue_mode := DBMS_AQ.BROWSE;
      queueopts.wait := DBMS_AQ.NO_WAIT;
      queueopts.visibility := DBMS_AQ.IMMEDIATE;

      DBMS_AQ.DEQUEUE (queue_name => queue,
         dequeue_options => queueopts,
         message_properties => msgprops,
         payload => obj,
         msgid => v_msgid);
     
      /* Now display whatever you want here. */
      IF first_dequeue
      THEN
         DBMS_OUTPUT.PUT_LINE ('YOUR HEADER HERE');
         first_dequeue := FALSE;
      END IF;

      DBMS_OUTPUT.PUT_LINE ('YOUR DATA HERE');
   END LOOP;

EXCEPTION
   WHEN aq.dequeue_timeout
   THEN
      NULL;
END;
/