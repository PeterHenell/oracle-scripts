/* Formatted on 2001/09/18 14:53 (RevealNet Formatter v4.4.1) */
DROP TABLE parts;

CREATE TABLE parts (
   partnum NUMBER,
   partname VARCHAR2(15)
   );

CREATE TYPE partnums_nt IS TABLE OF NUMBER;
/
DROP TYPE partnums_va FORCE;
/
CREATE TYPE partnums_va IS varray (&&1) OF NUMBER;
/
CREATE TYPE partnames_nt IS TABLE OF VARCHAR2(15);
/
DROP TYPE partnames_va FORCE;
/
CREATE TYPE partnames_va IS varray (&&1) OF VARCHAR2(15);
/

DECLARE
   TYPE numtab IS TABLE OF parts.partnum%TYPE
      INDEX BY BINARY_INTEGER;

   TYPE nametab IS TABLE OF parts.partname%TYPE
      INDEX BY BINARY_INTEGER;

   ibtpnums    numtab;
   ibtpnames   nametab;
   ntpnums     partnums_nt := partnums_nt ();
   ntpnames    partnames_nt := partnames_nt ();
   vapnums     partnums_va := partnums_va ();
   vapnames    partnames_va := partnames_va ();
BEGIN
   ntpnums.EXTEND (&&1);
   ntpnames.EXTEND (&&1);
   vapnums.EXTEND (&&1);
   vapnames.EXTEND (&&1);

   FOR indx IN 1 .. &&1
   LOOP
      ibtpnums (indx) := indx;
      ibtpnames (indx) :=    'Part '
                          || TO_CHAR (indx);
      ntpnums (indx) := indx;
      ntpnames (indx) :=    'Part '
                         || TO_CHAR (indx);
      vapnums (indx) := indx;
      vapnames (indx) :=    'Part '
                         || TO_CHAR (indx);
   END LOOP;

   DELETE FROM parts;

   COMMIT;
   sf_timer.start_timer;
   FORALL indx IN 1 .. &&1
      INSERT INTO parts
           VALUES (ibtpnums (indx), ibtpnames (indx));
   p.l (   'SQL%ROWCOUNT = '
        || SQL%ROWCOUNT);
   sf_timer.show_elapsed_time ('IBT ');
   ROLLBACK;
   sf_timer.start_timer;
   FORALL indx IN 1 .. &&1
      INSERT INTO parts
           VALUES (ntpnums (indx), ntpnames (indx));
   p.l (   'SQL%ROWCOUNT = '
        || SQL%ROWCOUNT);
   sf_timer.show_elapsed_time ('NT ');
   ROLLBACK;
   sf_timer.start_timer;
   FORALL indx IN 1 .. &&1  
      INSERT INTO parts
           VALUES (vapnums (indx), vapnames (indx));
   p.l (   'SQL%ROWCOUNT = '
        || SQL%ROWCOUNT);
   sf_timer.show_elapsed_time ('VARRAY ');
   ROLLBACK;
END;
/

