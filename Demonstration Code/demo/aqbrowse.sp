CREATE TYPE student_reg_t IS OBJECT  
   (ssn VARCHAR2(11),
    class_requested VARCHAR2(100));
/
CREATE OR REPLACE PROCEDURE drop_student (queue IN VARCHAR2, ssn_in IN VARCHAR2)
IS
   student student_reg_t;
   v_msgid aq.msgid_type;
   queue_changed BOOLEAN := FALSE;

   queueopts DBMS_AQ.DEQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;

   /* Translate mode number to a name. */
   FUNCTION mode_name (mode_in IN INTEGER) RETURN VARCHAR2
   IS 
   BEGIN
      IF    mode_in = DBMS_AQ.REMOVE THEN RETURN 'REMOVE';
      ELSIF mode_in = DBMS_AQ.BROWSE THEN RETURN 'BROWSE';
      END IF;
   END;

   /* Avoid any redundancy; doing two dequeues, only difference is the
      dequeue mode and possibly the message ID to be dequeued. */
   PROCEDURE dequeue (mode_in IN INTEGER)
   IS
   BEGIN
      queueopts.dequeue_mode := mode_in;
      queueopts.wait := DBMS_AQ.NO_WAIT;
      queueopts.visibility := DBMS_AQ.IMMEDIATE;

      IF mode_in = DBMS_AQ.REMOVE
      THEN
         queueopts.msgid := v_msgid;
         queue_changed := TRUE;
      ELSE
         queueopts.msgid := NULL;
      END IF;

      DBMS_AQ.DEQUEUE (queue_name => queue,
         dequeue_options => queueopts,
         message_properties => msgprops,
         payload => student,
         msgid => v_msgid);

      DBMS_OUTPUT.PUT_LINE
          ('Dequeued-' || mode_name (mode_in) || ' ' || student.ssn || 
           ' class ' || student.class_requested);
   END;
BEGIN
   LOOP
      /* Non-destructive dequeue */
      dequeue (DBMS_AQ.BROWSE);

      /* Is this the student I am dropping? */
      IF student.ssn = ssn_in
      THEN
         /* Shift to destructive mode and remove from queue.
            In this case I request the dequeue by msg ID.
            This approach completely bypasses the normal order
            for dequeuing. */
         dequeue (DBMS_AQ.REMOVE);
      END IF;
   END LOOP;

EXCEPTION
   WHEN aq.dequeue_timeout
   THEN
      IF queue_changed
      THEN
         COMMIT;
      END IF;
END;
/