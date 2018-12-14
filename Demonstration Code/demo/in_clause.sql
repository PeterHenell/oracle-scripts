DROP TABLE otn_question
/
CREATE TABLE otn_question (
   ID INTEGER,
   title VARCHAR2(100),
   description VARCHAR2(2000))
/

BEGIN
   INSERT INTO otn_question
        VALUES ( 1, 'How do I write a loop?'
               , 'What are the different ways I can write a loop in PL/SQL' );

   INSERT INTO otn_question
        VALUES ( 2, 'Use cursor FOR loop?'
               , 'Is there a reason any longer to use a cursor FOR loop, since I can now use BULK COLLECT?' );

   INSERT INTO otn_question
        VALUES ( 3, 'Which version of PL/SQL is best?'
               , 'What is the best version of PL/SQL?' );

   FOR indx IN 1 .. 10000
   LOOP
      INSERT INTO otn_question
           VALUES ( indx + 3, 'Title ' || indx, 'Description ' || indx );
   END LOOP;

   COMMIT;
END;
/

REM Copy of relational table as an object type, used in nested table defintion

DROP TYPE otn_question_ot FORCE
/
DROP TYPE otn_question_nt FORCE
/
DROP TYPE pky_nt FORCE
/

CREATE TYPE otn_question_ot AS OBJECT (
   ID INTEGER
 , title VARCHAR2 ( 100 )
 , description VARCHAR2 ( 2000 )
)
/

CREATE OR REPLACE TYPE otn_question_nt IS TABLE OF otn_question_ot;
/

CREATE OR REPLACE TYPE pky_nt IS TABLE OF INTEGER;
/

CREATE OR REPLACE PACKAGE in_clause
/*
| Demonstrate various ways to implement a dynamic IN clause
|
|    Author: Steven Feuerstein, steven@stevenfeuerstein.com
|    Copyright 2005
|
| Run the in_clause_setup.sql script to set up the
| necessary database objects.
*/
IS
   -- Returns a cursor variable based on the Oracle9iR2-defined
   -- weak ref cursor type.
   FUNCTION nds_list ( list_in IN VARCHAR2 )
      RETURN sys_refcursor;

   FUNCTION dbms_sql_list ( list_in IN VARCHAR2 )
      RETURN otn_question_nt;

   FUNCTION nested_table_list ( list_in IN pky_nt )
      RETURN sys_refcursor;

   FUNCTION member_of_list ( list_in IN pky_nt )
      RETURN sys_refcursor;

   PROCEDURE test_varieties (
      iterations_in   IN   PLS_INTEGER DEFAULT 1
    , list_in         IN   VARCHAR2 DEFAULT '1,3'
   );
END in_clause;
/

CREATE OR REPLACE PACKAGE BODY in_clause
/*
| Demonstrate various ways to implement a dynamic IN clause
|
|    Author: Steven Feuerstein, steven@stevenfeuerstein.com
|    Copyright 2005
|
| Run the in_clause_setup.sql script to set up the
| necessary database objects.
*/
IS
   FUNCTION nds_list ( list_in IN VARCHAR2 )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR    'SELECT * FROM otn_question WHERE id IN ('
                      || list_in
                      || ')';

      RETURN retval;
   END nds_list;

   PROCEDURE string_to_list (
      str          IN       VARCHAR2
    , list_inout   IN OUT   pky_nt
    , delim        IN       VARCHAR2 DEFAULT ','
   )
   IS
      l_loc PLS_INTEGER := 1;
      l_startloc PLS_INTEGER := 1;
   BEGIN
      WHILE ( l_loc <> 0 AND l_loc IS NOT NULL )
      LOOP
         l_loc := INSTR ( str, delim, l_startloc );

         IF l_loc = l_startloc
         THEN
            -- Two consecutive delimiters
            list_inout.EXTEND;
            list_inout ( list_inout.LAST ) := NULL;
         ELSIF l_loc = 0
         THEN
            -- No more delimiters, get to end of string
            list_inout.EXTEND;
            list_inout ( list_inout.LAST ) := SUBSTR ( str, l_startloc );
         ELSIF l_loc IS NOT NULL
         THEN
            -- Extract next item
            list_inout.EXTEND;
            list_inout ( list_inout.LAST ) :=
                                 SUBSTR ( str, l_startloc, l_loc - l_startloc );
         END IF;

         l_startloc := l_loc + 1;
      END LOOP;
   END string_to_list;

   FUNCTION dbms_sql_list ( list_in IN VARCHAR2 )
      RETURN otn_question_nt
   IS
      l_query VARCHAR2 ( 32767 ) := 'SELECT * FROM otn_question WHERE id IN (';
      l_cur PLS_INTEGER := DBMS_SQL.open_cursor;
      l_feedback PLS_INTEGER;
      l_ids pky_nt := pky_nt ( );
      l_row PLS_INTEGER;
      l_onerow otn_question%ROWTYPE;
      retval otn_question_nt := otn_question_nt ( );
   BEGIN
      -- Parse the delimited list to the collection.
      string_to_list ( list_in, l_ids );

      -- Build the list of bind variables.
      FOR l_row IN 1 .. l_ids.COUNT
      LOOP
         l_query := l_query || ':bv' || l_row || ',';
      END LOOP;

      l_query := RTRIM ( l_query, ',' ) || ')';
      -- Define the columns to be queried.
      DBMS_SQL.parse ( l_cur, l_query, DBMS_SQL.native );
      DBMS_SQL.define_column ( l_cur, 1, 1 );
      DBMS_SQL.define_column ( l_cur, 2, 'a', 100 );
      DBMS_SQL.define_column ( l_cur, 3, 'a', 2000 );

      -- Bind each variable in the provided list.
      FOR l_row IN 1 .. l_ids.COUNT
      LOOP
         DBMS_SQL.bind_variable ( l_cur, ':bv' || l_row, l_ids ( l_row ));
      END LOOP;

      -- Execute and then fetch each row.
      l_feedback := DBMS_SQL.EXECUTE ( l_cur );

      LOOP
         l_feedback := DBMS_SQL.fetch_rows ( l_cur );
         EXIT WHEN l_feedback = 0;
         -- Retrieve individual column values and move them to the nested table.
         DBMS_SQL.COLUMN_VALUE ( l_cur, 1, l_onerow.ID );
         DBMS_SQL.COLUMN_VALUE ( l_cur, 2, l_onerow.title );
         DBMS_SQL.COLUMN_VALUE ( l_cur, 3, l_onerow.description );
         retval.EXTEND;
         retval ( retval.LAST ) :=
            otn_question_ot ( l_onerow.ID, l_onerow.title
                            , l_onerow.description );
      END LOOP;

      DBMS_SQL.close_cursor ( l_cur );
      RETURN retval;
   END dbms_sql_list;

   FUNCTION nested_table_list ( list_in IN pky_nt )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT otn_question.*
           FROM otn_question
              , ( SELECT COLUMN_VALUE
                   FROM TABLE ( list_in ))
          WHERE otn_question.ID = COLUMN_VALUE;

      RETURN retval;
   END nested_table_list;

   FUNCTION member_of_list ( list_in IN pky_nt )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT *
           FROM otn_question
           WHERE ID MEMBER OF list_in;

      RETURN retval;
   END member_of_list;

   PROCEDURE test_varieties (
      iterations_in   IN   PLS_INTEGER DEFAULT 1
    , list_in         IN   VARCHAR2 DEFAULT '1,3'
   )
   IS
      l_start_time PLS_INTEGER;

      PROCEDURE show_elapsed_time
      IS
      BEGIN
         DBMS_OUTPUT.put_line (    '  Elapsed CPU time: '
                                || TO_CHAR (   DBMS_UTILITY.get_cpu_time
                                             - l_start_time
                                           )
                              );
      END show_elapsed_time;

      PROCEDURE start_timing ( str_in IN VARCHAR2 )
      IS
      BEGIN
         l_start_time := DBMS_UTILITY.get_cpu_time;
         DBMS_OUTPUT.put_line ( str_in );
      END start_timing;

      PROCEDURE test_nds_list
      IS
         l_cv sys_refcursor;
         l_one otn_question%ROWTYPE;
      BEGIN
         start_timing ( 'Output from NDS_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := nds_list ( list_in );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         show_elapsed_time;
      END test_nds_list;

      PROCEDURE test_dbms_sql_list
      IS
         l_array otn_question_nt;
         l_row PLS_INTEGER;
      BEGIN
         start_timing ( 'Output from DBMS_SQL_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_array := dbms_sql_list ( list_in );
            l_row := l_array.FIRST;

            WHILE ( l_row IS NOT NULL )
            LOOP
               l_row := l_array.NEXT ( l_row );
            END LOOP;
         END LOOP;

         show_elapsed_time;
      END test_dbms_sql_list;

      PROCEDURE test_nested_table_list
      IS
         l_list pky_nt := pky_nt ( 1, 3 );
         l_cv sys_refcursor;
         l_one otn_question%ROWTYPE;
      BEGIN
         start_timing ( 'Output from NESTED_TABLE_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := nested_table_list ( l_list );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         show_elapsed_time;
      END test_nested_table_list;

      PROCEDURE test_member_of_list
      IS
         l_list pky_nt := pky_nt ( 1, 3 );
         l_cv sys_refcursor;
         l_one otn_question%ROWTYPE;
      BEGIN
         start_timing ( 'Output from MEMBER_OF_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := member_of_list ( l_list );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         show_elapsed_time;
      END test_member_of_list;
   BEGIN
      test_nds_list;
      test_dbms_sql_list;
      test_nested_table_list;
      test_member_of_list;
   END test_varieties;
END in_clause;
/

BEGIN
   in_clause.test_varieties ( iterations_in       => 100
                            , list_in             => '1,3'
                            );
/*
In Oracle 10g Release 2

Output from NDS_LIST
  Elapsed CPU time: 29
Output from DBMS_SQL_LIST
  Elapsed CPU time: 25
Output from NESTED_TABLE_LIST
  Elapsed CPU time: 34
Output from MEMBER_OF_LIST
  Elapsed CPU time: 1959
*/
END;
/
