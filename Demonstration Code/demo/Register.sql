CREATE OR REPLACE PACKAGE register_app
IS
   /*
   || Enhances DBMS_APPLICATION_INFO by capturing performance
   || statistics when module, action, or client_info are set.
   ||
   || Statistics may be displayed in SQL*Plus for tracking and
   || debugging purposes.  A useful enhancement would be to
   || extend this idea to a logging feature, so stats are logged
   || to a table for analysis.
   ||
   || Also enforces requirement that a module be registered before
   || an action can be registered.
   ||
   || Author:  John Beresniewicz, Savant Corp
   || Created: 09/01/97
   ||
   || Compilation Requirements:
   ||
   || SELECT on SYS.V_$MYSTAT
   || SELECT on SYS.V_$STATNAME
   ||
   || Execution Requirements:
   ||
   ||
   */

   /* registers the application module */
   PROCEDURE module
      (module_name_IN IN VARCHAR2
      ,action_name_IN IN VARCHAR2 DEFAULT 'BEGIN');

   /* registers the action within module */
   PROCEDURE action(action_name_IN IN VARCHAR2);

   /* registers additional application client information */
   PROCEDURE client_info(client_info_IN IN VARCHAR2);

   /* returns the currently registered module */
   FUNCTION current_module RETURN VARCHAR2;

   /* returns the currently registered action */
   FUNCTION current_action RETURN VARCHAR2;

   /* returns the currently registered client info */
   FUNCTION current_client_info RETURN VARCHAR2;

   /* sets stat display for SQL*Plus ON (TRUE) or OFF (FALSE) */
   PROCEDURE set_display_TF(display_ON_TF_IN IN BOOLEAN);

END register_app;
/

CREATE OR REPLACE PACKAGE BODY register_app
IS
   /* private global boolean controls display of stats */
   display_TF_  BOOLEAN := FALSE;

   /* record type to hold performance stats */
   TYPE stat_rectype IS RECORD
      (timer_hsecs  NUMBER := 0
      ,logical_rds  NUMBER := 0
      ,physical_rds NUMBER := 0
      );

   /* private global to hold stats at begin of each module/action */
   stat_rec stat_rectype;

   /*
   || Gets current performance stats from V$MYSTAT and
   || sets the global record stat_rec.  If display_TF_ is TRUE
   || then uses DBMS_OUTPUT to display the stat differences
   || since last call to set_stats.
   */
   PROCEDURE set_stats
   IS
      temp_statrec   stat_rectype;
      diff_statrec   stat_rectype;

      /*
      || Embedded inline function to retrieve stats by name
      || from V$MYSTAT.
      */
      FUNCTION get_stat(statname_IN IN VARCHAR2)
         RETURN NUMBER
      IS
         /* return value -9999 indicates problem */
         temp_stat_value  NUMBER := -9999;

         /* cursor retrieves stat value by name */
         CURSOR stat_val_cur(statname VARCHAR2)
         IS
         SELECT value
           FROM sys.v_$mystat    S
               ,sys.v_$statname  N
          WHERE
                S.statistic# = N.statistic#
            AND N.name = statname;

      BEGIN
         OPEN stat_val_cur(statname_IN);
         FETCH stat_val_cur INTO temp_stat_value;
         CLOSE stat_val_cur;
         RETURN temp_stat_value;

      EXCEPTION
         WHEN OTHERS THEN
            IF stat_val_cur%ISOPEN
            THEN
               CLOSE stat_val_cur;
            END IF;
            RETURN temp_stat_value;
      END get_stat;

   BEGIN
      /*
      || load current values for performance statistics
      */
      temp_statrec.timer_hsecs := DBMS_UTILITY.GET_TIME;
      temp_statrec.logical_rds := get_stat('session logical reads');
      temp_statrec.physical_rds := get_stat('physical reads');

      /*
      || calculate diffs between current and previous stats
      */
      diff_statrec.timer_hsecs :=
               temp_statrec.timer_hsecs - stat_rec.timer_hsecs;
      diff_statrec.logical_rds :=
               temp_statrec.logical_rds - stat_rec.logical_rds;
      diff_statrec.physical_rds :=
               temp_statrec.physical_rds - stat_rec.physical_rds;

      /*
      || Both current module AND client info NULL indicates
      || initialization for session and stats should not be displayed.
      */
      IF display_TF_ AND
         (current_module IS NOT NULL OR current_client_info IS NOT NULL)
      THEN
         DBMS_OUTPUT.PUT_LINE('Module: '||current_module);
         DBMS_OUTPUT.PUT_LINE('Action: '||current_action);
         DBMS_OUTPUT.PUT_LINE('Client Info: '||current_client_info);
         DBMS_OUTPUT.PUT_LINE('Stats:  '||
            'elapsed secs: '||TO_CHAR(ROUND(diff_statrec.timer_hsecs/100,2))||
            ', physical reads: '||TO_CHAR(diff_statrec.physical_rds)||
            ', logical reads: '||TO_CHAR(diff_statrec.logical_rds)
            );

      END IF;

      /* OK, now initialize stat_rec to current values */
      stat_rec := temp_statrec;

   END set_stats;


   PROCEDURE module
      (module_name_IN IN VARCHAR2
      ,action_name_IN IN VARCHAR2 DEFAULT 'BEGIN')
   IS
      temp_action_name   VARCHAR2(64) := action_name_IN;

   BEGIN

      IF module_name_IN IS NULL
      THEN
         temp_action_name := NULL;
      END IF;

      set_stats;
      SYS.DBMS_APPLICATION_INFO.SET_MODULE
         (module_name_IN, temp_action_name);

   END module;


   PROCEDURE action(action_name_IN IN VARCHAR2)
   IS
   BEGIN
      /*
      || raise error if trying to register an action when module
      || has not been registered
      */
      IF current_module IS NULL AND action_name_IN IS NOT NULL
      THEN
         RAISE_APPLICATION_ERROR(-20001, 'Module not registered');
      ELSE
         set_stats;
         SYS.DBMS_APPLICATION_INFO.SET_ACTION(action_name_IN);
      END IF;

   END action;


   PROCEDURE client_info(client_info_IN IN VARCHAR2)
   IS
   BEGIN
      set_stats;
      SYS.DBMS_APPLICATION_INFO.SET_CLIENT_INFO(client_info_IN);
   END client_info;


   FUNCTION current_module RETURN VARCHAR2
   IS
      /*
      || calls DBMS_APPLICATION_INFO.READ_MODULE
      || and returns the module name
      */
      temp_module_name VARCHAR2(64);
      temp_action_name VARCHAR2(64);

   BEGIN
      SYS.DBMS_APPLICATION_INFO.READ_MODULE
         (temp_module_name, temp_action_name);

      RETURN temp_module_name;
   END current_module;


   FUNCTION current_action RETURN VARCHAR2
   IS
      /*
      || calls DBMS_APPLICATION_INFO.READ_MODULE
      || and returns the action name
      */
      temp_module_name VARCHAR2(64);
      temp_action_name VARCHAR2(64);

   BEGIN
      SYS.DBMS_APPLICATION_INFO.READ_MODULE
         (temp_module_name, temp_action_name);

      RETURN temp_action_name;
   END current_action;

   FUNCTION current_client_info RETURN VARCHAR2
   IS
      /*
      || calls DBMS_APPLICATION_INFO.READ_CLIENT_INFO
      || and returns the client info
      */
      temp_client_info VARCHAR2(64);

   BEGIN
      SYS.DBMS_APPLICATION_INFO.READ_CLIENT_INFO
         (temp_client_info);

      RETURN temp_client_info;
   END current_client_info;

   PROCEDURE set_display_TF(display_ON_TF_IN IN BOOLEAN)
   IS
      /*
      || Sets or unsets global boolean controlling
      || display of stats using DBMS_OUTPUT when
      || module or action changes.
      */
   BEGIN
      display_TF_ := display_ON_TF_IN;
   END set_display_TF;

END register_app;
/

