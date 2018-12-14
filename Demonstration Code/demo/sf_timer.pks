CREATE OR REPLACE PACKAGE sf_timer
/*
||    File: sf_timer.pks/pkb
||  Author: Steven Feuerstein
||
||  PL/SQL timer based on DBMS_UTILITY.GET_TIME
||
******************************************************************/
IS
/*
Frankfurt Oct 2009
Should use NUMBER instead of PLS_INTEGER to avoid
possible overflow.
*/

   /* Specification of Set/Get for "factor" */
   PROCEDURE set_factor (factor_in IN NUMBER);

   FUNCTION factor
      RETURN NUMBER;

   /* Capture current value in DBMS_UTILITY.GET_TIME */
   PROCEDURE start_timer (context_in IN VARCHAR2 := NULL);

   /* Return amount of time elapsed since call to capture */
   FUNCTION elapsed_time
      RETURN NUMBER;

   /* Construct message showing time elapsed since call to capture */
   FUNCTION elapsed_message (
      prefix_in          IN   VARCHAR2 := NULL
    , adjust_in          IN   NUMBER := 0
    , reset_in           IN   BOOLEAN := TRUE
    , reset_context_in   IN   VARCHAR2 := NULL
   )
      RETURN VARCHAR2;

   /* Display message of elapsed time */
   PROCEDURE show_elapsed_time (
      prefix_in   IN   VARCHAR2 := NULL
    , adjust_in   IN   NUMBER := 0
    , reset_in    IN   BOOLEAN := TRUE
   );
END sf_timer;
/

