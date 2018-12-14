SET FEEDBACK OFF
SET SERVEROUTPUT ON FORMAT WRAPPED

SPOOL dbms_errlog.log

-- Remove objects if they exist

DROP TABLE my_books
/
DROP TABLE err$_my_books
/
-- Create objects for test

CREATE TABLE my_books
(
  book_id         INTEGER,
  title           VARCHAR2(200) NOT NULL,
  summary         VARCHAR2(2000),
  author          VARCHAR2(200) NOT NULL,
  date_published  DATE NOT NULL,
  page_count      INTEGER NOT NULL
)
/
ALTER TABLE my_books ADD (PRIMARY KEY (book_id))
/
ALTER TABLE my_books
   ADD CONSTRAINT my_books_not_empty_cc
   CHECK (page_count > 0)
/
CREATE TABLE err$_my_books (
   ERROR_CODE INTEGER,
   error_message VARCHAR2(4000),
   backtrace VARCHAR2(4000),
   created_by VARCHAR2(100),
   created_on DATE)
/

CREATE OR REPLACE PACKAGE my_books_util
IS
   g_counter PLS_INTEGER;

   PROCEDURE set_start;

   PROCEDURE setup_for_insert (
      cause_errors_in   IN       BOOLEAN
    , count_in          IN       PLS_INTEGER
    , index_in          IN       PLS_INTEGER
    , key_out           OUT      PLS_INTEGER
    , count_out         OUT      PLS_INTEGER
   );

   PROCEDURE report_results (
      count_in          IN   PLS_INTEGER
    , cause_errors_in   IN   BOOLEAN
   );
END my_books_util;
/

CREATE OR REPLACE PACKAGE BODY my_books_util
IS
   g_start NUMBER;

   PROCEDURE set_start
   IS
      l_count PLS_INTEGER;
      l_err_count PLS_INTEGER;
   BEGIN
      g_counter := 0;
      g_start := DBMS_UTILITY.get_cpu_time;
   END set_start;

   PROCEDURE setup_for_insert (
      cause_errors_in   IN       BOOLEAN
    , count_in          IN       PLS_INTEGER
    , index_in          IN       PLS_INTEGER
    , key_out           OUT      PLS_INTEGER
    , count_out         OUT      PLS_INTEGER
   )
   IS
   BEGIN
      key_out := index_in;
      count_out := index_in;
         
      IF cause_errors_in
      THEN
         IF MOD ( index_in, 2 ) = 0
         THEN
            IF index_in < count_in / 2
            THEN
               -- Dup val error
               key_out := index_in - 1;
            ELSE
               -- Check constraint error
               count_out := 0;
            END IF;
         END IF;
      END IF;
   END setup_for_insert;

   PROCEDURE report_results ( count_in IN PLS_INTEGER, cause_errors_in IN BOOLEAN )
   IS
      l_count PLS_INTEGER;
      l_err_count PLS_INTEGER;
   BEGIN
      DBMS_OUTPUT.put_line (    CASE cause_errors_in
                                   WHEN TRUE
                                      THEN    'Attempt to insert '
                                           || count_in
                                           || ' rows with 50% errors'
                                   ELSE    'Insert '
                                        || count_in
                                        || ' rows without any errors'
                                END
                             || ' elapsed CPU time: '
                             || TO_CHAR (   ( DBMS_UTILITY.get_cpu_time - g_start
                                            )
                                          / 100
                                        )
                             || ' seconds'
                           );
   
      SELECT COUNT ( * )
        INTO l_count
        FROM my_books;
   
      SELECT COUNT ( * )
        INTO l_err_count
        FROM err$_my_books;
   
      DBMS_OUTPUT.put_line ( '   my_books count: ' || l_count );
      DBMS_OUTPUT.put_line ( '   log table count: ' || l_err_count );
      DBMS_OUTPUT.put_line ( '   handled errors count: ' || g_counter );
      DBMS_OUTPUT.put_line ( '' );
   
      EXECUTE IMMEDIATE 'TRUNCATE TABLE my_books';
   
      EXECUTE IMMEDIATE 'TRUNCATE TABLE err$_my_books';
   END report_results;
END my_books_util;
/


CREATE OR REPLACE PROCEDURE my_books_insert (
   key_in              IN   PLS_INTEGER
 , title_in            IN   VARCHAR2
 , summary_in          IN   VARCHAR2
 , author_in           IN   VARCHAR2
 , date_published_in   IN   DATE
 , page_count_in       IN   NUMBER
)
IS
BEGIN
   INSERT INTO my_books
               ( book_id, title, summary, author, date_published
               , page_count
               )
        VALUES ( key_in, title_in, summary_in, author_in, date_published_in
               , page_count_in
               );
-- Just ignore errors
EXCEPTION
   WHEN OTHERS
   THEN
      my_books_counter.g_counter := my_books_counter.g_counter + 1;
END my_books_insert;
/

-- Procedure to load N rows, half of them with errors if requested, and display elapsed time.

CREATE OR REPLACE PROCEDURE my_books_load (
   count_in          IN   PLS_INTEGER
 , cause_errors_in   IN   BOOLEAN
)
IS
   l_key PLS_INTEGER;
   l_count PLS_INTEGER;
BEGIN
   my_books_util.set_start;
   
   FOR indx IN 1 .. count_in
   LOOP
      my_books_util.setup_for_insert (cause_errors_in, count_in, indx, l_key, l_count);

      my_books_insert ( l_key
                      , 'Book ' || l_key
                      , 'Just another book about the number  ' || l_key
                      , 'Author ' || l_key
                      , SYSDATE
                      , l_count
                      );
   END LOOP;

   my_books_util.report_results ( count_in, cause_errors_in );
END my_books_load;
/

-- Elapsed time for inserting 5000 books, no error logging

BEGIN
   DBMS_OUTPUT.put_line ( 'NO LOGGING' );
   my_books_load ( 5000, FALSE );
   my_books_load ( 5000, TRUE );
END;
/

DROP TABLE err$_my_books
/

CREATE TABLE err$_my_books (
   ERROR_CODE INTEGER,
   error_message VARCHAR2(4000),
   backtrace VARCHAR2(4000),
   created_by VARCHAR2(100),
   created_on DATE)
/

ALTER PACKAGE my_books_util COMPILE PACKAGE REUSE SETTINGS
/

CREATE OR REPLACE PROCEDURE save_error_information ( code_in IN PLS_INTEGER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO err$_my_books
        VALUES ( code_in, DBMS_UTILITY.format_error_stack
               , DBMS_UTILITY.format_error_backtrace, USER, SYSDATE );

   COMMIT;
END save_error_information;
/

CREATE OR REPLACE PROCEDURE my_books_insert (
   key_in              IN   PLS_INTEGER
 , title_in            IN   VARCHAR2
 , summary_in          IN   VARCHAR2
 , author_in           IN   VARCHAR2
 , date_published_in   IN   DATE
 , page_count_in       IN   NUMBER
)
IS
BEGIN
   INSERT INTO my_books
               ( book_id, title, summary, author, date_published
               , page_count
               )
        VALUES ( key_in, title_in, summary_in, author_in, date_published_in
               , page_count_in
               );
EXCEPTION
   WHEN OTHERS
   THEN
      my_books_counter.g_counter := my_books_counter.g_counter + 1;
      save_error_information ( SQLCODE );
END my_books_insert;
/

BEGIN
   DBMS_OUTPUT.put_line ( 'AUTON TRANS LOG' );
   my_books_load ( 5000, FALSE );
   my_books_load ( 5000, TRUE );
END;
/

-- Use DBMS_ERRLOG for row by row inserts

DROP TABLE err$_my_books
/

BEGIN
   DBMS_ERRLOG.create_error_log ( dml_table_name => 'MY_BOOKS');
END;
/

ALTER PACKAGE my_books_util COMPILE PACKAGE REUSE SETTINGS
/

CREATE OR REPLACE PROCEDURE my_books_load (
   count_in          IN   PLS_INTEGER
 , cause_errors_in   IN   BOOLEAN
)
IS
   l_key PLS_INTEGER;
   l_count PLS_INTEGER;
BEGIN
   my_books_util.set_start;
   
   FOR indx IN 1 .. count_in
   LOOP
      my_books_util.setup_for_insert (cause_errors_in, count_in, indx, l_key, l_count);

      my_books_insert ( l_key
                      , 'Book ' || l_key
                      , 'Just another book about the number  ' || l_key
                      , 'Author ' || l_key
                      , SYSDATE
                      , l_count
                      );
   END LOOP;

   my_books_util.report_results ( count_in, cause_errors_in );
END my_books_load;
/
CREATE OR REPLACE PROCEDURE my_books_insert (
   key_in              IN   PLS_INTEGER
 , title_in            IN   VARCHAR2
 , summary_in          IN   VARCHAR2
 , author_in           IN   VARCHAR2
 , date_published_in   IN   DATE
 , page_count_in       IN   NUMBER
)
IS
BEGIN
   INSERT INTO my_books
               ( book_id, title, summary, author, date_published
               , page_count
               )
        VALUES ( key_in, title_in, summary_in, author_in, date_published_in
               , page_count_in
               )
        LOG ERRORS REJECT LIMIT UNLIMITED
   ;
-- Just ignore errors
EXCEPTION
   WHEN OTHERS
   THEN
      my_books_counter.g_counter := my_books_counter.g_counter + 1;
END my_books_insert;
/

BEGIN
   DBMS_OUTPUT.put_line ( 'DBMS_ERRLOG' );
   my_books_load ( 5000, FALSE );
   my_books_load ( 5000, TRUE );
END;
/

-- Now with FORALL

DROP TABLE err$_my_books
/
CREATE TABLE err$_my_books (
   ERROR_CODE INTEGER,
   error_message VARCHAR2(4000),
   backtrace VARCHAR2(4000),
   created_by VARCHAR2(100),
   created_on DATE)
/

ALTER PACKAGE my_books_util COMPILE PACKAGE REUSE SETTINGS
/


CREATE OR REPLACE PROCEDURE my_books_load (
   count_in          IN   PLS_INTEGER
 , cause_errors_in   IN   BOOLEAN
)
IS
   bulk_errors EXCEPTION;
   PRAGMA EXCEPTION_INIT ( bulk_errors, -24381 );
   l_key PLS_INTEGER;
   l_count PLS_INTEGER;

   TYPE my_books_aat IS TABLE OF my_books%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_my_books my_books_aat;

   PROCEDURE my_books_insert (
      key_in              IN   PLS_INTEGER
    , title_in            IN   VARCHAR2
    , summary_in          IN   VARCHAR2
    , author_in           IN   VARCHAR2
    , date_published_in   IN   DATE
    , page_count_in       IN   NUMBER
   )
   IS
      l_index PLS_INTEGER;
   BEGIN
      l_index := l_my_books.COUNT + 1;
      l_my_books ( l_index ).book_id := key_in;
      l_my_books ( l_index ).title := title_in;
      l_my_books ( l_index ).summary := summary_in;
      l_my_books ( l_index ).author := author_in;
      l_my_books ( l_index ).date_published := date_published_in;
      l_my_books ( l_index ).page_count := page_count_in;
   END my_books_insert;
BEGIN
   my_books_util.set_start;

   FOR indx IN 1 .. count_in
   LOOP
      my_books_util.setup_for_insert (cause_errors_in, count_in, indx, l_key, l_count);

      my_books_insert ( l_key
                      , 'Book ' || l_key
                      , 'Just another book about the number  ' || l_key
                      , 'Author ' || l_key
                      , SYSDATE
                      , l_count
                      );
   END LOOP;

   DECLARE
      l_code PLS_INTEGER;
   BEGIN
      FORALL indx IN 1 .. l_my_books.COUNT SAVE EXCEPTIONS
         INSERT INTO my_books
              VALUES l_my_books ( indx );
   EXCEPTION
      WHEN bulk_errors
      THEN
         my_books_counter.g_counter := SQL%BULK_EXCEPTIONS.COUNT;

         FOR indx IN 1 .. my_books_counter.g_counter
         LOOP
            -- Report the error
            l_code := SQL%BULK_EXCEPTIONS ( indx ).ERROR_CODE;

            INSERT INTO err$_my_books
                 VALUES ( l_code, DBMS_UTILITY.format_error_stack
                        , DBMS_UTILITY.format_error_backtrace, USER, SYSDATE );
         END LOOP;
   END;

   my_books_util.report_results ( count_in, cause_errors_in );
END my_books_load;
/

BEGIN
   DBMS_OUTPUT.put_line ( 'FORALL with SAVE EXCEPTIONS' );
   my_books_load ( 5000, FALSE );
   my_books_load ( 5000, TRUE );
END;
/

-- FORALL without save exceptions, using DBMS_ERRLOG instead
-- Does DBMS_ERRLOG not work with FORALL?

DROP TABLE err$_my_books
/

ALTER PACKAGE my_books_util COMPILE PACKAGE REUSE SETTINGS
/

BEGIN
   DBMS_ERRLOG.create_error_log ( dml_table_name => 'MY_BOOKS');
END;
/

CREATE OR REPLACE PROCEDURE my_books_load (
   count_in          IN   PLS_INTEGER
 , cause_errors_in   IN   BOOLEAN
)
IS
   bulk_errors EXCEPTION;
   PRAGMA EXCEPTION_INIT ( bulk_errors, -24381 );
   l_key PLS_INTEGER;
   l_count PLS_INTEGER;
   l_start PLS_INTEGER;

   TYPE my_books_aat IS TABLE OF my_books%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_my_books my_books_aat;  

   PROCEDURE my_books_insert (
      key_in              IN   PLS_INTEGER
    , title_in            IN   VARCHAR2
    , summary_in          IN   VARCHAR2
    , author_in           IN   VARCHAR2
    , date_published_in   IN   DATE
    , page_count_in       IN   NUMBER
   )
   IS
      l_index PLS_INTEGER;
   BEGIN
      l_index := l_my_books.COUNT + 1;
      l_my_books ( l_index ).book_id := key_in;
      l_my_books ( l_index ).title := title_in;
      l_my_books ( l_index ).summary := summary_in;
      l_my_books ( l_index ).author := author_in;
      l_my_books ( l_index ).date_published := date_published_in;
      l_my_books ( l_index ).page_count := page_count_in;
   END my_books_insert;
BEGIN
   my_books_util.set_start;

   FOR indx IN 1 .. count_in
   LOOP
      my_books_util.setup_for_insert (cause_errors_in, count_in, indx, l_key, l_count);

      my_books_insert ( l_key
                      , 'Book ' || l_key
                      , 'Just another book about the number  ' || l_key
                      , 'Author ' || l_key
                      , SYSDATE
                      , l_count
                      );
   END LOOP;

   DECLARE
      l_code PLS_INTEGER;
   BEGIN
      FORALL indx IN 1 .. l_my_books.COUNT                 
         INSERT INTO my_books
              VALUES l_my_books ( indx )
              LOG ERRORS REJECT LIMIT UNLIMITED;
   END;

   my_books_util.report_results ( count_in, cause_errors_in );
END my_books_load;
/

BEGIN
   DBMS_OUTPUT.put_line
                       ( 'FORALL without SAVE EXCEPTIONS, use of DBMS_ERRLOG' );
   my_books_load ( 5000, FALSE );
   my_books_load ( 5000, TRUE );
END;
/

SPOOL OFF
