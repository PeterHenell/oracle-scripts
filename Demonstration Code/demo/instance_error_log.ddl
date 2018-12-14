CONNECT SYSDBA_ACCOUNT/pwd

GRANT ADMINISTER DATABASE TRIGGER TO MY_SCHEMA
/

CONNECT MY_SCHEMA/pwd

DROP TABLE instance_error_log
/

CREATE TABLE instance_error_log (
 username VARCHAR2(30),
 ERROR_CODE INTEGER,
 error_message VARCHAR2(4000),
 stack_position INTEGER,
 backtrace VARCHAR2(4000),
 occurred_on TIMESTAMP
)
/

CREATE OR REPLACE PACKAGE instance_error_log_pkg
/*
|| instance_error_log_pkg
||
|| This package handles the collection and manipulation of
|| Oracle error information as trapped in a SERVERERROR
|| trigger.
||
|| 04-JAN-02 DRH Initial Version (Darryl Hurley) for....
||
|| The fourth edition of Oracle PL/SQL Programming by Steven
|| Feuerstein with Bill Pribyl, Copyright (c) 1997-2005 O'Reilly &
|| Associates, Inc. To submit corrections or find more code samples visit
|| http://www.oreilly.com/catalog/oraclep4/
*/
AS
   -- structure to hold results of error # search
   TYPE find_record_rt IS RECORD (
      total_found PLS_INTEGER
    , min_timestamp TIMESTAMP
    , max_timestamp TIMESTAMP
   );

   -- main logging procedure called from the trigger
   PROCEDURE log_error;

   -- purge the in memory log
   PROCEDURE purge_log;

   -- search the log for a specific error
   PROCEDURE find_error (
      p_errno        IN       PLS_INTEGER
    , p_find_table   OUT      find_record_rt
   );

   -- save (and optionally purge) the log
   PROCEDURE save_log ( p_purge BOOLEAN := FALSE );

   -- view the error log with optional specific error, start
   -- and end date ranges
   PROCEDURE view_log (
      p_errno      PLS_INTEGER := NULL
    , p_min_date   TIMESTAMP := NULL
    , p_max_date   TIMESTAMP := NULL
   );
END instance_error_log_pkg;
/

CREATE OR REPLACE PACKAGE BODY instance_error_log_pkg
AS
   -- structure to hold log of all errors
   TYPE error_aat IS TABLE OF instance_error_log%ROWTYPE
      INDEX BY PLS_INTEGER;

   g_error_table error_aat;

   PROCEDURE log_error
   IS
      l_error_code PLS_INTEGER;
      l_counter PLS_INTEGER := 1;
      l_now TIMESTAMP := SYSTIMESTAMP;
      l_index PLS_INTEGER;
   BEGIN
      LOOP
         -- get the error number off the stack
         l_error_code := ora_server_error ( l_counter );
         -- if the error # is zero then we are done
         EXIT WHEN l_error_code = 0;
         -- add the error to the collection
         l_index := g_error_table.COUNT + 1;
         g_error_table ( l_index ).username :=
                                                               ora_login_user;
         g_error_table ( l_index ).ERROR_CODE := l_error_code;
         g_error_table ( l_index ).error_message :=
                                           ora_server_error_msg ( l_counter );
         g_error_table ( l_index ).backtrace :=
                                          DBMS_UTILITY.format_error_backtrace;
         g_error_table ( l_index ).stack_position := l_counter;
         g_error_table ( l_index ).occurred_on := l_now;
         -- increment the counter and try again
         l_counter := l_counter + 1;
      END LOOP;                                    -- every error on the stack
   END log_error;

   PROCEDURE purge_log
   IS
   BEGIN
      g_error_table.DELETE;
   END purge_log;

   PROCEDURE find_error (
      p_errno        IN       PLS_INTEGER
    , p_find_table   OUT      find_record_rt
   )
   IS
   BEGIN
      FOR counter IN 1 .. g_error_table.COUNT
      LOOP
         IF g_error_table ( counter ).ERROR_CODE = p_errno
         THEN
            p_find_table.total_found :=
                                       NVL ( p_find_table.total_found, 0 )
                                       + 1;
            p_find_table.min_timestamp :=
               LEAST ( NVL ( p_find_table.min_timestamp
                           , g_error_table ( counter ).occurred_on
                           )
                     , g_error_table ( counter ).occurred_on
                     );
            p_find_table.max_timestamp :=
               GREATEST ( NVL ( p_find_table.min_timestamp
                              , g_error_table ( counter ).occurred_on
                              )
                        , g_error_table ( counter ).occurred_on
                        );
         END IF;
      END LOOP;
   END find_error;

   PROCEDURE save_log ( p_purge BOOLEAN := FALSE )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      FOR counter IN 1 .. g_error_table.COUNT
      LOOP
         INSERT INTO instance_error_log
                     ( username
                     , ERROR_CODE
                     , error_message
                     , backtrace
                     , stack_position
                     , occurred_on
                     )
              VALUES ( g_error_table ( counter ).username
                     , g_error_table ( counter ).ERROR_CODE
                     , g_error_table ( counter ).error_message
                     , g_error_table ( counter ).backtrace
                     , g_error_table ( counter ).stack_position
                     , g_error_table ( counter ).occurred_on
                     );
      END LOOP;

      IF p_purge
      THEN
         g_error_table.DELETE;
      END IF;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         RAISE;
   END save_log;

   PROCEDURE view_log (
      p_errno      PLS_INTEGER := NULL
    , p_min_date   TIMESTAMP := NULL
    , p_max_date   TIMESTAMP := NULL
   )
   IS
   BEGIN
      DBMS_OUTPUT.put_line ( 'Error# Seq Timestamp' );
      DBMS_OUTPUT.put_line ( '------ --- --------------------' );

      FOR counter IN 1 .. g_error_table.COUNT
      LOOP
         IF     NVL ( p_errno, g_error_table ( counter ).ERROR_CODE ) =
                                         g_error_table ( counter ).ERROR_CODE
            AND GREATEST ( NVL ( p_min_date
                               , g_error_table ( counter ).occurred_on
                               )
                         , g_error_table ( counter ).occurred_on
                         ) = g_error_table ( counter ).occurred_on
            AND LEAST ( NVL ( p_max_date
                            , g_error_table ( counter ).occurred_on
                            )
                      , g_error_table ( counter ).occurred_on
                      ) = g_error_table ( counter ).occurred_on
         THEN
            DBMS_OUTPUT.put_line
                            (    LPAD ( g_error_table ( counter ).ERROR_CODE
                                      , 6
                                      , 0
                                      )
                              || ' '
                              || LPAD
                                     ( g_error_table ( counter ).stack_position
                                     , 3
                                     )
                              || ' '
                              || TO_CHAR
                                        ( g_error_table ( counter ).occurred_on
                                        , 'DD-MON-YYYY HH24:MI:SSS'
                                        )
                            );
         END IF;
      END LOOP;
   END view_log;
END instance_error_log_pkg;
/

CREATE OR REPLACE TRIGGER instance_error_log_tr
   AFTER SERVERERROR ON DATABASE
BEGIN
   instance_error_log_pkg.log_error;
END instance_error_log_tr;
/

