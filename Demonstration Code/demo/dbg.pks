CREATE TABLE notify (
   created_on DATE,
   created_by VARCHAR2(30),
   text VARCHAR2(2000)
   );

CREATE OR REPLACE PACKAGE dbg

--// Simple debugger mechanism based on notify table
--// and the DBMS_PIPE package.

--// Designed by Steven Feuerstein, RevealNet
--// All rights reserved, copyright 1998

--// www.revealnet.com or 1.800.REVEAL4

--// NOTE: EXECUTE authority on DBMS_LOCK is required.
--// NOTE: EXECUTE authority on DBMS_PIPE is required.
--//
--//   Issue these commands from SYS:
--//   GRANT EXECUTE ON DBMS_LOCK TO PUBLIC;
--//   GRANT EXECUTE ON DBMS_PIPE TO PUBLIC;

/* Directions:
||     1. Create the package.

||     2. Open two sessions in SQL*Plus or another execution
||        environment, connecting to the account that owns
||        the package.

||     3. In one session, execute the runapp procedure. If
||        you accept both defaults, it will run for approximately
||        60 seconds and generate 6 debug messages.

||     4. In the other session, execute the dump2screen procedure
||        to view the progress of the "application".
*/
IS
   c_name CONSTANT VARCHAR2(200) := 'dbg';

   FUNCTION msgcount /* Single Pipe Version */
      RETURN INTEGER;

   FUNCTION defname RETURN VARCHAR2;
   PROCEDURE setdefname (name IN VARCHAR2);

   FUNCTION lastsend /* Single Pipe Version */
      RETURN DATE;
   FUNCTION lastreceive /* Single Pipe Version */
      RETURN DATE;

/* Keep copies of messages sent and received */

   PROCEDURE copysend /* Single Pipe Version */;
   PROCEDURE nocopysend /* Single Pipe Version */;
   FUNCTION copyingsend /* Single Pipe Version */ RETURN BOOLEAN;

   PROCEDURE copyreceive /* Single Pipe Version */;
   PROCEDURE nocopyreceive /* Single Pipe Version */;
   FUNCTION copyingreceive /* Single Pipe Version */ RETURN BOOLEAN;

/* Perform analysis based on copies */

   FUNCTION insend (
      /* Single Pipe Version */
      match IN VARCHAR2
      )
      RETURN INTEGER;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN VARCHAR2
      )
      RETURN INTEGER;

   FUNCTION insend (
      /* Single Pipe Version */
      match IN DATE,
      mask IN VARCHAR2 := 'FMMonth DD, YYYY FMHH24:MI:SS'
      )
      RETURN INTEGER;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN DATE,
      mask IN VARCHAR2 := 'FMMonth DD, YYYY FMHH24:MI:SS'
      )
      RETURN INTEGER;

   FUNCTION insend (
      /* Single Pipe Version */
      match IN NUMBER,
      mask IN VARCHAR2 := NULL
      )
      RETURN INTEGER;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN NUMBER,
      mask IN VARCHAR2 := NULL
      )
      RETURN INTEGER;

   FUNCTION insend (
      /* Single Pipe Version */
      match IN BOOLEAN,
      tfn IN VARCHAR2 := NULL
      )
      RETURN INTEGER;

   FUNCTION inreceive (
      /* Single Pipe Version */
      match IN BOOLEAN,
      tfn IN VARCHAR2 := NULL
      )
      RETURN INTEGER;

/* Overloadings of send */

   PROCEDURE send (
      /* Single Pipe Version */
      pr_created_on IN notify.created_on%TYPE,
      pr_created_by IN notify.created_by%TYPE,
      pr_text IN notify.text%TYPE,
      wait IN INTEGER := 0
      );

   PROCEDURE send (
      /* Single Pipe Version */
      pr_rec IN notify%ROWTYPE,
      wait IN INTEGER := 0
      );

/* Overloadings of receive */

   PROCEDURE receive (
      /* Single Pipe Version */
      pw_created_on OUT notify.created_on%TYPE,
      pw_created_by OUT notify.created_by%TYPE,
      pw_text OUT notify.text%TYPE,
      wait IN INTEGER := 0
      );

   PROCEDURE receive (
      /* Single Pipe Version */
      pw_rec OUT notify%ROWTYPE,
      wait IN INTEGER := 0
      );

/* Returns Nth status and action */

   FUNCTION status (
      /* Single Pipe Version */
      pos IN INTEGER := 0)
   RETURN INTEGER;

   FUNCTION action (
      /* Single Pipe Version */
      pos IN INTEGER := 0)
   RETURN VARCHAR2;

   /* Display contents of pipe. */

   PROCEDURE dump2screen (
      /* Single Pipe Version */
      wait IN INTEGER := 0
      );

   /* Simulate application being debugged. */
   PROCEDURE runapp (
      counter IN INTEGER := 6, 
      sleepsecs IN INTEGER := 10);
END;
/
