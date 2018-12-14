CREATE OR REPLACE PACKAGE chars
IS
   PROCEDURE clear_set;

   PROCEDURE add_printable (
      start_in   IN   PLS_INTEGER
    , end_in     IN   PLS_INTEGER DEFAULT NULL
   );

   PROCEDURE add_non_printable (
      start_in   IN   PLS_INTEGER
    , end_in     IN   PLS_INTEGER DEFAULT NULL
   );

   PROCEDURE set_name (
      position_in      IN   PLS_INTEGER
    , NAME_IN          IN   VARCHAR2
    , description_in   IN   VARCHAR2
   );

   PROCEDURE use_ascii_set;

   PROCEDURE display (
      string_in        IN   VARCHAR2
    , preserve_nl_in   IN   BOOLEAN DEFAULT TRUE
   );
END chars;
/
