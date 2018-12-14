CREATE OR REPLACE PACKAGE PLVprs
/*----------------------------------------------------------------
||                  PL/Vision Professional
||----------------------------------------------------------------
||    File: plvprs.sps
||  Author: Steven Feuerstein
|| Copyright (C) 1996-2002 Quest Software
|| All rights reserved.
******************************************************************/
IS
   c_ignore_case      CONSTANT VARCHAR2 (1)  := 'I';
   c_respect_case     CONSTANT VARCHAR2 (1)  := 'R';
   c_all              CONSTANT VARCHAR (3)   := 'ALL';
   c_word             CONSTANT VARCHAR (4)   := 'WORD';
   c_delim            CONSTANT VARCHAR (5)   := 'DELIM';

   TYPE vc2000_t IS TABLE OF VARCHAR2 (2000)
      INDEX BY BINARY_INTEGER;

   SUBTYPE maxvc2_t IS VARCHAR2 (32767);
   SUBTYPE identifier_t IS VARCHAR2 (30);

   /*
   || The standard list of delimiters. You can over-ride these with
   || your own list when you call the procedures and functions below.
   || This list is a pretty standard set of delimiters, though.
   */
   std_delimiters     CONSTANT VARCHAR2 (50)
           := '!@#$%^&*()-_=+\|`~{[]};:''",<.>/?' || CHR (10) || CHR (9)
              || ' ';
   plsql_delimiters   CONSTANT VARCHAR2 (50)
              := '!@%^&*()-=+\|`~{[]};:''",<.>/?' || CHR (10) || CHR (9)
                 || ' ';
   sql_delimiters     CONSTANT VARCHAR2 (3)  := '$_#';

   FUNCTION next_atom_loc (
      string_in       IN   VARCHAR2
     ,start_loc_in    IN   NUMBER
     ,direction_in    IN   NUMBER := +1
     ,delimiters_in   IN   VARCHAR2 := std_delimiters
   )
      RETURN INTEGER;

   PROCEDURE STRING (
      string_in          IN       VARCHAR2
     ,atomics_list_out   IN OUT   vc2000_t
     ,num_atomics_out    IN OUT   NUMBER
     ,delimiters_in      IN       VARCHAR2 := std_delimiters
     ,
      /* CWS start */
      type_in            IN       VARCHAR2 := c_all
     /* CWS end   */
   ,  one_delimiter_in   IN       BOOLEAN := FALSE
   );

   PROCEDURE STRING (
      string_in          IN       VARCHAR2
     ,atomics_list_out   IN OUT   VARCHAR2
     ,num_atomics_out    IN OUT   NUMBER
     ,delimiters_in      IN       VARCHAR2 := std_delimiters
     ,
      /* CWS start */
      type_in            IN       VARCHAR2 := c_all
     ,one_delimiter_in   IN       BOOLEAN := FALSE
   );

   /* Count the number of atomics in a string */
   FUNCTION numatomics (
      string_in       IN   VARCHAR2
     ,count_type_in   IN   VARCHAR2 := c_all
     ,delimiters_in   IN   VARCHAR2 := std_delimiters
   )
      RETURN INTEGER;

   /* Return the Nth atomic in the string */
   FUNCTION nth_atomic (
      string_in       IN   VARCHAR2
     ,nth_in          IN   NUMBER
     ,count_type_in   IN   VARCHAR2 := c_all
     ,delimiters_in   IN   VARCHAR2 := std_delimiters
     ,start_in        IN   INTEGER := 1
   )
      RETURN VARCHAR2;

   FUNCTION numinstr (
      string_in        IN   VARCHAR2
     ,substring_in     IN   VARCHAR2
     ,ignore_case_in   IN   VARCHAR2 := c_ignore_case
   )
      RETURN INTEGER;

   PROCEDURE wrap (
      text_in         IN       VARCHAR2
     ,line_length     IN       INTEGER
     ,paragraph_out   IN OUT   vc2000_t
     ,num_lines_out   IN OUT   INTEGER
     ,use_newlines    IN       BOOLEAN := FALSE
     ,delimiters_in   IN       VARCHAR2 := std_delimiters
   );

   FUNCTION wrapped_string (
      text_in         IN   VARCHAR2
     ,line_length     IN   INTEGER := 80
     ,use_newlines    IN   BOOLEAN := FALSE
     ,delimiters_in   IN   VARCHAR2 := std_delimiters
   )
      RETURN VARCHAR2;

   PROCEDURE display_wrap (
      text_in         IN   VARCHAR2
     ,line_length     IN   INTEGER := 80
     ,prefix_in       IN   VARCHAR2 := NULL
     ,use_newlines    IN   BOOLEAN := FALSE
     ,delimiters_in   IN   VARCHAR2 := std_delimiters
   );
END PLVprs;
/