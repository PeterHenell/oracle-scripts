DECLARE
   queueopts DBMS_AQ.ENQUEUE_OPTIONS_T;
   msgprops DBMS_AQ.MESSAGE_PROPERTIES_T;
   student student_reg_t;
   v_msgid aq.msgid_type;
BEGIN
   aq.stop_and_drop ('reg_queue_table');

   aq.create_queue ('reg_queue_table', 'student_reg_t', 'reg_queue');

   queueopts.visibility := DBMS_AQ.IMMEDIATE;

   student := student_reg_t ('123-46-8888', 'Politics 101');
   DBMS_AQ.ENQUEUE ('reg_queue', queueopts, msgprops, student, v_msgid);

   student := student_reg_t ('555-09-1798', 'Politics 101');
   DBMS_AQ.ENQUEUE ('reg_queue', queueopts, msgprops, student, v_msgid);

   student := student_reg_t ('987-65-4321', 'Politics 101');
   DBMS_AQ.ENQUEUE ('reg_queue', queueopts, msgprops, student, v_msgid);

   student := student_reg_t ('123-46-8888', 'Philosophy 101');
   DBMS_AQ.ENQUEUE ('reg_queue', queueopts, msgprops, student, v_msgid);

   DBMS_OUTPUT.PUT_LINE ('Messages in queue: ' || 
      aq.msgcount ('reg_queue_table', 'reg_queue'));

   drop_student ('reg_queue', '123-46-8888');

   DBMS_OUTPUT.PUT_LINE ('Messages in queue: ' || 
      aq.msgcount ('reg_queue_table', 'reg_queue'));
END;
/