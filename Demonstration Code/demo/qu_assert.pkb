CREATE OR REPLACE PACKAGE BODY qu_assert
IS
   /* Qute
   - Convert to Qute version of package with minimal UT dependencies.

   - Reorg reporting of results to give better information, especially
     when errors occur.
   */

   /************************************************************************
   GNU General Public License for utPLSQL

   Copyright (C) 2000-2003
   Steven Feuerstein and the utPLSQL Project
   (steven@stevenfeuerstein.com)

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program (see license.txt); if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
   ************************************************************************
   $Log: ut_assert2.pkb,v $
   Revision 1.6  2004/11/23 14:56:47  chrisrimmer
   Moved dbms_pipe code into its own package.  Also changed some preprocessor flags

   Revision 1.5  2004/11/16 09:46:48  chrisrimmer
   Changed to new version detection system.

   Revision 1.4  2004/07/14 17:01:57  chrisrimmer
   Added first version of pluggable reporter packages

   Revision 1.3  2003/07/11 14:32:52  chrisrimmer
   Added 'throws' bugfix from Ivan Desjardins

   Revision 1.2  2003/07/01 19:36:46  chrisrimmer
   Added Standard Headers

   ************************************************************************/

   /* START chrisrimmer 42694 */
   g_previous_pass BOOLEAN;
   /* END chrisrimmer 42694 */
   g_showresults BOOLEAN := FALSE;
   c_not_placeholder CONSTANT VARCHAR2 ( 10 ) := '#$NOT$#';

   --
   SUBTYPE maxvarchar2 IS VARCHAR2 ( 32767 );

   c_yes CONSTANT CHAR ( 1 ) := 'Y';
   c_no CONSTANT CHAR ( 1 ) := 'N';
   --
   g_current_harness_guid VARCHAR2 ( 32767 ) DEFAULT NULL;
   g_dbms_output_only BOOLEAN DEFAULT FALSE;

   FUNCTION current_harness_guid
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_current_harness_guid;
   END current_harness_guid;

   PROCEDURE set_current_harness_info (
      run_harness_id_in     IN   VARCHAR2
    , dbms_output_only_in   IN   BOOLEAN
   )
   IS
   BEGIN
      g_current_harness_guid := run_harness_id_in;
      g_dbms_output_only := dbms_output_only_in;
   END set_current_harness_info;

   FUNCTION dbms_output_only
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN NVL ( g_dbms_output_only, FALSE );
   END dbms_output_only;

   FUNCTION ifelse ( bool_in IN BOOLEAN, tval_in IN BOOLEAN, fval_in IN BOOLEAN )
      RETURN BOOLEAN
   IS
   BEGIN
      IF bool_in
      THEN
         RETURN tval_in;
      ELSE
         RETURN fval_in;
      END IF;
   END;

   FUNCTION ifelse ( bool_in IN BOOLEAN, tval_in IN DATE, fval_in IN DATE )
      RETURN DATE
   IS
   BEGIN
      IF bool_in
      THEN
         RETURN tval_in;
      ELSE
         RETURN fval_in;
      END IF;
   END;

   FUNCTION ifelse ( bool_in IN BOOLEAN, tval_in IN NUMBER, fval_in IN NUMBER )
      RETURN NUMBER
   IS
   BEGIN
      IF bool_in
      THEN
         RETURN tval_in;
      ELSE
         RETURN fval_in;
      END IF;
   END;

   FUNCTION ifelse (
      bool_in   IN   BOOLEAN
    , tval_in   IN   VARCHAR2
    , fval_in   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      IF bool_in
      THEN
         RETURN tval_in;
      ELSE
         RETURN fval_in;
      END IF;
   END;

   FUNCTION vc2bool ( vc IN VARCHAR2 )
      RETURN BOOLEAN
   IS
   BEGIN
      IF vc = c_yes
      THEN
         RETURN TRUE;
      ELSIF vc = c_no
      THEN
         RETURN FALSE;
      ELSE
         RETURN NULL;
      END IF;
   END;

   FUNCTION bool2vc ( bool IN BOOLEAN )
      RETURN VARCHAR2
   IS
   BEGIN
      IF bool
      THEN
         RETURN c_yes;
      ELSIF NOT bool
      THEN
         RETURN c_no;
      ELSE
         RETURN 'NULL';
      END IF;
   END;

   FUNCTION b2v ( bool_in IN BOOLEAN )
      RETURN VARCHAR2
   IS
   BEGIN
      IF bool_in
      THEN
         RETURN 'TRUE';
      ELSIF NOT bool_in
      THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'NULL';
      END IF;
   END;

   FUNCTION replace_not_placeholder ( stg_in IN VARCHAR2, success_in IN BOOLEAN )
      RETURN VARCHAR2
   IS
   BEGIN
      IF success_in
      THEN
         RETURN REPLACE ( stg_in, c_not_placeholder, NULL );
      ELSE
         RETURN REPLACE ( stg_in, c_not_placeholder, ' not ' );
      END IF;
   END;

   FUNCTION minimized_whitespace ( string_in IN VARCHAR2 )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN TRANSLATE ( string_in
                       , 'A' || CHR ( 9 ) || CHR ( 10 ) || CHR ( 13 )
                       , 'A   '
                       );
   END minimized_whitespace;

   PROCEDURE report_result (
      result_guid_in   IN   VARCHAR2
    , status_in        IN   VARCHAR2
    , description_in   IN   VARCHAR2
   )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      IF dbms_output_only
      THEN
         BEGIN
            DBMS_OUTPUT.put_line (    c_output_prefix || '      '
                                   || status_in
                                   || ' - '
                                   || description_in
                                 );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.ENABLE ( 1000000 );
               DBMS_OUTPUT.put_line (    '      '
                                      || status_in
                                      || ' - '
                                      || description_in
                                    );
         END;
      ELSE
         EXECUTE IMMEDIATE    'BEGIN qu_result_xp.set_result (result_universal_id_in => :1, harness_guid_in => :2,'
                           || 'result_status_in => :3, description_in => :4); END;'
                     USING result_guid_in
                         , current_harness_guid
                         , status_in
                         , description_in;
      END IF;
   END report_result;

   PROCEDURE this (
      outcome_guid_in   IN   VARCHAR2
    , msg_in            IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
      l_status VARCHAR2 ( 32767 );
      l_message VARCHAR2 ( 32767 );
   BEGIN
      -- FALSE means that the test succeeded.
      IF NOT check_this_in OR ( check_this_in IS NULL AND NOT null_ok_in )
      THEN
         l_status := c_failure;
      ELSE
         l_status := c_success;
      END IF;

      IF msg_in = 'THIS'
      THEN
         l_message :=
            message_expected ( check_this_in        => b2v ( check_this_in )
                             , against_this_in      => b2v ( TRUE )
                             );
      ELSE
         l_message := msg_in;
      END IF;

      report_result ( outcome_guid_in, l_status, l_message );

      IF raise_exc_in AND l_status = c_failure
      THEN
         RAISE PROGRAM_ERROR;
      END IF;
   END this;

   -- Support success and failure messages
   PROCEDURE this2 (
      outcome_guid_in   IN   VARCHAR2
    , success_msg_in         VARCHAR2
    , failure_msg_in    IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
      l_failure BOOLEAN
         := NOT check_this_in
            OR ( check_this_in IS NULL AND NOT null_ok_in );
   BEGIN
      IF l_failure
      THEN
         this ( outcome_guid_in
              , failure_msg_in
              , check_this_in
              , null_ok_in
              , raise_exc_in
              );
      ELSE
         this ( outcome_guid_in
              , success_msg_in
              , check_this_in
              , null_ok_in
              , raise_exc_in
              );
      END IF;
   END this2;

   FUNCTION file_descrip ( file_in IN VARCHAR2, dir_in IN VARCHAR2 )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN file_in || '" located in "' || dir_in;
   END;

   FUNCTION to_string ( value_in IN VARCHAR2 )
      RETURN VARCHAR2
   IS
   BEGIN
      IF value_in IS NULL
      THEN
         RETURN 'NULL';
      ELSE
         RETURN '"' || value_in || '"';
      END IF;
   END to_string;

   FUNCTION message_expected (
      check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (    'Expected '
               || to_string ( against_this_in )
               || ' and got '
               || to_string ( check_this_in )
             );
   END;

   FUNCTION message_expected (
      operator_in       IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (    'Expected '
               || to_string ( against_this_in )
               || ' to be '
               || CASE operator_in
                     WHEN '='
                        THEN 'equal to'
                     WHEN '>'
                        THEN 'greater than to'
                     WHEN '>='
                        THEN 'greater than or equal to'
                     WHEN '<'
                        THEN 'less than to'
                     WHEN '<='
                        THEN 'less than or equal to'
                     WHEN '!='
                        THEN 'not equal to'
                  END
               || ' '
               || to_string ( check_this_in )
             );
   END;

   -- utPLSQL 2.0.8 General evaluation mechanism
   PROCEDURE eval (
      outcome_guid_in   IN   VARCHAR2
    , using_in          IN   VARCHAR2
    ,                                                        -- The expression
      value_name_in     IN   value_name_tt
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
      --      fdbk PLS_INTEGER;
      cur PLS_INTEGER := DBMS_SQL.open_cursor;
      eval_result CHAR ( 1 );
      eval_block maxvarchar2;
      value_name_str maxvarchar2;
      eval_description maxvarchar2;
      parse_error EXCEPTION;
   BEGIN
      FOR indx IN value_name_in.FIRST .. value_name_in.LAST
      LOOP
         value_name_str :=
               value_name_str
            || ' '
            || NVL ( value_name_in ( indx ).NAME, 'P' || indx )
            || ' = '
            || value_name_in ( indx ).VALUE;
      END LOOP;

      eval_description :=
                   'Evaluation of "' || using_in || '" with' || value_name_str;
      eval_block :=
            'DECLARE
           b_result BOOLEAN;
        BEGIN
           b_result := '
         || using_in
         || ';
           IF b_result THEN :result := '''
         || c_yes
         || '''; '
         || 'ELSIF NOT b_result THEN :result := '''
         || c_no
         || '''; '
         || 'ELSE :result := NULL;
           END IF;
        END;';

      BEGIN
         DBMS_SQL.parse ( cur, eval_block, DBMS_SQL.native );
      EXCEPTION
         WHEN OTHERS
         THEN
            -- Report the parse error!
            IF DBMS_SQL.is_open ( cur )
            THEN
               DBMS_SQL.close_cursor ( cur );
            END IF;

            this2 ( outcome_guid_in      => outcome_guid_in
                  , success_msg_in       => NULL
                  , failure_msg_in       =>    'Error '
                                            || SQLCODE
                                            || ' parsing '
                                            || eval_block
                  , check_this_in        => FALSE
                  , null_ok_in           => null_ok_in
                  , raise_exc_in         => raise_exc_in
                  );
            RAISE parse_error;
      END;

      FOR indx IN value_name_in.FIRST .. value_name_in.LAST
      LOOP
         DBMS_SQL.bind_variable ( cur
                                , NVL ( value_name_in ( indx ).NAME
                                      , 'P' || indx
                                      )
                                , value_name_in ( indx ).VALUE
                                );
      END LOOP;

      DBMS_SQL.bind_variable ( cur, 'result', 'a' );
      --      fdbk := dbms_sql.EXECUTE(cur);
      DBMS_SQL.variable_value ( cur, 'result', eval_result );
      DBMS_SQL.close_cursor ( cur );
      this2 ( outcome_guid_in      => outcome_guid_in
            , success_msg_in       => eval_description || ' evaluated to TRUE'
            , failure_msg_in       => eval_description
                                      || ' evaluated to FALSE'
            , check_this_in        => vc2bool ( eval_result )
            , null_ok_in           => null_ok_in
            , raise_exc_in         => raise_exc_in
            );
   EXCEPTION
      WHEN parse_error
      THEN
         IF raise_exc_in
         THEN
            RAISE;
         ELSE
            NULL;
         END IF;
      WHEN OTHERS
      THEN
         IF DBMS_SQL.is_open ( cur )
         THEN
            DBMS_SQL.close_cursor ( cur );
         END IF;

         -- Likely the block got too large!
         this2 ( outcome_guid_in      => outcome_guid_in
               , success_msg_in       => NULL
               , failure_msg_in       =>    'Error in '
                                         || eval_description
                                         || ' Error: '
                                         || DBMS_UTILITY.format_error_stack
               , check_this_in        => FALSE
               , null_ok_in           => null_ok_in
               , raise_exc_in         => raise_exc_in
               );
   END;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , against_this_in
                                                      , check_this_in
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   NUMBER
    , against_this_in   IN   NUMBER
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , check_this_in
                                                      , against_this_in
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , against_this_in   IN   BOOLEAN
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , b2v ( check_this_in )
                                                      , b2v ( against_this_in )
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   DATE
    , against_this_in   IN   DATE
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
      v_check DATE;
      v_against DATE;
   BEGIN
      IF truncate_in
      THEN
         v_check := TRUNC ( check_this_in );
         v_against := TRUNC ( against_this_in );
      ELSE
         v_check := check_this_in;
         v_against := against_this_in;
      END IF;

      l_expr :=
         CASE operator_in
            WHEN '='
               THEN v_check = v_against
            WHEN 'EQ'
               THEN v_check = v_against
            WHEN '!='
               THEN v_check != v_against
            WHEN '<>'
               THEN v_check <> v_against
            WHEN 'NEQ'
               THEN v_check <> v_against
            WHEN '>'
               THEN v_check > v_against
            WHEN 'GT'
               THEN v_check > v_against
            WHEN '>='
               THEN v_check >= v_against
            WHEN 'GTE'
               THEN v_check >= v_against
            WHEN '<'
               THEN v_check < v_against
            WHEN 'LT'
               THEN v_check < v_against
            WHEN '<='
               THEN v_check <= v_against
            WHEN 'LTE'
               THEN v_check <= v_against
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected
                                                ( operator_in
                                                , TO_CHAR ( v_check
                                                          , 'YYYYMMDDHH24MISS'
                                                          )
                                                , TO_CHAR ( v_against
                                                          , 'YYYYMMDDHH24MISS'
                                                          )
                                                )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   TIMESTAMP
    , against_this_in   IN   TIMESTAMP
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , check_this_in
                                                      , against_this_in
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   TIMESTAMP WITH TIME ZONE
    , against_this_in   IN   TIMESTAMP WITH TIME ZONE
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , check_this_in
                                                      , against_this_in
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   TIMESTAMP WITH LOCAL TIME ZONE
    , against_this_in   IN   TIMESTAMP WITH LOCAL TIME ZONE
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , check_this_in
                                                      , against_this_in
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   INTERVAL DAY TO SECOND
    , against_this_in   IN   INTERVAL DAY TO SECOND
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , check_this_in
                                                      , against_this_in
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   INTERVAL YEAR TO MONTH
    , against_this_in   IN   INTERVAL YEAR TO MONTH
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   )
   IS
      l_expr BOOLEAN;
   BEGIN
      l_expr :=
         CASE operator_in
            WHEN '='
               THEN check_this_in = against_this_in
            WHEN 'EQ'
               THEN check_this_in = against_this_in
            WHEN '!='
               THEN check_this_in != against_this_in
            WHEN '<>'
               THEN check_this_in <> against_this_in
            WHEN 'NEQ'
               THEN check_this_in <> against_this_in
            WHEN '>'
               THEN check_this_in > against_this_in
            WHEN 'GT'
               THEN check_this_in > against_this_in
            WHEN '>='
               THEN check_this_in >= against_this_in
            WHEN 'GTE'
               THEN check_this_in >= against_this_in
            WHEN '<'
               THEN check_this_in < against_this_in
            WHEN 'LT'
               THEN check_this_in < against_this_in
            WHEN '<='
               THEN check_this_in <= against_this_in
            WHEN 'LTE'
               THEN check_this_in <= against_this_in
            ELSE FALSE
         END;
      this ( outcome_guid_in      => outcome_guid_in
           , msg_in               => message_expected ( operator_in
                                                      , check_this_in
                                                      , against_this_in
                                                      )
           , check_this_in        => NVL ( l_expr, FALSE )
           , null_ok_in           => null_ok_in
           , raise_exc_in         => raise_exc_in
           );
   END compare_two_values;

   PROCEDURE ieqminus (
      outcome_guid_in   IN   VARCHAR2
    , msg_in            IN   VARCHAR2
    , query1_in         IN   VARCHAR2
    , query2_in         IN   VARCHAR2
    , minus_desc_in     IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
      ival PLS_INTEGER;
      v_block VARCHAR2 ( 32767 )
         :=    'DECLARE
         CURSOR cur IS 
               SELECT 1
               FROM DUAL
               WHERE EXISTS (('
            || query1_in
            || ' MINUS '
            || query2_in
            || ')
        UNION
        ('
            || query2_in
            || ' MINUS '
            || query1_in
            || '));
          rec cur%ROWTYPE;
       BEGIN     
          OPEN cur;
          FETCH cur INTO rec;
          IF cur%FOUND 
          THEN 
             :retval := 1;
          ELSE 
             :retval := 0;
          END IF;
          CLOSE cur;
       END;';
   BEGIN
      EXECUTE IMMEDIATE v_block
                  USING OUT ival;

      this ( outcome_guid_in
           , replace_not_placeholder ( msg_in, ival = 0 )
           , ival = 0
           , FALSE
           , raise_exc_in
           );
   EXCEPTION
      WHEN OTHERS
      THEN
         report_result ( outcome_guid_in
                       , c_failure
                       , DBMS_UTILITY.format_error_stack
                       );
   END;

   PROCEDURE eqtable (
      outcome_guid_in    IN   VARCHAR2
    , check_this_in      IN   VARCHAR2
    , against_this_in    IN   VARCHAR2
    , check_where_in     IN   VARCHAR2 := NULL
    , against_where_in   IN   VARCHAR2 := NULL
    , raise_exc_in       IN   BOOLEAN := FALSE
   )
   IS
      CURSOR info_cur ( sch_in IN VARCHAR2, tab_in IN VARCHAR2 )
      IS
         SELECT   t.column_name
             FROM all_tab_columns t
            WHERE t.owner = sch_in AND t.table_name = tab_in
         ORDER BY column_id;

      FUNCTION collist ( tab IN VARCHAR2 )
         RETURN VARCHAR2
      IS
         l_schema VARCHAR2 ( 100 );
         l_table VARCHAR2 ( 100 );
         l_dot PLS_INTEGER := INSTR ( tab, '.' );
         retval VARCHAR2 ( 32767 );
      BEGIN
         IF l_dot = 0
         THEN
            l_schema := USER;
            l_table := UPPER ( tab );
         ELSE
            l_schema := UPPER ( SUBSTR ( tab, 1, l_dot - 1 ));
            l_table := UPPER ( SUBSTR ( tab, l_dot + 1 ));
         END IF;

         FOR rec IN info_cur ( l_schema, l_table )
         LOOP
            retval := retval || ',' || rec.column_name;
         END LOOP;

         RETURN LTRIM ( retval, ',' );
      END;
   BEGIN
      ieqminus ( outcome_guid_in
               ,    'Contents of "'
                 || check_this_in
                 || ifelse ( check_where_in IS NULL
                           , '"'
                           , '" WHERE ' || check_where_in
                           )
                 || ' does '
                 || c_not_placeholder
                 -- ifelse (NOT l_failure, NULL, ' not ')
                 || 'match "'
                 || against_this_in
                 || ifelse ( against_where_in IS NULL
                           , '"'
                           , '" WHERE ' || against_where_in
                           )
               ,    'SELECT T1.*, COUNT(*) FROM '
                 || check_this_in
                 || ' T1  WHERE '
                 || NVL ( check_where_in, '1=1' )
                 || ' GROUP BY '
                 || collist ( check_this_in )
               ,    'SELECT T2.*, COUNT(*) FROM '
                 || against_this_in
                 || ' T2  WHERE '
                 || NVL ( against_where_in, '1=1' )
                 || ' GROUP BY '
                 || collist ( against_this_in )
               , 'Table Equality'
               , raise_exc_in
               );
   END;

   PROCEDURE eqtabcount (
      outcome_guid_in    IN   VARCHAR2
    , check_this_in      IN   VARCHAR2
    , against_this_in    IN   VARCHAR2
    , check_where_in     IN   VARCHAR2 := NULL
    , against_where_in   IN   VARCHAR2 := NULL
    , raise_exc_in       IN   BOOLEAN := FALSE
   )
   IS
   --      ival PLS_INTEGER;
   BEGIN
      ieqminus ( outcome_guid_in
               ,    'Row count of "'
                 || check_this_in
                 || ifelse ( check_where_in IS NULL
                           , '"'
                           , '" WHERE ' || check_where_in
                           )
                 || ' does '
                 || c_not_placeholder
                 -- ifelse (NOT l_failure, NULL, ' not ')
                 || 'match that of "'
                 || against_this_in
                 || ifelse ( against_where_in IS NULL
                           , '"'
                           , '" WHERE ' || against_where_in
                           )
               ,    'SELECT COUNT(*) FROM '
                 || check_this_in
                 || '  WHERE '
                 || NVL ( check_where_in, '1=1' )
               ,    'SELECT COUNT(*) FROM '
                 || against_this_in
                 || '  WHERE '
                 || NVL ( against_where_in, '1=1' )
               , 'Table Count Equality'
               , raise_exc_in
               );
   END;

   PROCEDURE eqquery (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
   -- User passes in two SELECT statements. Use NDS to minus them.
   --      ival PLS_INTEGER;
   BEGIN
      ieqminus ( outcome_guid_in
               ,    'Result set for "'
                 || check_this_in
                 || ' does '
                 || c_not_placeholder
                 -- ifelse (NOT l_failure, NULL, ' not ')
                 || 'match that of "'
                 || against_this_in
                 || '"'
               , check_this_in
               , against_this_in
               , 'Query Equality'
               , raise_exc_in
               );
   END;

   --Check a query against a single VARCHAR2 value
   PROCEDURE eqqueryvalue (
      outcome_guid_in    IN   VARCHAR2
    , check_query_in     IN   VARCHAR2
    , against_value_in   IN   VARCHAR2
    , null_ok_in         IN   BOOLEAN := FALSE
    , raise_exc_in       IN   BOOLEAN := FALSE
   )
   IS
      l_value VARCHAR2 ( 2000 );
      l_success BOOLEAN;

      TYPE cv_t IS REF CURSOR;

      CV cv_t;
   BEGIN
      OPEN CV FOR check_query_in;

      FETCH CV
       INTO l_value;

      CLOSE CV;

      l_success :=
            ( l_value = against_value_in )
         OR ( l_value IS NULL AND against_value_in IS NULL AND null_ok_in );
      this ( outcome_guid_in
           ,    'Query "'
             || check_query_in
             || '" returned value "'
             || l_value
             || '" that does '
             || ifelse ( l_success, NULL, ' not ' )
             || 'match "'
             || against_value_in
             || '"'
           , l_success
           , FALSE
           , raise_exc_in
           );
   END;

   PROCEDURE eqqueryvalue (
      outcome_guid_in    IN   VARCHAR2
    , check_query_in     IN   VARCHAR2
    , against_value_in   IN   DATE
    , null_ok_in         IN   BOOLEAN := FALSE
    , raise_exc_in       IN   BOOLEAN := FALSE
   )
   IS
      l_value DATE;
      l_success BOOLEAN;

      TYPE cv_t IS REF CURSOR;

      CV cv_t;
   BEGIN
      OPEN CV FOR check_query_in;

      FETCH CV
       INTO l_value;

      CLOSE CV;

      l_success :=
            ( l_value = against_value_in )
         OR ( l_value IS NULL AND against_value_in IS NULL AND null_ok_in );
      this ( outcome_guid_in
           ,    'Query "'
             || check_query_in
             || '" returned value "'
             || TO_CHAR ( l_value, 'DD-MON-YYYY HH24:MI:SS' )
             || '" that does '
             || ifelse ( l_success, NULL, ' not ' )
             || 'match "'
             || TO_CHAR ( against_value_in, 'DD-MON-YYYY HH24:MI:SS' )
             || '"'
           , l_success
           , FALSE
           , raise_exc_in
           );
   END;

   --Check a query against a single VARCHAR2 value
   PROCEDURE eqqueryvalue (
      outcome_guid_in    IN   VARCHAR2
    , check_query_in     IN   VARCHAR2
    , against_value_in   IN   NUMBER
    , null_ok_in         IN   BOOLEAN := FALSE
    , raise_exc_in       IN   BOOLEAN := FALSE
   )
   IS
      l_value NUMBER;
      l_success BOOLEAN;

      TYPE cv_t IS REF CURSOR;

      CV cv_t;
   BEGIN
      OPEN CV FOR check_query_in;

      FETCH CV
       INTO l_value;

      CLOSE CV;

      l_success :=
            ( l_value = against_value_in )
         OR ( l_value IS NULL AND against_value_in IS NULL AND null_ok_in );
      this ( outcome_guid_in
           ,    'Query "'
             || check_query_in
             || '" returned value "'
             || l_value
             || '" that does '
             || ifelse ( l_success, NULL, ' not ' )
             || 'match "'
             || against_value_in
             || '"'
           , l_success
           , FALSE
           , raise_exc_in
           );
   END;

   PROCEDURE eqfile (
      outcome_guid_in       IN   VARCHAR2
    , check_this_in         IN   VARCHAR2
    , check_this_dir_in     IN   VARCHAR2
    , against_this_in       IN   VARCHAR2
    , against_this_dir_in   IN   VARCHAR2 := NULL
    , raise_exc_in          IN   BOOLEAN := FALSE
   )
   IS
      checkid UTL_FILE.file_type;
      againstid UTL_FILE.file_type;
      samefiles BOOLEAN := TRUE;
      checkline VARCHAR2 ( 32767 );
      diffline VARCHAR2 ( 32767 );
      againstline VARCHAR2 ( 32767 );
      check_eof BOOLEAN;
      against_eof BOOLEAN;
      diffline_set BOOLEAN;
      nth_line PLS_INTEGER := 1;
      cant_open_check_file EXCEPTION;
      cant_open_against_file EXCEPTION;

      PROCEDURE cleanup (
         val               IN   BOOLEAN
       , line_in           IN   VARCHAR2 := NULL
       , line_set_in       IN   BOOLEAN := FALSE
       , linenum_in        IN   PLS_INTEGER := NULL
       , outcome_guid_in   IN   VARCHAR2
      )
      IS
      BEGIN
         UTL_FILE.fclose ( checkid );
         UTL_FILE.fclose ( againstid );
         this ( outcome_guid_in
              ,    ifelse ( line_set_in
                          , ' Line ' || linenum_in || ' of '
                          , NULL
                          )
                || 'File "'
                || file_descrip ( check_this_in, check_this_dir_in )
                || '" does '
                || ifelse ( val, NULL, ' not ' )
                || 'match "'
                || file_descrip ( against_this_in, against_this_dir_in )
                || '".'
              , val
              , FALSE
              , raise_exc_in
              );
      --             ,TRUE);
      END;
   BEGIN
      -- Compare contents of two files.
      BEGIN
         checkid :=
            UTL_FILE.fopen ( check_this_dir_in
                           , check_this_in
                           , 'R'
                           , max_linesize      => 32767
                           );
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE cant_open_check_file;
      END;

      BEGIN
         againstid :=
            UTL_FILE.fopen ( NVL ( against_this_dir_in, check_this_dir_in )
                           , against_this_in
                           , 'R'
                           , max_linesize      => 32767
                           );
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE cant_open_against_file;
      END;

      LOOP
         BEGIN
            UTL_FILE.get_line ( checkid, checkline );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               check_eof := TRUE;
         END;

         BEGIN
            UTL_FILE.get_line ( againstid, againstline );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               against_eof := TRUE;
         END;

         IF ( check_eof AND against_eof )
         THEN
            samefiles := TRUE;
            EXIT;
         ELSIF ( checkline != againstline )
         THEN
            diffline := checkline;
            diffline_set := TRUE;
            samefiles := FALSE;
            EXIT;
         ELSIF ( check_eof OR against_eof )
         THEN
            samefiles := FALSE;
            EXIT;
         END IF;

         IF samefiles
         THEN
            nth_line := nth_line + 1;
         END IF;
      END LOOP;

      cleanup ( samefiles, diffline, diffline_set, nth_line, outcome_guid_in );
   EXCEPTION
      WHEN cant_open_check_file
      THEN
         cleanup ( FALSE
                 , outcome_guid_in      =>    'Unable to open '
                                           || file_descrip ( check_this_in
                                                           , check_this_dir_in
                                                           )
                 );
      WHEN cant_open_against_file
      THEN
         cleanup ( FALSE
                 , outcome_guid_in      =>    'Unable to open '
                                           || file_descrip
                                                   ( against_this_in
                                                   , NVL
                                                        ( against_this_dir_in
                                                        , check_this_dir_in
                                                        )
                                                   )
                 );
      WHEN OTHERS
      THEN
         cleanup ( FALSE, outcome_guid_in => outcome_guid_in );
   END;

   FUNCTION numfromstr ( str IN VARCHAR2 )
      RETURN NUMBER
   IS
      sqlstr VARCHAR2 ( 1000 ) := 'begin :val := ' || str || '; end;';
      /*
      fdbk     PLS_INTEGER;
      cur      PLS_INTEGER
                          := DBMS_SQL.open_cursor;
      */
      retval NUMBER;
   BEGIN
      EXECUTE IMMEDIATE sqlstr
                  USING OUT retval;

      /*
      DBMS_SQL.parse (
         cur,
         sqlstr,
         DBMS_SQL.native
      );
      fdbk := DBMS_SQL.EXECUTE (cur);
      DBMS_SQL.variable_value (cur, 'val', retval);
      DBMS_SQL.close_cursor (cur);
      */
      RETURN retval;
   EXCEPTION
      WHEN OTHERS
      THEN
         /*
         DBMS_SQL.close_cursor (cur);
         */
         RAISE;
   END;

   PROCEDURE validatecoll (
      outcome_guid_in       IN       VARCHAR2
    , check_this_in         IN       VARCHAR2
    , against_this_in       IN       VARCHAR2
    , valid_out             IN OUT   BOOLEAN
    , msg_out               OUT      VARCHAR2
    , countproc_in          IN       VARCHAR2 := 'COUNT'
    , firstrowproc_in       IN       VARCHAR2 := 'FIRST'
    , lastrowproc_in        IN       VARCHAR2 := 'LAST'
    , check_startrow_in     IN       PLS_INTEGER := NULL
    , check_endrow_in       IN       PLS_INTEGER := NULL
    , against_startrow_in   IN       PLS_INTEGER := NULL
    , against_endrow_in     IN       PLS_INTEGER := NULL
    , match_rownum_in       IN       BOOLEAN := FALSE
    , null_ok_in            IN       BOOLEAN := TRUE
    , raise_exc_in          IN       BOOLEAN := FALSE
    , null_and_valid        IN OUT   BOOLEAN
   )
   IS
      l_check_count PLS_INTEGER;
      l_ag_count PLS_INTEGER;
   BEGIN
      valid_out := TRUE;
      null_and_valid := FALSE;
      l_check_count := numfromstr ( check_this_in || '.' || countproc_in );
      l_ag_count := numfromstr ( against_this_in || '.' || countproc_in );

      IF l_check_count = 0 AND l_ag_count = 0
      THEN
         IF NOT null_ok_in
         THEN
            valid_out := FALSE;
            msg_out := 'Invalid NULL collections';
         ELSE
            /* Empty and valid collections. We are done... */
            null_and_valid := TRUE;
         END IF;
      END IF;

      IF valid_out AND NOT null_and_valid
      THEN
         IF match_rownum_in
         THEN
            valid_out :=
               NVL ( numfromstr ( check_this_in || '.' || firstrowproc_in ) =
                        numfromstr ( against_this_in || '.' || firstrowproc_in )
                   , FALSE
                   );

            IF NOT valid_out
            THEN
               msg_out :=
                     'Different starting rows in '
                  || check_this_in
                  || ' and '
                  || against_this_in;
            ELSE
               valid_out :=
                  NVL ( numfromstr ( check_this_in || '.' || lastrowproc_in ) !=
                           numfromstr ( against_this_in || '.'
                                        || lastrowproc_in
                                      )
                      , FALSE
                      );

               IF NOT valid_out
               THEN
                  msg_out :=
                        'Different ending rows in '
                     || check_this_in
                     || ' and '
                     || against_this_in;
               END IF;
            END IF;
         END IF;

         IF valid_out
         THEN
            valid_out := NVL ( l_check_count = l_ag_count, FALSE );

            IF NOT valid_out
            THEN
               msg_out :=
                     'Different number of rows in '
                  || check_this_in
                  || ' ('
                  || TO_CHAR ( l_check_count )
                  || ') and '
                  || against_this_in
                  || ' ('
                  || TO_CHAR ( l_ag_count )
                  || ')';
            END IF;
         END IF;
      END IF;
   END;

   FUNCTION dyncollstr (
      check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
    , eqfunc_in         IN   VARCHAR2
    , countproc_in      IN   VARCHAR2
    , firstrowproc_in   IN   VARCHAR2
    , lastrowproc_in    IN   VARCHAR2
    , nextrowproc_in    IN   VARCHAR2
    , getvalfunc_in     IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      eqcheck VARCHAR2 ( 32767 );
      v_check VARCHAR2 ( 100 ) := check_this_in;
      v_against VARCHAR2 ( 100 ) := against_this_in;
      dynblock VARCHAR2 ( 32767 );
   BEGIN
       -- 1.4, Qute:
      -- If getvalfunc_in is not null, then we are using the API approach.
      -- This means that each of the programs must be prefaced by the
      -- package names, check_in and against_in.
      IF getvalfunc_in IS NOT NULL
      THEN
         v_check := v_check || '.' || getvalfunc_in;
         v_against := v_against || '.' || getvalfunc_in;
      END IF;

      IF eqfunc_in IS NULL
      THEN
         eqcheck :=
               '('
            || v_check
            || '(cindx) = '
            || v_against
            || ' (aindx)) OR '
            || '('
            || v_check
            || '(cindx) IS NULL AND '
            || v_against
            || ' (aindx) IS NULL)';
      ELSE
         eqcheck :=
            eqfunc_in || '(' || v_check || '(cindx), ' || v_against
            || '(aindx))';
      END IF;

      dynblock :=
            'DECLARE cindx PLS_INTEGER; aindx PLS_INTEGER; cend PLS_INTEGER := NVL (:cendit, '
         || check_this_in
         || '.'
         || lastrowproc_in
         || '); aend PLS_INTEGER := NVL (:aendit, '
         || against_this_in
         || '.'
         || lastrowproc_in
         || '); different_collections exception;

             PROCEDURE setfailure (
                str IN VARCHAR2,
                badc IN PLS_INTEGER, 
                bada IN PLS_INTEGER, 
                raiseexc IN BOOLEAN := TRUE)
             IS
             BEGIN
                :badcindx := badc;
                :badaindx := bada;
                :badreason := str;
                IF raiseexc THEN RAISE different_collections; END IF;
             END;
          BEGIN
             cindx := NVL (:cstartit, '
         || check_this_in
         || '.'
         || firstrowproc_in
         || ');
             aindx := NVL (:astartit, '
         || against_this_in
         || '.'
         || firstrowproc_in
         || ');

             LOOP
                IF cindx IS NULL AND aindx IS NULL 
                THEN
                   EXIT;
                   
                ELSIF cindx IS NULL and aindx IS NOT NULL
                THEN
                   setfailure (
                      ''Check index NULL, Against index NOT NULL'', cindx, aindx);
                   
                ELSIF aindx IS NULL
                THEN   
                   setfailure (
                      ''Check index NOT NULL, Against index NULL'', cindx, aindx);
                END IF;
                
                IF :matchit = ''Y''
                   AND cindx != aindx
                THEN
                   setfailure (''Mismatched row numbers'', cindx, aindx);
                END IF;

                BEGIN
                   IF '
         || eqcheck
         || '
                   THEN
                      NULL;
                   ELSE
                      setfailure (''Mismatched row values'', cindx, aindx);
                   END IF;
                EXCEPTION
                   WHEN OTHERS
                   THEN
                      setfailure (''On EQ check: '
         || eqcheck
         || ''' || '' '' || SQLERRM, cindx, aindx);
                END;
                
                cindx := '
         || check_this_in
         || '.'
         || nextrowproc_in
         || '(cindx);
                aindx := '
         || against_this_in
         || '.'
         || nextrowproc_in
         || '(aindx);
             END LOOP;
          EXCEPTION
             WHEN OTHERS THEN 
                IF :badcindx IS NULL and :badaindx IS NULL
                THEN setfailure (SQLERRM, cindx, aindx, FALSE);
                END IF;
          END;';
      RETURN minimized_whitespace ( dynblock );
   END;

   FUNCTION collection_message (
      collapi_in        IN   BOOLEAN
    , outcome_guid_in   IN   VARCHAR2
    , chkcoll_in        IN   VARCHAR2
    , chkrow_in         IN   INTEGER
    , agcoll_in         IN   VARCHAR2
    , agrow_in          IN   INTEGER
    , success_in        IN   BOOLEAN
   )
      RETURN VARCHAR2
   IS
      assert_name VARCHAR2 ( 100 ) := 'EQCOLL';
   BEGIN
      IF collapi_in
      THEN
         assert_name := 'EQCOLLAPI';
      END IF;

      RETURN    ifelse ( success_in
                       , NULL
                       ,    ' Row '
                         || NVL ( TO_CHAR ( agrow_in ), '*UNDEFINED*' )
                         || ' of '
                       )
             || 'Collection "'
             || agcoll_in
             || '" does '
             || ifelse ( success_in, NULL, ' not ' )
             || 'match '
             || ifelse ( success_in
                       , NULL
                       ,    ' Row '
                         || NVL ( TO_CHAR ( chkrow_in ), '*UNDEFINED*' )
                         || ' of '
                       )
             || chkcoll_in
             || '".';
   END;

   PROCEDURE eqcoll (
      outcome_guid_in       IN   VARCHAR2
    , check_this_in         IN   VARCHAR2
    , against_this_in       IN   VARCHAR2
    , eqfunc_in             IN   VARCHAR2 := NULL
    , check_startrow_in     IN   PLS_INTEGER := NULL
    , check_endrow_in       IN   PLS_INTEGER := NULL
    , against_startrow_in   IN   PLS_INTEGER := NULL
    , against_endrow_in     IN   PLS_INTEGER := NULL
    , match_rownum_in       IN   BOOLEAN := FALSE
    , null_ok_in            IN   BOOLEAN := TRUE
    , raise_exc_in          IN   BOOLEAN := FALSE
   )
   IS
      dynblock VARCHAR2 ( 32767 );
      v_matchrow CHAR ( 1 ) := 'N';
      valid_interim BOOLEAN;
      invalid_interim_msg VARCHAR2 ( 4000 );
      badc PLS_INTEGER;
      bada PLS_INTEGER;
      badtext VARCHAR2 ( 32767 );
      null_and_valid BOOLEAN := FALSE;
   BEGIN
      validatecoll ( outcome_guid_in
                   , check_this_in
                   , against_this_in
                   , valid_interim
                   , invalid_interim_msg
                   , 'COUNT'
                   , 'FIRST'
                   , 'LAST'
                   , check_startrow_in
                   , check_endrow_in
                   , against_startrow_in
                   , against_endrow_in
                   , match_rownum_in
                   , null_ok_in
                   , raise_exc_in
                   , null_and_valid
                   );

      IF NOT valid_interim
      THEN
         -- Failure on interim step. Flag and skip rest of processing
         this ( outcome_guid_in
              , invalid_interim_msg
              , FALSE
              , FALSE
              , raise_exc_in
              );
      ELSE
         -- We have some data to compare.
         IF NOT null_and_valid
         THEN
            IF match_rownum_in
            THEN
               v_matchrow := 'Y';
            END IF;

            dynblock :=
               dyncollstr ( check_this_in
                          , against_this_in
                          , eqfunc_in
                          , 'COUNT'
                          , 'FIRST'
                          , 'LAST'
                          , 'NEXT'
                          , getvalfunc_in      => NULL
                          );

            EXECUTE IMMEDIATE dynblock
                        USING IN     check_endrow_in
                            , IN     against_endrow_in
                            , IN OUT badc
                            , IN OUT bada
                            , IN OUT badtext
                            , IN     check_startrow_in
                            , IN     against_startrow_in
                            , IN     v_matchrow;
         END IF;

         this ( outcome_guid_in
              , collection_message ( FALSE
                                   , outcome_guid_in
                                   , check_this_in
                                   , badc
                                   , against_this_in
                                   , bada
                                   , badc IS NULL AND bada IS NULL
                                   )
              , badc IS NULL AND bada IS NULL
              , FALSE
              , raise_exc_in
              );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         report_result ( outcome_guid_in
                       , c_failure
                       , DBMS_UTILITY.format_error_stack
                       );

         IF raise_exc_in
         THEN
            RAISE PROGRAM_ERROR;
         END IF;
   /*this ( outcome_guid_in
        , collection_message ( FALSE
                             , outcome_guid_in || ' SQLERROR: '
                               || SQLERRM
                             , check_this_in
                             , badc
                             , against_this_in
                             , bada
                             , SQLCODE = 0
                             )
        , SQLCODE = 0
        , FALSE
        , raise_exc_in
        );*/
   END;

   /* API based access to collections */
   PROCEDURE eqcollapi (
      outcome_guid_in       IN   VARCHAR2
    , check_this_pkg_in     IN   VARCHAR2
    , against_this_pkg_in   IN   VARCHAR2
    , eqfunc_in             IN   VARCHAR2 := NULL
    , countfunc_in          IN   VARCHAR2 := 'COUNT'
    , firstrowfunc_in       IN   VARCHAR2 := 'FIRST'
    , lastrowfunc_in        IN   VARCHAR2 := 'LAST'
    , nextrowfunc_in        IN   VARCHAR2 := 'NEXT'
    , getvalfunc_in         IN   VARCHAR2 := 'NTHVAL'
    , check_startrow_in     IN   PLS_INTEGER := NULL
    , check_endrow_in       IN   PLS_INTEGER := NULL
    , against_startrow_in   IN   PLS_INTEGER := NULL
    , against_endrow_in     IN   PLS_INTEGER := NULL
    , match_rownum_in       IN   BOOLEAN := FALSE
    , null_ok_in            IN   BOOLEAN := TRUE
    , raise_exc_in          IN   BOOLEAN := FALSE
   )
   IS
      dynblock VARCHAR2 ( 32767 );
      v_matchrow CHAR ( 1 ) := 'N';
      badc PLS_INTEGER;
      bada PLS_INTEGER;
      badtext VARCHAR2 ( 32767 );
      valid_interim BOOLEAN;
      invalid_interim_msg VARCHAR2 ( 4000 );
      null_and_valid BOOLEAN := FALSE;
   BEGIN
      validatecoll ( outcome_guid_in
                   , check_this_pkg_in
                   , against_this_pkg_in
                   , valid_interim
                   , invalid_interim_msg
                   , countfunc_in
                   , firstrowfunc_in
                   , lastrowfunc_in
                   , check_startrow_in
                   , check_endrow_in
                   , against_startrow_in
                   , against_endrow_in
                   , match_rownum_in
                   , null_ok_in
                   , raise_exc_in
                   , null_and_valid
                   );

      IF null_and_valid
      THEN
         GOTO normal_termination;
      END IF;

      IF match_rownum_in
      THEN
         v_matchrow := 'Y';
      END IF;

      dynblock :=
         dyncollstr ( check_this_pkg_in
                    , against_this_pkg_in
                    , eqfunc_in
                    , countfunc_in
                    , firstrowfunc_in
                    , lastrowfunc_in
                    , nextrowfunc_in
                    , getvalfunc_in      => getvalfunc_in
                    );

      EXECUTE IMMEDIATE dynblock
                  USING IN     check_endrow_in
                      , IN     against_endrow_in
                      , IN OUT badc
                      , IN OUT bada
                      , IN OUT badtext
                      , IN     check_startrow_in
                      , IN     against_startrow_in
                      , IN     v_matchrow;

      <<normal_termination>>
      this ( outcome_guid_in
           , collection_message ( TRUE
                                , outcome_guid_in
                                , check_this_pkg_in
                                , badc
                                , against_this_pkg_in
                                , bada
                                , badc IS NULL AND bada IS NULL
                                )
           , bada IS NULL AND badc IS NULL
           , FALSE
           , raise_exc_in
           );
   EXCEPTION
      WHEN OTHERS
      THEN
         this ( outcome_guid_in
              , collection_message ( TRUE
                                   , outcome_guid_in || ' SQLERROR: '
                                     || SQLERRM
                                   , check_this_pkg_in
                                   , badc
                                   , against_this_pkg_in
                                   , bada
                                   , badc IS NULL AND bada IS NULL
                                   )
              , SQLCODE = 0
              , FALSE
              , raise_exc_in
              );
   END;

   PROCEDURE isnotnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
   BEGIN
      this ( outcome_guid_in
           , message_expected (  /* 'ISNOTNULL'
                                , outcome_guid_in
                                ,*/ check_this_in, 'ANYTHING BUT NULL' )
           , check_this_in IS NOT NULL
           , FALSE
           , raise_exc_in
           );
   END;

   PROCEDURE isnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
   BEGIN
      this ( outcome_guid_in
           , message_expected (                /* 'ISNULL', outcome_guid_in,*/
                                check_this_in, 'NULL' )
           , check_this_in IS NULL
           , TRUE
           , raise_exc_in
           );
   END;

   PROCEDURE isnotnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
   BEGIN
      this ( outcome_guid_in
           , message_expected ( /* 'ISNOTNULL'
                                      , outcome_guid_in
                                      ,*/ b2v ( check_this_in )
                              , 'ANYTHING BUT NULL' )
           , check_this_in IS NOT NULL
           , FALSE
           , raise_exc_in
           );
   END;

   PROCEDURE isnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
   BEGIN
      this ( outcome_guid_in
           , message_expected ( b2v ( check_this_in ), 'NULL' )
           , check_this_in IS NULL
           , TRUE
           , raise_exc_in
           );
   END;

   --Check a given call throws a named exception
   PROCEDURE raises (
      outcome_guid_in        VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   VARCHAR2
   )
   IS
      expected_indicator PLS_INTEGER := 1000;
      l_indicator PLS_INTEGER;
      v_block VARCHAR2 ( 32767 )
         :=    'BEGIN '
            || RTRIM ( RTRIM ( check_call_in ), ';' )
            || ';
               :indicator := 0;
             EXCEPTION
                WHEN '
            || against_exc_in
            || ' THEN
                   :indicator := '
            || expected_indicator
            || ';
                WHEN OTHERS THEN :indicator := SQLCODE;
             END;';
   /*
      cur                  PLS_INTEGER
                          := DBMS_SQL.open_cursor;
      ret_val              PLS_INTEGER;
   */
   BEGIN
      --Fire off the dynamic PL/SQL
      EXECUTE IMMEDIATE v_block
                  USING OUT l_indicator;

      /*
      DBMS_SQL.parse (
         cur,
         v_block,
         DBMS_SQL.native
      );
      DBMS_SQL.bind_variable (cur, 'indicator', 1);
      ret_val := DBMS_SQL.EXECUTE (cur);
      DBMS_SQL.variable_value (
         cur,
         'indicator',
         l_indicator
      );
      DBMS_SQL.close_cursor (cur);
      */
      this ( outcome_guid_in
           ,    'Block "'
             || check_call_in
             || '"'
             || ifelse ( NOT ( NVL ( l_indicator = expected_indicator, FALSE )
                             )
                       , ' does not raise'
                       , ' raises '
                       )
             || ' Exception "'
             || against_exc_in
             || ifelse ( l_indicator = expected_indicator
                       , NULL
                       , '. Instead it raises SQLCODE = ' || l_indicator
                         || '.'
                       )
           , l_indicator = expected_indicator
           );
   END;

   --Check a given call throws an exception with a given SQLCODE
   PROCEDURE raises (
      outcome_guid_in        VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   NUMBER
   )
   IS
      expected_indicator PLS_INTEGER := 1000;
      l_indicator PLS_INTEGER;
      v_block VARCHAR2 ( 32767 )
         :=    'BEGIN '
            || RTRIM ( RTRIM ( check_call_in ), ';' )
            || ';
               :indicator := 0;
             EXCEPTION
                WHEN OTHERS
                   THEN IF SQLCODE = '
            || against_exc_in
            || ' THEN :indicator := '
            || expected_indicator
            || ';'
            || ' ELSE :indicator := SQLCODE; END IF;
             END;';
   BEGIN
      --Fire off the dynamic PL/SQL
      EXECUTE IMMEDIATE v_block
                  USING OUT l_indicator;

      /*
      DBMS_SQL.parse (
         cur,
         v_block,
         DBMS_SQL.native
      );
      DBMS_SQL.bind_variable (cur, 'indicator', 1);
      ret_val := DBMS_SQL.EXECUTE (cur);
      DBMS_SQL.variable_value (
         cur,
         'indicator',
         l_indicator
      );
      DBMS_SQL.close_cursor (cur);
      */
      this ( outcome_guid_in
           ,    'Block "'
             || check_call_in
             || '"'
             || ifelse ( NOT ( NVL ( l_indicator = expected_indicator, FALSE )
                             )
                       , ' does not raise'
                       , ' raises '
                       )
             || ' Exception "'
             || against_exc_in
             || ifelse ( l_indicator = expected_indicator
                       , NULL
                       , '. Instead it raises SQLCODE = ' || l_indicator
                         || '.'
                       )
           , l_indicator = expected_indicator
           );
   END;

   PROCEDURE throws (
      outcome_guid_in        VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   VARCHAR2
   )
   IS
   BEGIN
      raises ( outcome_guid_in, check_call_in, against_exc_in );
   END;

   PROCEDURE throws (
      outcome_guid_in        VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   NUMBER
   )
   IS
   BEGIN
      raises ( outcome_guid_in, check_call_in, against_exc_in );
   END;

   -- 2.0.7
   PROCEDURE fileexists (
      outcome_guid_in   IN   VARCHAR2
    , dir_in            IN   VARCHAR2
    , file_in           IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
      checkid UTL_FILE.file_type;

      PROCEDURE cleanup ( val IN BOOLEAN, outcome_guid_in IN VARCHAR2 )
      IS
      BEGIN
         UTL_FILE.fclose ( checkid );
         this ( outcome_guid_in
              ,    'File "'
                || file_descrip ( file_in, dir_in )
                || '" could '
                || ifelse ( val, NULL, ' not ' )
                || 'be opened for reading."'
              , val
              , FALSE
              , raise_exc_in
              );
      --             ,TRUE);
      END;
   BEGIN
      checkid :=
               UTL_FILE.fopen ( dir_in, file_in, 'R', max_linesize => 32767 );
      cleanup ( TRUE, outcome_guid_in );
   EXCEPTION
      WHEN OTHERS
      THEN
         cleanup ( FALSE, outcome_guid_in );
   END;

   PROCEDURE showresults
   IS
   BEGIN
      g_showresults := TRUE;
   END;

   PROCEDURE noshowresults
   IS
   BEGIN
      g_showresults := FALSE;
   END;

   FUNCTION showing_results
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_showresults;
   END;

   FUNCTION find_obj ( check_this_in IN VARCHAR2 )
      RETURN BOOLEAN
   IS
      --      v_st VARCHAR2(20);
      --      v_err VARCHAR2(100);
      v_schema VARCHAR2 ( 100 );
      v_obj_name VARCHAR2 ( 100 );
      v_point NUMBER := INSTR ( check_this_in, '.' );
      v_state BOOLEAN := FALSE;
      v_val VARCHAR2 ( 30 );

      CURSOR c_obj
      IS
         SELECT object_name
           FROM all_objects
          WHERE object_name = UPPER ( v_obj_name )
            AND owner = UPPER ( v_schema );
   BEGIN
      IF v_point = 0
      THEN
         v_schema := USER;
         v_obj_name := check_this_in;
      ELSE
         v_schema := SUBSTR ( check_this_in, 0, (v_point - 1 ));
         v_obj_name := SUBSTR ( check_this_in, (v_point + 1 ));
      END IF;

      OPEN c_obj;

      FETCH c_obj
       INTO v_val;

      IF c_obj%FOUND
      THEN
         v_state := TRUE;
      ELSE
         v_state := FALSE;
      END IF;

      CLOSE c_obj;

      RETURN v_state;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN FALSE;
   END;

   PROCEDURE objexists (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
   BEGIN
      this2 ( outcome_guid_in
            , 'This object exists.'
            , 'This object does not exist.'
            , find_obj ( check_this_in )
            , null_ok_in
            , raise_exc_in
            );
   END;

   PROCEDURE objnotexists (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   )
   IS
   BEGIN
      this2 ( outcome_guid_in
            , 'This object does not exist.'
            , 'This object exists.'
            , NOT ( find_obj ( check_this_in ))
            , null_ok_in
            , raise_exc_in
            );
   END;

   /* END username:studious Task_id:42690*/

   /* START chrisrimmer 42694 */
   FUNCTION previous_passed
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_previous_pass;
   END;

   FUNCTION previous_failed
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN NOT g_previous_pass;
   END;

   /* END chrisrimmer 42694 */

   /* START chrisrimmer 42696 */
   PROCEDURE eqoutput (
      outcome_guid_in        IN   VARCHAR2
    , check_this_in          IN   DBMS_OUTPUT.chararr
    , against_this_in        IN   DBMS_OUTPUT.chararr
    , ignore_case_in         IN   BOOLEAN := FALSE
    , ignore_whitespace_in   IN   BOOLEAN := FALSE
    , null_ok_in             IN   BOOLEAN := TRUE
    , raise_exc_in           IN   BOOLEAN := FALSE
   )
   IS
      v_check_index BINARY_INTEGER;
      v_against_index BINARY_INTEGER;
      v_message VARCHAR2 ( 1000 );
      v_line1 VARCHAR2 ( 1000 );
      v_line2 VARCHAR2 ( 1000 );
      WHITESPACE CONSTANT CHAR ( 5 )
                   := '!' || CHR ( 9 ) || CHR ( 10 ) || CHR ( 13 )
                      || CHR ( 32 );
      nowhitespace CONSTANT CHAR ( 1 ) := '!';

      FUNCTION preview_line ( line_in VARCHAR2 )
         RETURN VARCHAR2
      IS
      BEGIN
         IF LENGTH ( line_in ) <= 100
         THEN
            RETURN line_in;
         ELSE
            RETURN SUBSTR ( line_in, 1, 97 ) || '...';
         END IF;
      END;
   BEGIN
      v_check_index := check_this_in.FIRST;
      v_against_index := against_this_in.FIRST;

      WHILE v_check_index IS NOT NULL
       AND v_against_index IS NOT NULL
       AND v_message IS NULL
      LOOP
         v_line1 := check_this_in ( v_check_index );
         v_line2 := against_this_in ( v_against_index );

         IF ignore_case_in
         THEN
            v_line1 := UPPER ( v_line1 );
            v_line2 := UPPER ( v_line2 );
         END IF;

         IF ignore_whitespace_in
         THEN
            v_line1 := TRANSLATE ( v_line1, WHITESPACE, nowhitespace );
            v_line2 := TRANSLATE ( v_line2, WHITESPACE, nowhitespace );
         END IF;

         IF ( NVL ( v_line1 <> v_line2, NOT null_ok_in ))
         THEN
            v_message :=
                  message_expected
                             (  /* 'EQOUTPUT'
                               , outcome_guid_in
                               ,*/ preview_line ( check_this_in
                                                               ( v_check_index )
                                                )
                             , preview_line ( against_this_in
                                                             ( v_against_index )
                                            )
                             )
               || ' (Comparing line '
               || v_check_index
               || ' of tested collection against line '
               || v_against_index
               || ' of reference collection)';
         END IF;

         v_check_index := check_this_in.NEXT ( v_check_index );
         v_against_index := against_this_in.NEXT ( v_against_index );
      END LOOP;

      IF v_message IS NULL
      THEN
         IF v_check_index IS NULL AND v_against_index IS NOT NULL
         THEN
            v_message :=
                  'Extra line found at end of reference collection: '
               || preview_line ( against_this_in ( v_against_index ));
         ELSIF v_check_index IS NOT NULL AND v_against_index IS NULL
         THEN
            v_message :=
                  'Extra line found at end of tested collection: '
               || preview_line ( check_this_in ( v_check_index ));
         END IF;
      END IF;

      this ( outcome_guid_in
           , NVL ( v_message, 'Collections match!' )
           , v_message IS NULL
           , FALSE
           , raise_exc_in
           );
   END;

   PROCEDURE eqoutput (
      outcome_guid_in        IN   VARCHAR2
    , check_this_in          IN   DBMS_OUTPUT.chararr
    , against_this_in        IN   VARCHAR2
    , line_delimiter_in      IN   CHAR := NULL
    , ignore_case_in         IN   BOOLEAN := FALSE
    , ignore_whitespace_in   IN   BOOLEAN := FALSE
    , null_ok_in             IN   BOOLEAN := TRUE
    , raise_exc_in           IN   BOOLEAN := FALSE
   )
   IS
      l_buffer DBMS_OUTPUT.chararr;
      l_against_this VARCHAR2 ( 2000 ) := against_this_in;
      l_delimiter_pos BINARY_INTEGER;
   BEGIN
      IF line_delimiter_in IS NULL
      THEN
         l_against_this :=
               REPLACE ( l_against_this, CHR ( 13 ) || CHR ( 10 )
                       , CHR ( 10 ));
      END IF;

      WHILE l_against_this IS NOT NULL
      LOOP
         l_delimiter_pos :=
                INSTR ( l_against_this, NVL ( line_delimiter_in, CHR ( 10 )));

         IF l_delimiter_pos = 0
         THEN
            l_buffer ( l_buffer.COUNT ) := l_against_this;
            l_against_this := NULL;
         ELSE
            l_buffer ( l_buffer.COUNT ) :=
                            SUBSTR ( l_against_this, 1, l_delimiter_pos - 1 );
            l_against_this := SUBSTR ( l_against_this, l_delimiter_pos + 1 );

            --Handle Case of delimiter at end
            IF l_against_this IS NULL
            THEN
               l_buffer ( l_buffer.COUNT ) := NULL;
            END IF;
         END IF;
      END LOOP;

      eqoutput ( outcome_guid_in
               , check_this_in
               , l_buffer
               , ignore_case_in
               , ignore_whitespace_in
               , null_ok_in
               , raise_exc_in
               );
   END;
/* END chrisrimmer 42696 */

/* NOT AVAILABLE
PROCEDURE eq_refc_table (
   p_msg_nm IN VARCHAR2,
   proc_name IN VARCHAR2,
   params IN utplsql_util.utplsql_params,
   cursor_position IN PLS_INTEGER,
   table_name IN VARCHAR2
)
IS
   refc_table_name   VARCHAR2 (50);
BEGIN
   refc_table_name :=
      utplsql_util.prepare_and_fetch_rc (proc_name,
                                         params,
                                         cursor_position,
                                         1,
                                         table_name
                                        );

   IF (refc_table_name IS NOT NULL)
   THEN

      --eqtable(p_msg_nm,'UTPLSQL.'||refc_table_name,table_name);
      eqtable ( p_msg_nm, refc_table_name, table_name);
   END IF;


   utplsql_util.execute_ddl ('DROP TABLE ' || refc_table_name);
END;

PROCEDURE eq_refc_query (
   p_msg_nm IN VARCHAR2,
   proc_name IN VARCHAR2,
   params IN utplsql_util.utplsql_params,
   cursor_position IN PLS_INTEGER,
   qry IN VARCHAR2
)
IS
   refc_table_name   VARCHAR2 (50);
BEGIN
   refc_table_name :=
      utplsql_util.prepare_and_fetch_rc (proc_name,
                                         params,
                                         cursor_position,
                                         2,
                                         qry
                                        );

   IF (refc_table_name IS NOT NULL)
   THEN
      --eqquery(p_msg_nm,'select * from '||'UTPLSQL.'||refc_table_name,qry);
      eqquery (
                         p_msg_nm,
                         'select * from ' || refc_table_name,
                         qry
                        );
   END IF;


   EXECUTE IMMEDIATE 'DROP TABLE ' || refc_table_name;
END; */
END qu_assert;
/
