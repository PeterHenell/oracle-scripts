CREATE OR REPLACE PACKAGE layer_validator
/*
   Overview: validate calls between layers of code.
   Author: Steven Feuerstein
   Started in: Vilnius in March 2007

   User sets up a collection of collections, each of which holds the
   patterns valid at that layer in the hierarchy.

   The program then makes sure that no program matching a pattern in level N
   calls a program matching a pattern in level N+M where M >= 1.
*/
IS
   SUBTYPE pattern_t IS VARCHAR2 (100);

   TYPE patterns_aat IS TABLE OF pattern_t
      INDEX BY PLS_INTEGER;

   TYPE layer_patterns_aat IS TABLE OF patterns_aat
      INDEX BY PLS_INTEGER;

   PROCEDURE set_trace (on_in IN BOOLEAN DEFAULT TRUE);

   PROCEDURE validate_program (
      schema_in IN VARCHAR2
    , program_in IN VARCHAR2
    , layer_patterns_in IN layer_patterns_aat
    , only_show_matches_in IN BOOLEAN DEFAULT FALSE
   );

   PROCEDURE validate_schema (
      schema_in IN VARCHAR2
    , layer_patterns_in IN layer_patterns_aat
   );
END layer_validator;
/