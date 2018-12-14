DROP TABLE my_books
/
DROP TABLE my_books_error_log
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
CREATE UNIQUE INDEX my_books_at ON my_books (title, author)
/

BEGIN
   DBMS_ERRLOG.create_error_log ( dml_table_name          => 'MY_BOOKS'
                                , err_log_table_name      => 'MY_BOOKS_ERROR_LOG'
                                );
END;
/

COLUMN ORA_ERR_NUMBER$ FORMAT 999999
COLUMN ORA_ERR_MESG$ FORMAT A60            

BEGIN
   INSERT INTO my_books
               ( book_id, title, summary, author, date_published
               , page_count
               )
        VALUES ( NULL, 'A', 'B', 'C', SYSDATE, 0)
        LOG ERRORS REJECT LIMIT UNLIMITED;
END;
/

SELECT ORA_ERR_NUMBER$, ORA_ERR_MESG$ FROM err$_my_books
/

-- Add a tag value

DECLARE
   l_author my_books.author%TYPE := 'ABC';
BEGIN
   INSERT INTO my_books
               ( book_id, title, summary
               , author, date_published, page_count
               )
        VALUES ( NULL, 'A', 'B', l_author, SYSDATE, 0)
        LOG ERRORS ('Author = ' || author)
        REJECT LIMIT UNLIMITED;
END;
/

-- Multiple row errors

DECLARE
   l_author my_books.author%TYPE := 'ABC';
BEGIN
   DELETE FROM my_books;

   FOR indx IN 1 .. 1000
   LOOP
      INSERT INTO my_books
                  ( book_id, title
                  , summary, author, date_published, page_count
                  )
           VALUES ( indx, 'Oracle PL/SQL Version ' || indx
                  , 'Good stuff about PL/SQL', 'Feuerstein', SYSDATE, 1000
                  );
   END LOOP;

   /*
   UPDATE my_books
      SET book_id = book_id + 1
    WHERE book_id < 100
    LOG ERRORS REJECT LIMIT UNLIMITED;
   */
    
   UPDATE my_books
      SET page_count = 0
    WHERE book_id < 100
    LOG ERRORS REJECT LIMIT UNLIMITED;    
END;
/

SELECT ORA_ERR_NUMBER$, ORA_ERR_MESG$ FROM err$_my_books
/
