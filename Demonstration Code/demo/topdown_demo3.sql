/*
Demonstration of the TopDown package and automated refactoring:

Here is another example of how I would today go about building the
"intab" procedure, which uses dynamic SQL method 4 to provide
"SELECT * FROM table" functionality from within PL/SQL (that is,
display the contents of the table. 

It is going to be a long complex program, so I start with a very
high level description of what I will be doing:
*/

CREATE OR REPLACE PROCEDURE intab (
   owner_in IN VARCHAR2, table_in IN VARCHAR2)
IS
--topdown.ish
BEGIN
   topdown.pph ('load_column_information');
   topdown.pph ('construct_and_parse_query');
   topdown.pph ('define_columns_and_execute');
   topdown.pph ('build_and_display_output');
   topdown.pph ('cleanup');
END intab;
/

BEGIN
   topdown.refactor (USER, 'INTAB');
END;
/

/* And now I have... */

CREATE OR REPLACE PROCEDURE intab (owner_in IN VARCHAR2, table_in IN VARCHAR2)
IS
   PROCEDURE load_column_information
   IS
   BEGIN
      topdown.tbc ('load_column_information');
   END load_column_information;

   PROCEDURE construct_and_parse_query
   IS
   BEGIN
      topdown.tbc ('construct_and_parse_query');
   END construct_and_parse_query;

   PROCEDURE define_columns_and_execute
   IS
   BEGIN
      topdown.tbc ('define_columns_and_execute');
   END define_columns_and_execute;

   PROCEDURE build_and_display_output
   IS
   BEGIN
      topdown.tbc ('build_and_display_output');
   END build_and_display_output;

   PROCEDURE cleanup
   IS
   BEGIN
      topdown.tbc ('cleanup');
   END cleanup;
BEGIN
   load_column_information ();
   construct_and_parse_query ();
   define_columns_and_execute ();
   build_and_display_output ();
   cleanup ();
END intab;
/