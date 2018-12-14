CREATE OR REPLACE PROCEDURE show_queue (queue IN VARCHAR2)
IS
   obj message_type;
   v_msgid aq.msgid_type;

   dequeueopts DBMS_AQ.DEQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;

   first_dequeue BOOLEAN := TRUE;
BEGIN
   LOOP
      /* Non-destructive dequeue */
      dequeueopts.dequeue_mode := DBMS_AQ.BROWSE;
      dequeueopts.wait := DBMS_AQ.NO_WAIT;
      dequeueopts.visibility := DBMS_AQ.IMMEDIATE;

      DBMS_AQ.DEQUEUE (queue_name => queue,
         dequeue_options => dequeueopts,
         message_properties => msgprops,
         payload => obj,
         msgid => v_msgid);
     
      /* Now display whatever you want here. */
      IF first_dequeue
      THEN
         DBMS_OUTPUT.PUT_LINE ('Prioritized Data');
         first_dequeue := FALSE;
      END IF;

      DBMS_OUTPUT.PUT_LINE (obj.title || '-' || obj.text);
   END LOOP;

EXCEPTION
   WHEN aq.dequeue_timeout
   THEN
      DBMS_OUTPUT.PUT_LINE ('All done...');
END;
/