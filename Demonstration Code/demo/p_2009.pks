CREATE OR REPLACE PACKAGE p
/*----------------------------------------------------------------
|| Author: Steven Feuerstein
||
|| The p package is my "replacement" for DBMS_OUTPUT.PUT_LINE.
||
|| Key advantages: lots of overloadings to support combinations
||                 of datatypes and types not supported at all by
||                 the built-in. Also, you only have to type 3
||                 characters to command "show me".
-----------------------------------------------------------------*/

/*

Updated October 2009 in response to various recommendations from
readers. Key changes:

- Got rid of turn_on/turn_off and the show_in parameter. This is
now a simpler layer of code on top of DBMS_OUTPUT.PUT_LINE. If
server output is enabled, you see the output, else it is ignored.
Just like DBMS_OUTPUT.

- Refactored overloadings so that you never need to use named
notation to call p.l

- No more prefix. You should SET SERVEROUTPUT ON FORMAT WRAPPED
if you don't want to lose leading blanks.

- Set the date format mask once, per session, via a program call,
rather than by passing it in the parameter list (which complicates
the overloadings).

- Allow user to set string to be shown in place of NULL.

*/

IS
   SUBTYPE format_mask_t IS VARCHAR2 (100);
   SUBTYPE maxvarchar2_t is varchar2(32767);

   c_line_length   CONSTANT PLS_INTEGER := 80;
   c_dt_format   CONSTANT format_mask_t := 'YYYY-MM-DD HH24:MI:SS';
   c_ts_format     CONSTANT format_mask_t := 'YYYY-MM-DD HH24:MI:SS.XXX';
   c_null_string   CONSTANT VARCHAR2 (8) := '{null}';

   /* Set line length before wrap */
   PROCEDURE set_line_length (length_in IN PLS_INTEGER := c_line_length);

   FUNCTION line_length
      RETURN PLS_INTEGER;

   /* Set format masks. */
   PROCEDURE set_dt_format (format_in IN VARCHAR2);

   PROCEDURE set_ts_format (format_in IN VARCHAR2);

   /* Set string for NULL */
   PROCEDURE set_null_string (string_in IN VARCHAR2);

   /* The overloaded versions of the p.l procedure */

   PROCEDURE l (date_in IN DATE);

   PROCEDURE l (timestamp_in IN TIMESTAMP);

   PROCEDURE l (number_in IN NUMBER);

   PROCEDURE l (string_in IN VARCHAR2);

   PROCEDURE l (boolean_in IN BOOLEAN);
   
   PROCEDURE l (clob_in IN CLOB);

   PROCEDURE l (xml_in IN XMLTYPE);

   /* String first, then another datatype. Useful when you want to show
      a label and then a value. */
   PROCEDURE l (string_in IN VARCHAR2, number_in IN NUMBER);

   PROCEDURE l (string_in IN VARCHAR2, date_in IN DATE);

   PROCEDURE l (string_in IN VARCHAR2, timestamp_in IN TIMESTAMP);

   PROCEDURE l (string_in IN VARCHAR2, boolean_in IN BOOLEAN);

   /* Two of the same datatype and that's enough! */
   PROCEDURE l (string1_in IN VARCHAR2, string2_in IN VARCHAR2);

   PROCEDURE l (number1_in IN NUMBER, number2_in IN NUMBER);

   PROCEDURE l (boolean1_in IN BOOLEAN, boolean_2in IN BOOLEAN);

   PROCEDURE l (date1_in IN DATE, date2_in IN DATE);

   PROCEDURE l (timestamp1_in IN TIMESTAMP, timestamp2_in IN TIMESTAMP);
END p;
/