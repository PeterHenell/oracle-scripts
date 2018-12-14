DROP TABLE jokes
/
DROP TABLE joke_archive
/
CREATE TABLE jokes (
   joke_id INTEGER,
   title VARCHAR2(100),
   text VARCHAR2(4000)
)
/
CREATE TABLE joke_archive (
   archived_on DATE, old_stuff VARCHAR2(4000)
)
/

BEGIN
   INSERT INTO jokes
        VALUES (100, 'Why does an elephant take a shower?'
               ,'Why does an elephant take a shower? Because he can''t fit in the bathtub!');

   INSERT INTO jokes
        VALUES (100
               ,'How can you prevent deseases caused by biting insects?'
               ,'How can you prevent deseases caused by biting insects? Don''t bite any!');

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE get_title_or_text (
   title_like_in IN VARCHAR2
  ,return_title_in IN BOOLEAN
  ,joke_count_out OUT PLS_INTEGER
  ,jokes_out OUT sys_refcursor
)
IS
   c_from_where   VARCHAR2 (100) := ' FROM jokes WHERE title LIKE :your_title';
   l_colname      all_tab_columns.column_name%TYPE   := 'TEXT';
   l_query        VARCHAR2 (32767);
BEGIN
   IF return_title_in
   THEN
      l_colname := 'TITLE';
   END IF;

   l_query := 'SELECT ' || l_colname || c_from_where;

   OPEN jokes_out FOR l_query USING title_like_in;

   EXECUTE IMMEDIATE 'SELECT COUNT(*)' || c_from_where
                INTO joke_count_out
               USING title_like_in;
END get_title_or_text;
/

DECLARE
   l_count        PLS_INTEGER;
   l_jokes        sys_refcursor;

   TYPE jokes_tt IS TABLE OF jokes.text%TYPE;

   l_joke_array   jokes_tt      := jokes_tt ();
BEGIN
   get_title_or_text (title_like_in        => '%insect%'
                     ,return_title_in      => FALSE
                     ,joke_count_out       => l_count
                     ,jokes_out            => l_jokes
                     );
   DBMS_OUTPUT.put_line ('Number of jokes found = ' || l_count);

   FETCH l_jokes
   BULK COLLECT INTO l_joke_array;

   CLOSE l_jokes;

   FORALL indx IN l_joke_array.FIRST .. l_joke_array.LAST
      INSERT INTO joke_archive
           VALUES (SYSDATE, l_joke_array (indx));
END;
/

REM And with a LIMIT clause....

DECLARE
   l_count        PLS_INTEGER;
   l_jokes        sys_refcursor;

   TYPE jokes_tt IS TABLE OF jokes.text%TYPE;

   l_joke_array   jokes_tt      := jokes_tt ();
BEGIN
   get_title_or_text (title_like_in        => '%insect%'
                     ,return_title_in      => FALSE
                     ,joke_count_out       => l_count
                     ,jokes_out            => l_jokes
                     );
   DBMS_OUTPUT.put_line ('Number of jokes found = ' || l_count);

   LOOP
      FETCH l_jokes
      BULK COLLECT INTO l_joke_array LIMIT 100;
	  
	  EXIT WHEN l_joke_array.COUNT = 0;

      FORALL indx IN l_joke_array.FIRST .. l_joke_array.LAST
         INSERT INTO joke_archive
              VALUES (SYSDATE, l_joke_array (indx));
   END LOOP;

   CLOSE l_jokes;
END;
/
