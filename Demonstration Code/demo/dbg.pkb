CREATE OR REPLACE PACKAGE BODY dbg
--// Wrapper around pipe based on notify table //--
IS
/* Data structures */

   g_name VARCHAR2(200) := c_name;
   g_msgcount INTEGER;

   /* Send and Receive Status */
   g_lastsend DATE;
   g_lastreceive DATE;

   g_copysend BOOLEAN;
   g_copyreceive BOOLEAN;

   g_sendwait INTEGER := 60;
   g_receivewait INTEGER := 60;

   g_status INTEGER;
   g_action VARCHAR2(2000);

   FUNCTION msgcount /* Single Pipe Version */
      RETURN INTEGER
   IS
      v_name VARCHAR2(200);
      retval INTEGER := g_msgcount;
   BEGIN

      RETURN retval;
   END;

   FUNCTION defname RETURN VARCHAR2
   IS BEGIN
      RETURN g_name;
   END;

   PROCEDURE setdefname (name IN VARCHAR2)
   IS BEGIN
      g_name := NVL (name, c_name);
   END;

   FUNCTION lastsend /* Single Pipe Version */
      RETURN DATE
   IS
      retval DATE := g_lastsend;
   BEGIN
      RETURN retval;
   END;

   FUNCTION lastreceive /* Single Pipe Version */
      RETURN DATE
   IS
      retval DATE := g_lastreceive;
   BEGIN
      RETURN retval;
   END;

/* Keep copies of messages sent and received */

   PROCEDURE copysend /* Single Pipe Version */
   IS
   BEGIN
      g_copysend := TRUE;
   END;

   PROCEDURE nocopysend /* Single Pipe Version */
   IS
   BEGIN
      g_copysend := FALSE;
   END;

   FUNCTION copyingsend /* Single Pipe Version */ RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_copysend;
   END;

   PROCEDURE copyreceive /* Single Pipe Version */
   IS
   BEGIN
      g_copyreceive := TRUE;
   END;

   PROCEDURE nocopyreceive /* Single Pipe Version */
   IS
   BEGIN
      g_copyreceive := FALSE;
   END;

   FUNCTION copyingreceive /* Single Pipe Version */ RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_copyreceive;
   END;

/* Perform analysis based on copies */

   FUNCTION insend (
      /* Single Pipe Version */
      match IN VARCHAR2
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN VARCHAR2
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

   FUNCTION insend (
      /* Single Pipe Version */
      match IN DATE,
      mask IN VARCHAR2 := 'FMMonth DD, YYYY FMHH24:MI:SS'
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN DATE,
      mask IN VARCHAR2 := 'FMMonth DD, YYYY FMHH24:MI:SS'
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

   FUNCTION insend (
      /* Single Pipe Version */
      match IN NUMBER,
      mask IN VARCHAR2 := NULL
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN NUMBER,
      mask IN VARCHAR2 := NULL
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

   FUNCTION insend (
      /* Single Pipe Version */
      match IN BOOLEAN,
      tfn IN VARCHAR2 := NULL
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN BOOLEAN,
      tfn IN VARCHAR2 := NULL
      )
      RETURN INTEGER
   IS
      retval INTEGER;
   BEGIN
      RETURN retval;
   END;

/* Overloadings of send */

   PROCEDURE send (
      /* Single Pipe Version */
      pr_created_on IN notify.created_on%TYPE,
      pr_created_by IN notify.created_by%TYPE,
      pr_text IN notify.text%TYPE,
      wait IN INTEGER := 0
      )
   IS
   BEGIN
      --// Clear the buffer before writing. //--
      DBMS_PIPE.RESET_BUFFER;

      --// For each column, pack item into buffer. //--
      DBMS_PIPE.PACK_MESSAGE (pr_created_on);
      DBMS_PIPE.PACK_MESSAGE (pr_created_by);
      DBMS_PIPE.PACK_MESSAGE (pr_text);

      --// Send the message //--
      g_status := DBMS_PIPE.SEND_MESSAGE (
         g_name,
         NVL (wait, g_sendwait)
         );

      g_action := 'SEND_MESSAGE';
   END;

   PROCEDURE send (
      /* Single Pipe Version */
      pr_rec IN notify%ROWTYPE,
      wait IN INTEGER := 0
      )
   IS
   BEGIN
      dbg.send (
         pr_rec.created_on,
         pr_rec.created_by,
         pr_rec.text,
         wait
         );
   END;

/* Overloadings of receive */

   PROCEDURE receive (
      /* Single Pipe Version */
      pw_created_on OUT notify.created_on%TYPE,
      pw_created_by OUT notify.created_by%TYPE,
      pw_text OUT notify.text%TYPE,
      wait IN INTEGER := 0
      )
   IS
   BEGIN
      --// Receive next message and unpack for each column. //--
      g_status := DBMS_PIPE.RECEIVE_MESSAGE (
         g_name,
         wait
         );

      IF g_status = 0
      THEN
         DBMS_PIPE.UNPACK_MESSAGE (pw_created_on);
         DBMS_PIPE.UNPACK_MESSAGE (pw_created_by);
         DBMS_PIPE.UNPACK_MESSAGE (pw_text);
      END IF;

      g_action := 'RECEIVE_MESSAGE';
   END;

   PROCEDURE receive (
      /* Single Pipe Version */
      pw_rec OUT notify%ROWTYPE,
      wait IN INTEGER := 0
      )
   IS
   BEGIN
      dbg.receive (
         pw_rec.created_on,
         pw_rec.created_by,
         pw_rec.text,
         wait
         );
   END;

/* Returns Nth status and action */

   FUNCTION status (
      /* Single Pipe Version */
      pos IN INTEGER := 0)
   RETURN INTEGER
   IS
   BEGIN
      RETURN g_status;
   END;

   FUNCTION action (
      /* Single Pipe Version */
      pos IN INTEGER := 0)
   RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_action;
   END;

/* Transfer contents from pipe to other repository. */

   PROCEDURE dump2screen (
      /* Single Pipe Version */
      wait IN INTEGER := 0
      )
   IS
      rec notify%ROWTYPE;
   BEGIN
      DBMS_OUTPUT.ENABLE (1000000);

      --// Read pipe until empty, display each message. //--
      LOOP
         dbg.receive (rec, 0 /* no waiting allowed */);
         EXIT WHEN dbg.status != 0;
         DBMS_OUTPUT.PUT_LINE (
            ' Created_on=' || TO_CHAR (rec.created_on, 'MM/DD/YYYY HH:MI:SS'));
         DBMS_OUTPUT.PUT_LINE (' Created_by=' || rec.created_by);
         DBMS_OUTPUT.PUT_LINE (' Text=' || rec.text);
      END LOOP;
   END;

   PROCEDURE runapp (
      counter IN INTEGER := 6, 
      sleepsecs IN INTEGER := 10)
   IS
      feedback notify%ROWTYPE;
   BEGIN
      FOR around IN 1 .. counter
      LOOP
         dbg.send (SYSDATE, USER, 'iteration ' || around);
         p.l ('iteration ' || around);
         DBMS_LOCK.SLEEP (sleepsecs);
      END LOOP;
   END;
END;
/
