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
CREATE UNIQUE INDEX my_books_at ON my_books (title, author)
/

GRANT ALL ON my_books to SCOTT
/

BEGIN
   INSERT INTO my_books
        VALUES (1, 'Oracle PL/SQL Programming', 'Great book!'
              , 'Feuerstein, Steven', '23-SEP-1995', 700);
   COMMIT;              
END;
/

BEGIN
   DBMS_ERRLOG.create_error_log ( dml_table_name => 'MY_BOOKS'
                                );
END;
/

/* Table is created with this structure:

  ORA_ERR_NUMBER$  NUMBER,
  ORA_ERR_MESG$    VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$   UROWID(4000),
  ORA_ERR_OPTYP$   VARCHAR2(2 BYTE),
  ORA_ERR_TAG$     VARCHAR2(2000 BYTE),
  BOOK_ID          VARCHAR2(4000 BYTE),
  TITLE            VARCHAR2(4000 BYTE),
  SUMMARY          VARCHAR2(4000 BYTE),
  AUTHOR           VARCHAR2(4000 BYTE),
  DATE_PUBLISHED   VARCHAR2(4000 BYTE),
  PAGE_COUNT       VARCHAR2(4000 BYTE),

*/

/*
Add columns to track the currently connected user doing the insert,
and also to show where the insert statement was executed (callstack).

The first is important when you are inserting from different schemas.
The second is most helpful for debugging.

Note that calling the dbms_utility.Format_error_backtrace function
is useless, because the whole point of DBMS_ERRLOG is that you are 
no longer raising an exception.
*/

ALTER TABLE err$_my_books ADD (
   username VARCHAR2(100),
   callstack VARCHAR2(4000)
)
/
   
CREATE OR REPLACE TRIGGER my_books_errlog_bi
 BEFORE INSERT
   ON err$_my_books
   FOR EACH ROW
BEGIN
   :new.username := USER;
   /* Make sure we don't get a VALUE_ERROR exception. */
   :new.callstack := substr (dbms_utility.Format_call_stack (), 1, 4000);
END;
/

/*
Inserts that cause exceptions....
*/
CREATE OR REPLACE PROCEDURE test_inserts
IS
begin
   BEGIN
      INSERT INTO hr.my_books
                  (book_id
                 , title
                 , summary
                 , author
                 , date_published
                 , page_count
                  )
           VALUES (NULL
                 , 'A'
                 , 'B'
                 , 'C'
                 , SYSDATE
                 , 1000
                  )
                  LOG ERRORS REJECT LIMIT UNLIMITED
      ;
   END;

   BEGIN
      INSERT INTO hr.my_books
                  (book_id
                 , title
                 , summary
                 , author
                 , date_published
                 , page_count
                  )
           VALUES (5
                 , 'Oracle PL/SQL Programming'
                 , 'B'
                 , 'Feuerstein, Steven'
                 , SYSDATE
                 , 1000
                  )
                 LOG ERRORS REJECT LIMIT UNLIMITED
      ;
   END;

   BEGIN
      INSERT INTO hr.my_books
                  (book_id
                 , title
                 , summary
                 , author
                 , date_published
                 , page_count
                  )
           VALUES (5
                 , 'How to Make Kites'
                 , 'B'
                 , 'C'
                 , SYSDATE
                 , 0
                  )
                  LOG ERRORS REJECT LIMIT UNLIMITED
      ;
   END;
   ROLLBACK;
END test_inserts;
/

GRANT EXECUTE on test_inserts TO SCOTT
/

BEGIN
   test_inserts;
END;
/   