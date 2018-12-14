CREATE OR REPLACE PACKAGE BODY sf_timer
IS
   /* Package variable which stores the last timing made */
   last_timing     NUMBER := NULL;
   /* Package variable which stores context of last timing */
   last_context    VARCHAR2 (32767) := NULL;
   /* Private Variable for "factor" */
   v_factor        NUMBER := NULL;
   /* Private Variable for On/Off Toggle */
   v_onoff         BOOLEAN := TRUE;
   /* Private Variable for "repeats" */
   v_repeats       NUMBER := 100;
   /* Calibrated base timing. */
   v_base_timing   NUMBER := NULL;

   /* Body of Set for "factor" */
   PROCEDURE set_factor (factor_in IN NUMBER)
   IS
   BEGIN
      v_factor := factor_in;
   END set_factor;

   /* Body of Get for "factor" */
   FUNCTION factor
      RETURN NUMBER
   IS
      retval   NUMBER := v_factor;
   BEGIN
      RETURN retval;
   END factor;

   PROCEDURE start_timer (context_in IN VARCHAR2 := NULL)
   /* Save current time and context to package variables. */
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
      -- On 9i, use this: last_timing := DBMS_UTILITY.get_time;
      last_context := context_in;
   END;

   FUNCTION elapsed_time
      RETURN NUMBER
   IS
      /* Grab the current time before doing anything else. */
      /* WFS 9/4/08 - Used get_cpu_time above and get_time here */
      l_end_time   PLS_INTEGER := DBMS_UTILITY.get_cpu_time;
   BEGIN
      IF v_onoff
      THEN
         RETURN (MOD (l_end_time - last_timing + POWER (2, 32)
                    , POWER (2, 32)
                     ));
      END IF;
   END;

   FUNCTION elapsed_message (prefix_in        IN VARCHAR2:= NULL
                           , adjust_in        IN NUMBER:= 0
                           , reset_in         IN BOOLEAN:= TRUE
                           , reset_context_in IN VARCHAR2:= NULL
                            )
      RETURN VARCHAR2
   /*
     || Construct message for display of elapsed time. Programmer can
   || include a prefix to the message and also ask that the last
   || timing variable be reset/updated. This saves a separate call
   || to elapsed.
   */
   IS
      current_timing   NUMBER;
      retval           VARCHAR2 (32767) := NULL;

      FUNCTION adj_time (time_in      IN BINARY_INTEGER
                       , factor_in    IN INTEGER
                       , precision_in IN INTEGER
                        )
         RETURN VARCHAR2
      IS
      BEGIN
         RETURN (TO_CHAR(ROUND ( (time_in - adjust_in) / (100 * factor_in)
                              , precision_in
                               )));
      END;

      FUNCTION formatted_time (time_in    IN BINARY_INTEGER
                             , context_in IN VARCHAR2:= NULL
                              )
         RETURN VARCHAR2
      IS
         retval   VARCHAR2 (32767) := NULL;
      BEGIN
         IF context_in IS NOT NULL
         THEN
            retval := ' since ' || last_context;
         END IF;

         retval :=
               prefix_in
            || ' - Elapsed CPU '
            || retval
            || ': '
            || adj_time (time_in, 1, 3)
            || ' seconds.';

         IF v_factor IS NOT NULL
         THEN
            retval :=
                  retval
               || ' Factored: '
               || adj_time (time_in, v_factor, 5)
               || ' seconds.';
         END IF;

         RETURN retval;
      END;
   BEGIN
      IF v_onoff
      THEN
         IF last_timing IS NULL
         THEN
            /* If there is no last_timing, cannot show anything. */
            retval := NULL;
         ELSE
            /* Construct message with context of last call to elapsed */
            retval := formatted_time (elapsed_time (), last_context);
            last_context := NULL;
         END IF;

         IF reset_in
         THEN
            start_timer (reset_context_in);
         END IF;
      END IF;

      RETURN retval;
   END;

   PROCEDURE show_elapsed_time (prefix_in IN VARCHAR2:= NULL
                              , adjust_in IN NUMBER:= 0
                              , reset_in  IN BOOLEAN:= TRUE
                               )
   /* Little more than a call to the elapsed_message function! */
   IS
   BEGIN
      IF v_onoff
      THEN
         DBMS_OUTPUT.put_line (
            elapsed_message (prefix_in, adjust_in, reset_in)
         );
      END IF;
   END;
   
/*
Explanation of regular expression provided by Vitaliy Lyanchevskiy (Elic): 

This RE (I extended it a bit for generality) is intended
to remove insignificant digits (and punctuations) from
both the left (a sign, zeroes and separators) and the right:

( match non zero digit followed by any number of digits or separators
    (colon between time parts or space after days)
  or
  match just the zero (if interval is less than a second, because I dislike
    numbers starting with a point :) )
) followed by decimal point and exactly 3 digits.

As result we have string representation of an interval in compact form.
I ignore a sign since we know that our intervals could not be negative.

And I use only 3 digits after decimal point since on Windows, where I do
most of testing, it is highest possible precision.


SQL> col i for a30
SQL> select i, lpad(regexp_substr(i, '([1-9][0-9: ]*|0)\.\d{3}'), 20) as ii
  2    from
  3    ( select interval '12345' second * power(9, level - 7) as i
  4        from dual
  5        connect by level <= 10
  6    );

I                              II
------------------------------ --------------------
+000000000 00:00:00.023229295                 0.023
+000000000 00:00:00.209063659                 0.209
+000000000 00:00:01.881572931                 1.881
+000000000 00:00:16.934156379                16.934
+000000000 00:02:32.407407407              2:32.407
+000000000 00:22:51.666666667             22:51.666
+000000000 03:25:45.000000000           3:25:45.000
+000000001 06:51:45.000000000        1 06:51:45.000
+000000011 13:45:45.000000000       11 13:45:45.000
+000000104 03:51:45.000000000      104 03:51:45.000
*/     
END sf_timer;
/