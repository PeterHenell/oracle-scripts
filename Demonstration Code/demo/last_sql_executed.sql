CREATE TABLE otn_books (
   title VARCHAR2(1000),
   author VARCHAR2(1000),
   page_count INTEGER
)
/

BEGIN
   INSERT INTO otn_books
        VALUES ( 'Fun with PL/SQL', 'Christopher Racicot', 100 );

   INSERT INTO otn_books
        VALUES ( 'Do it Right with PL/SQL', 'Bryn Llewellyn', 200 );

   INSERT INTO otn_books
        VALUES ( 'Endless Thoughts about PL/SQL', 'Steven Feuerstein', 1000 );
END;
/

DECLARE
   PROCEDURE show_max_count
   IS
      l_total_pages PLS_INTEGER;
   BEGIN
      SELECT MAX ( page_count )
        INTO l_total_pages
        FROM otn_books
       WHERE title LIKE '%PL/SQL%';

      DBMS_OUTPUT.put_line (    'Biggest PL/SQL book has '
                             || l_total_pages
                             || ' pages.'
                           );
   END;
BEGIN
   UPDATE otn_books
      SET page_count = page_count / 2
    WHERE title LIKE '%PL/SQL%';

   show_max_count;
   DBMS_OUTPUT.put_line (    'Number of rows modified...or it is? '
                          || SQL%ROWCOUNT
                        );
END;
/
