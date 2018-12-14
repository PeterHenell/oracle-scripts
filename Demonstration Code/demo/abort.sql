DROP TABLE error_log
/
CREATE TABLE error_log (
   err_code INTEGER,
   err_message VARCHAR2(4000),
   call_stack VARCHAR2(4000),
   back_trace VARCHAR2(4000),
   created_on DATE,
   created_by VARCHAR2(30)
)
/

CREATE OR REPLACE PACKAGE errpkg
IS
   -- Errpkg raises this exception if the user requests an abort.
   e_abort_failure   EXCEPTION;
   en_abort_failure  PLS_INTEGER := -20999;
   PRAGMA EXCEPTION_INIT (e_abort_failure, -20999);

   -- Reset status to "not aborting".
   PROCEDURE reset_status;

   -- Record an error and indicate if this error should initiate
   -- an abort.
   PROCEDURE record_error (
      err_code_in      IN   error_log.err_code%TYPE DEFAULT SQLCODE
     ,err_message_in   IN   error_log.err_message%TYPE DEFAULT NULL
     ,abort_in         IN   BOOLEAN DEFAULT FALSE
   );
END errpkg;
/

CREATE OR REPLACE PACKAGE BODY errpkg
IS
   g_abort   BOOLEAN DEFAULT FALSE;

   PROCEDURE reset_status
   IS
   BEGIN
      g_abort := FALSE;
   END reset_status;

   PROCEDURE record_error (
      err_code_in      IN   error_log.err_code%TYPE DEFAULT SQLCODE
     ,err_message_in   IN   error_log.err_message%TYPE DEFAULT NULL
     ,abort_in         IN   BOOLEAN DEFAULT FALSE
   )
   IS
      PROCEDURE insert_row
      IS
         PRAGMA AUTONOMOUS_TRANSACTION;
      BEGIN
         INSERT INTO error_log
                     (err_code
                     ,err_message
                     ,call_stack
                     ,back_trace
                     ,created_on, created_by
                     )
              VALUES (err_code_in
                     ,SUBSTR (NVL (err_message_in
                                  ,DBMS_UTILITY.format_error_stack
                                  )
                             ,1
                             ,4000
                             )
                     ,SUBSTR (DBMS_UTILITY.format_call_stack, 1, 4000)
                     /* Back Trace available only in Oracle Database 10g */
                     ,SUBSTR (DBMS_UTILITY.format_error_backtrace, 1, 4000)
                     ,SYSDATE, USER
                     );

         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            -- Must rollback on exit from autonomous transaction.
            -- Display generic message to indicate problem.
            ROLLBACK;
            DBMS_OUTPUT.put_line ('Unable to write to error log!');
            DBMS_OUTPUT.put_line ('Error:');
            DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      END insert_row;
   BEGIN
      IF g_abort
      THEN
         RAISE e_abort_failure;
      END IF;

      insert_row;

      IF abort_in
      THEN
         g_abort := abort_in;
         RAISE_APPLICATION_ERROR (en_abort_failure
		    , 'Abort exception invoked by developer!');
      END IF;
   END record_error;
END errpkg;
/
