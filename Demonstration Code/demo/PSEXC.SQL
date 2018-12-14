rem DROP TABLE plvexc_log;

CREATE TABLE plvexc_log
   (context VARCHAR2(10),
    error_code INTEGER,
	error_info VARCHAR2(1000),
	create_ts DATE)
/
CREATE OR REPLACE PACKAGE plvexc
/*
|| File: psexc.sql
|| Author: Steven Feuerstein
||   Date: 9/95
||
|| Package to provide generic exception handling and error logging
|| for PL/SQL applications.
*/
IS
   /*
   || Exception used to halt processing when a variety of
   || system exceptions occur. 
   */
   halt_the_process EXCEPTION;

   /* Standard exceptions */
   no_such_table EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_such_table, -942);

   /* Types of exception handling actions to perform. */
   c_continue CONSTANT CHAR(1) := 'C';
   c_rec_continue CONSTANT CHAR(2) := 'RC';
   c_halt CONSTANT CHAR(1) := 'H';
   c_rec_halt CONSTANT CHAR(2) := 'RH';

   PROCEDURE log_errors;
   PROCEDURE nolog_errors;
   FUNCTION logging_errors RETURN BOOLEAN;

   PROCEDURE display_errors;
   PROCEDURE nodisplay_errors;
   FUNCTION displaying_errors RETURN BOOLEAN;

   PROCEDURE handle
      (context_in IN VARCHAR2,
	   err_code_in IN INTEGER,
	   handle_action_in IN VARCHAR2,
	   string_in IN VARCHAR2 := SQLERRM);

END plvexc;
/
show errors
CREATE OR REPLACE PACKAGE BODY plvexc
IS
   log_errors_flag BOOLEAN := TRUE;
   display_errors_flag BOOLEAN := FALSE;

   /* Current exception information. */
   curr_err_code plvexc_log.error_code%TYPE;
   curr_context VARCHAR2(100);
   curr_err_info plvexc_log.error_info%TYPE;

   min_err_code CONSTANT INTEGER := -20000;
   max_err_code CONSTANT INTEGER := -20999;

   /*------------------ Private Modules ------------------*/

   PROCEDURE set_context
      (context_in IN VARCHAR2, 
       err_code_in IN plvexc_log.error_code%TYPE,
       err_info_in IN plvexc_log.error_info%TYPE := NULL)
   IS
   BEGIN
      curr_context := context_in;
      curr_err_code := err_code_in;
      curr_err_info := err_info_in;
   END;

   FUNCTION recording_exception (handle_action_in IN VARCHAR2)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN UPPER (handle_action_in) LIKE 'R%' AND
             logging_errors;
   END;

   PROCEDURE record_exception (string_in IN VARCHAR2)
   IS
   BEGIN
      INSERT INTO plvexc_log
	     (context, error_code, error_info, create_ts)
	  VALUES
         (curr_context, curr_err_code, string_in, SYSDATE);
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   PROCEDURE raise_exception (handle_action_in IN VARCHAR2)
   IS
   BEGIN
      IF handle_action_in = c_continue OR 
         handle_action_in = c_rec_continue
	  THEN
	     NULL;

	  ELSIF handle_action_in = c_halt OR 
	        handle_action_in = c_rec_halt
	  THEN
	     IF curr_err_code BETWEEN min_err_code AND max_err_code
	     THEN
		    RAISE_APPLICATION_ERROR	(curr_err_code, curr_err_info);
		 ELSE
            RAISE halt_the_process;
		 END IF;
      END IF;
   END;

   /*------------------ Public Modules ------------------*/

   PROCEDURE log_errors
   IS
   BEGIN
      log_errors_flag := TRUE;
   END;

   PROCEDURE nolog_errors
   IS
   BEGIN
      log_errors_flag := FALSE;
   END;

   FUNCTION logging_errors RETURN BOOLEAN
   IS
   BEGIN
      RETURN log_errors_flag;
   END;

   PROCEDURE display_errors
   IS
   BEGIN
      display_errors_flag := TRUE;
   END;

   PROCEDURE nodisplay_errors
   IS
   BEGIN
      display_errors_flag := FALSE;
   END;

   FUNCTION displaying_errors RETURN BOOLEAN
   IS
   BEGIN
      RETURN display_errors_flag;
   END;

   PROCEDURE handle
      (context_in IN VARCHAR2,
	   err_code_in IN INTEGER,
	   handle_action_in IN VARCHAR2,
	   string_in IN VARCHAR2 := SQLERRM)
   IS
      output_string VARCHAR2(255) := context_in;
   BEGIN
      set_context (context_in, err_code_in);

      IF recording_exception (handle_action_in)
	  THEN
	     record_exception (string_in);
	  END IF;

      IF displaying_errors
	  THEN
	     IF err_code_in IS NOT NULL
		 THEN 
            output_string :=
		       context_in || ' Code ' || TO_CHAR (err_code_in);
	     END IF;
	     
	     DBMS_OUTPUT.PUT_LINE (output_string);
	     DBMS_OUTPUT.PUT_LINE (SUBSTR (string_in, 1, 255));
	  END IF;

      raise_exception (handle_action_in);	     
   END;

END plvexc;
/
show errors