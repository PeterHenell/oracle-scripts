CREATE OR REPLACE PACKAGE package_analyzer
/*================================================
|| Name: package_analyzer
||   V1
||   Copyright PL/Solutions 2005
|| Author: SF
|| Contact info: info@oracleplsqlprogramming.com
||
|| Overview: Provide several programs to analyze
||           the contents of a package.
||
|| Modification history:
||    WHEN         WHO    WHAT
||  March 5, 2005  SF     Created the package
||
|| Dependencies:
||    program_start_end table:
||
   CREATE TABLE program_start_end (
      owner VARCHAR2(100),
      PACKAGE_name VARCHAR2(100),
      program_name VARCHAR2(100),
      start_line INTEGER,
      end_line INTEGER);
||
|| Exceptions raised:
||
================================================*/
IS
   c_package_name   CONSTANT VARCHAR2 (30) := 'package_analyzer';

   -- Public data structures; avoid assigning default values here.
   -- Instead, assign in initialization and verify success in the
   -- verification program.

   -- Public programs
   FUNCTION program_type (
      owner_in     IN   VARCHAR2
    , package_in   IN   VARCHAR2
    , program_in   IN   VARCHAR2
   )
      RETURN VARCHAR2;

/*
   Name: set_program_start_ends

   Overview: analyzes the specified package body to determine the lines on which
             each program in the package (those listed in ALL_PROCEDURES) starts
             and ends. You will find this program handy for translating the contents
          of the DBMS_UTILITY.FORMAT_CALL_STACK so that you can go from a line
          number to the name of the program that was called.

   Assumptions: you must add the name of the program after the END statement, so
             we can figure out where the program ends. And there must be no
             comments or extra whitespace around the program name as in:

    PROCEDURE XYZ - OK
    PROCEDURE
        XYZ - NOT OK
    FUNCTION XYZ-- no space after - NOT OK

   Author: Steven Feuerstein, info@oracleplsqlprogramming.com

   Dependencies: this table must be defined:
   
   CREATE TABLE program_start_end (
      owner VARCHAR2(100),
      PACKAGE_name VARCHAR2(100),
      program_name VARCHAR2(100),
      start_line INTEGER,
      end_line INTEGER);
   
*/
   PROCEDURE set_program_start_ends (
      package_in   IN   VARCHAR2
    , owner_in     IN   VARCHAR DEFAULT NULL
   );

/*
   Name: program_from_line

   Overview: return the name of the program from its package name and line number.

   Assumptions: For this program to work, you must already have called
                set_program_start_ends for this package.
*/
   FUNCTION program_from_line (
      owner_in     IN   VARCHAR2
    , package_in   IN   VARCHAR2
    , line_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2;
END package_analyzer;
/