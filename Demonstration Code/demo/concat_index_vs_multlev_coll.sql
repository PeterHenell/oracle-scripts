declare
   SUBTYPE author_t IS VARCHAR2 ( 32767 );
   SUBTYPE title_t IS VARCHAR2 ( 32767 );

   -- Guarantee uniqueness of concatenated values from the index with a delimiter.

   g_last_load DATE;
   g_reload_interval INTERVAL DAY TO SECOND := NULL;

   -- Auto reload turned off
   TYPE by_author_aat IS TABLE OF number
      INDEX BY author_t;

    TYPE by_author_aat IS TABLE OF number
      INDEX BY title_t;
       TYPE by_author_aat IS TABLE OF number
      INDEX BY author_t;


   books_aa book_id_aat;
   by_isbn_aa isbn_aat;
   by_author_title_aa author_title_aat;

   FUNCTION author_title (
      author_in        books.author%TYPE
    , title_in         books.title%TYPE
    , delim_in    IN   VARCHAR2 := '^'
   )
      RETURN author_title_t
   IS
   BEGIN
      RETURN UPPER ( author_in ) || delim_in || UPPER ( title_in );
   END;

   PROCEDURE load_arrays
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    'Reloading books arrays at '
                             || TO_CHAR ( SYSDATE, 'HH24:MI:SS' )
                           );
      -- HOC class Minn 2/2006
      books_aa.DELETE;
      by_isbn_aa.DELETE;
      by_author_title_aa.DELETE;

      FOR rec IN ( SELECT *
                    FROM books )
      LOOP
         books_aa ( rec.book_id ) := rec;
         by_isbn_aa ( rec.isbn ) := rec.book_id;
         by_author_title_aa ( author_title ( rec.author, rec.title )) :=
                                                                  rec.book_id;
      END LOOP;

      g_last_load := SYSDATE;
   END load_arrays;

   PROCEDURE set_reload_interval ( interval_in IN INTERVAL DAY TO SECOND )
   IS
   BEGIN
      g_reload_interval := interval_in;
   END;

   PROCEDURE set_reload_interval ( interval_in IN NUMBER )
   IS
   BEGIN
      g_reload_interval := NUMTODSINTERVAL ( interval_in, 'SECOND' );
   END;

   FUNCTION reload_needed
      RETURN BOOLEAN
   IS
      retval BOOLEAN := g_reload_interval IS NOT NULL;
      l_date DATE := SYSDATE;
   BEGIN
      IF retval
      THEN
         retval :=
            NUMTODSINTERVAL ( l_date - g_last_load, 'DAY' ) >
                                                            g_reload_interval;
      END IF;

      RETURN retval;
   END;

   FUNCTION onebook ( book_id_in IN books.book_id%TYPE )
      RETURN books%ROWTYPE
   IS
   BEGIN
      IF reload_needed
      THEN
         load_arrays;
      END IF;

      RETURN books_aa ( book_id_in );
   END;

   FUNCTION onebook ( isbn_in IN books.isbn%TYPE )
      RETURN books%ROWTYPE
   IS
      l_book_id books.book_id%TYPE;
   BEGIN
      IF reload_needed
      THEN
         load_arrays;
      END IF;

      l_book_id := by_isbn_aa ( isbn_in );
      RETURN onebook ( l_book_id );
   END;

   FUNCTION onebook ( author_in books.author%TYPE, title_in books.title%TYPE )
      RETURN books%ROWTYPE
   IS
      l_book_id books.book_id%TYPE;
   BEGIN
      IF reload_needed
      THEN
         load_arrays;
      END IF;

      l_book_id := by_author_title_aa ( author_title ( author_in, title_in ));
      RETURN onebook ( l_book_id );
   END;
BEGIN
   load_arrays;
END summer_reading;
/
