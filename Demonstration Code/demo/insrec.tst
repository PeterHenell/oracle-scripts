CREATE SEQUENCE books_seq;

CREATE TABLE BOOKS
(
  BOOK_ID         INTEGER NOT NULL,
  ISBN            VARCHAR2(13) NOT NULL,
  TITLE           VARCHAR2(200),
  SUMMARY         VARCHAR2(2000),
  AUTHOR          VARCHAR2(200),
  DATE_PUBLISHED  DATE,
  PAGE_COUNT      NUMBER
);

ALTER TABLE BOOKS ADD (
  PRIMARY KEY (ISBN));
  
DECLARE
   rec_tmr      tmr_t           := tmr_t.make ('INSERT with record', 10000);
   fields_tmr   tmr_t           := tmr_t.make ('INSERT with fields', 10000);
   rec          books%ROWTYPE;
BEGIN
   rec.title := 'PL/SQL IN TWO MINUTES';
   rec.summary := 'Very little';
   rec.author := 'Feuer, Steve';
   rec.date_published := SYSDATE;
   rec.page_count := 15;
   rec_tmr.go;

   FOR indx IN 1 .. 10000
   LOOP
      rec.isbn := '123' || '-' || LPAD (indx, 5, '0');
      SELECT books_seq.NEXTVAL INTO rec.book_id FROM dual; 
      INSERT INTO books
           VALUES rec;
   END LOOP;

   rec_tmr.STOP;
   ROLLBACK;
   fields_tmr.go;

   FOR indx IN 1 .. 10000
   LOOP
      rec.isbn := '123' || '-' || LPAD (indx, 5, '0');

      INSERT INTO books
           VALUES (books_seq.NEXTVAL, rec.isbn, rec.title, 
		           rec.summary, rec.author, rec.date_published, 
				   rec.page_count);
   END LOOP;
   fields_tmr.STOP;
   rollback;
END;
/
/*
Results

Elapsed time for "INSERT with record" = 7.61 seconds. Per repetition timing = .000761 seconds.
Elapsed time for "INSERT with fields" = 6.51 seconds. Per repetition timing = .000651 seconds.

Elapsed time for "INSERT with record" = 7.96 seconds. Per repetition timing = .000796 seconds.
Elapsed time for "INSERT with fields" = 6.22 seconds. Per repetition timing = .000622 seconds.

Elapsed time for "INSERT with record" = 6.11 seconds. Per repetition timing = .000611 seconds.
Elapsed time for "INSERT with fields" = 6.19 seconds. Per repetition timing = .000619 seconds.

Elapsed time for "INSERT with record" = 8.02 seconds. Per repetition timing = .000802 seconds.
Elapsed time for "INSERT with fields" = 7.69 seconds. Per repetition timing = .000769 seconds.
*/
