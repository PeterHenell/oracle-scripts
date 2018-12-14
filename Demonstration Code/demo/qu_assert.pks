CREATE OR REPLACE PACKAGE qu_assert AUTHID CURRENT_USER
IS
   /*
   Convert to Qute version of package with minimal UT dependencies.
   Add several other assertions.
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
   $Log: ut_assert2.pks,v $
   Revision 1.3  2004/11/16 09:46:48  chrisrimmer
   Changed to new version detection system.

   Revision 1.2  2003/07/01 19:36:46  chrisrimmer
   Added Standard Headers

   ************************************************************************/
   test_failure EXCEPTION;
   /* On Error behaviors */
   c_continue CONSTANT CHAR ( 1 ) := 'c';
   c_stop CONSTANT CHAR ( 1 ) := 's';
   --
   c_success CONSTANT VARCHAR2 ( 32767 ) := 'SUCCESS';
   c_failure CONSTANT VARCHAR2 ( 32767 ) := 'FAILURE';
   --
   c_def_rc_ot_suffix CONSTANT VARCHAR2 ( 20 ) := '_qot';
   c_def_rc_nt_suffix CONSTANT VARCHAR2 ( 20 ) := '_qnt';
   c_def_rc_pkg_suffix CONSTANT VARCHAR2 ( 20 ) := '_qtp';
   --
   c_output_prefix constant varchar2(20) := 'QUTE>';

   TYPE weak_ref_cursor IS REF CURSOR;

   TYPE value_name_rt IS RECORD (
      VALUE VARCHAR2 ( 32767 )
    , NAME VARCHAR2 ( 100 )
   );

   TYPE value_name_tt IS TABLE OF value_name_rt
      INDEX BY BINARY_INTEGER;

   FUNCTION current_harness_guid
      RETURN VARCHAR2;

   PROCEDURE set_current_harness_info (
      run_harness_id_in     IN   VARCHAR2
    , dbms_output_only_in   IN   BOOLEAN
   );

   FUNCTION dbms_output_only
      RETURN BOOLEAN;

   FUNCTION minimized_whitespace ( string_in IN VARCHAR2 )
      RETURN VARCHAR2;

   PROCEDURE report_result (
      result_guid_in   IN   VARCHAR2
    , status_in        IN   VARCHAR2
    , description_in   IN   VARCHAR2
   );

   PROCEDURE this (
      outcome_guid_in   IN   VARCHAR2
    , msg_in            IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   PROCEDURE eval (
      outcome_guid_in   IN   VARCHAR2
    , using_in          IN   VARCHAR2
    , value_name_in     IN   value_name_tt
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   NUMBER
    , against_this_in   IN   NUMBER
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , against_this_in   IN   BOOLEAN
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   DATE
    , against_this_in   IN   DATE
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   TIMESTAMP
    , against_this_in   IN   TIMESTAMP
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   TIMESTAMP WITH TIME ZONE
    , against_this_in   IN   TIMESTAMP WITH TIME ZONE
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   TIMESTAMP WITH LOCAL TIME ZONE
    , against_this_in   IN   TIMESTAMP WITH LOCAL TIME ZONE
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   INTERVAL DAY TO SECOND
    , against_this_in   IN   INTERVAL DAY TO SECOND
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE compare_two_values (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   INTERVAL YEAR TO MONTH
    , against_this_in   IN   INTERVAL YEAR TO MONTH
    , operator_in       IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
    , truncate_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE eqtable (
      outcome_guid_in    IN   VARCHAR2
    , check_this_in      IN   VARCHAR2
    , against_this_in    IN   VARCHAR2
    , check_where_in     IN   VARCHAR2 := NULL
    , against_where_in   IN   VARCHAR2 := NULL
    , raise_exc_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE eqtabcount (
      outcome_guid_in    IN   VARCHAR2
    , check_this_in      IN   VARCHAR2
    , against_this_in    IN   VARCHAR2
    , check_where_in     IN   VARCHAR2 := NULL
    , against_where_in   IN   VARCHAR2 := NULL
    , raise_exc_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE eqquery (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   --Check a query against a single VARCHAR2 value
   PROCEDURE eqqueryvalue (
      outcome_guid_in    IN   VARCHAR2
    , check_query_in     IN   VARCHAR2
    , against_value_in   IN   VARCHAR2
    , null_ok_in         IN   BOOLEAN := FALSE
    , raise_exc_in       IN   BOOLEAN := FALSE
   );

   -- Check a query against a single DATE value
   PROCEDURE eqqueryvalue (
      outcome_guid_in    IN   VARCHAR2
    , check_query_in     IN   VARCHAR2
    , against_value_in   IN   DATE
    , null_ok_in         IN   BOOLEAN := FALSE
    , raise_exc_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE eqqueryvalue (
      outcome_guid_in    IN   VARCHAR2
    , check_query_in     IN   VARCHAR2
    , against_value_in   IN   NUMBER
    , null_ok_in         IN   BOOLEAN := FALSE
    , raise_exc_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE eqfile (
      outcome_guid_in       IN   VARCHAR2
    , check_this_in         IN   VARCHAR2
    , check_this_dir_in     IN   VARCHAR2
    , against_this_in       IN   VARCHAR2
    , against_this_dir_in   IN   VARCHAR2 := NULL
    , raise_exc_in          IN   BOOLEAN := FALSE
   );

   /* Direct access to collections */
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
   );

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
   );

   PROCEDURE isnotnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   PROCEDURE isnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   -- 1.5.2
   PROCEDURE isnotnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   PROCEDURE isnull (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   BOOLEAN
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   --Check a given call throws a named exception
   PROCEDURE throws (
      outcome_guid_in   IN   VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   VARCHAR2
   );

   --Check a given call throws an exception with a given SQLCODE
   PROCEDURE throws (
      outcome_guid_in        VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   NUMBER
   );

   --Check a given call throws a named exception
   PROCEDURE raises (
      outcome_guid_in   IN   VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   VARCHAR2
   );

   --Check a given call throws an exception with a given SQLCODE
   PROCEDURE raises (
      outcome_guid_in        VARCHAR2
    , check_call_in     IN   VARCHAR2
    , against_exc_in    IN   NUMBER
   );

   PROCEDURE showresults;

   PROCEDURE noshowresults;

   FUNCTION showing_results
      RETURN BOOLEAN;

   -- 2.0.7
   PROCEDURE fileexists (
      outcome_guid_in   IN   VARCHAR2
    , dir_in            IN   VARCHAR2
    , file_in           IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   /* START username:studious Date:01/11/2002 Task_id:42690
   Description: Checking object exist */
   PROCEDURE objexists (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   PROCEDURE objnotexists (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   VARCHAR2
    , null_ok_in        IN   BOOLEAN := FALSE
    , raise_exc_in      IN   BOOLEAN := FALSE
   );

   /* END username:studious Task_id:42690*/

   /* START chrisrimmer 42694 */
   FUNCTION previous_passed
      RETURN BOOLEAN;

   FUNCTION previous_failed
      RETURN BOOLEAN;

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
   );

   PROCEDURE eqoutput (
      outcome_guid_in        IN   VARCHAR2
    , check_this_in          IN   DBMS_OUTPUT.chararr
    , against_this_in        IN   VARCHAR2
    , line_delimiter_in      IN   CHAR := NULL
    , ignore_case_in         IN   BOOLEAN := FALSE
    , ignore_whitespace_in   IN   BOOLEAN := FALSE
    , null_ok_in             IN   BOOLEAN := TRUE
    , raise_exc_in           IN   BOOLEAN := FALSE
   );

   FUNCTION message_expected (
      check_this_in     IN   VARCHAR2
    , against_this_in   IN   VARCHAR2
   )
      RETURN VARCHAR2;
/* END chrisrimmer 42696 */

/*
   -- Ref cursor assertions completely redone for Qute.
   -- These are used only for *weak* ref cursor analysis.
   PROCEDURE eq_refc_table (
      outcome_guid_in    IN   VARCHAR2
    , check_this_in      IN   weak_ref_cursor
    , against_this_in    IN   VARCHAR2
    , against_where_in   IN   VARCHAR2 := NULL
    , raise_exc_in       IN   BOOLEAN := FALSE
   );

   PROCEDURE eq_refc_query (
      outcome_guid_in   IN   VARCHAR2
    , check_this_in     IN   weak_ref_cursor
    , against_this_in   IN   VARCHAR2
    , raise_exc_in      IN   BOOLEAN := FALSE
   );
*/
END qu_assert;
/
