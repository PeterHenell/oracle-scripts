DECLARE
   distinct_authors   strings_nt := strings_nt ();

   PROCEDURE bpl (val IN BOOLEAN, str IN VARCHAR2)
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line (str || '-TRUE');
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line (str || '-FALSE');
      ELSE
         DBMS_OUTPUT.put_line (str || '-NULL');
      END IF;
   END;
BEGIN
   authors_pkg.init_authors;
   -- Add a duplicate author to Steven's list
   authors_pkg.steven_authors.EXTEND;
   authors_pkg.steven_authors (authors_pkg.steven_authors.LAST) :=
      'ROBERT HARRIS';

   distinct_authors := SET (authors_pkg.steven_authors);

   authors_pkg.show_authors ('FULL SET', authors_pkg.steven_authors);

   bpl (authors_pkg.steven_authors IS A SET, 'My authors distinct?');
   bpl (authors_pkg.steven_authors IS NOT A SET, 'My authors NOT distinct?');
   DBMS_OUTPUT.put_line ('');

   authors_pkg.show_authors ('DISTINCT SET', distinct_authors);

   bpl (distinct_authors IS A SET, 'SET of authors distinct?');
   bpl (distinct_authors IS NOT A SET, 'SET of authors NOT distinct?');
   DBMS_OUTPUT.put_line ('');

   -- Now add a NULL to the list and see how things work.
   -- First remove previous duplicate.
   authors_pkg.steven_authors.delete (authors_pkg.steven_authors.LAST);
   authors_pkg.show_authors ('Steven', authors_pkg.steven_authors);
   authors_pkg.steven_authors.EXTEND;
   authors_pkg.steven_authors (authors_pkg.steven_authors.LAST) := NULL;
   bpl (authors_pkg.steven_authors IS A SET
      , 'My authors with one NULL distinct?');

   authors_pkg.steven_authors.EXTEND;
   authors_pkg.steven_authors (authors_pkg.steven_authors.LAST) := NULL;
   bpl (authors_pkg.steven_authors IS A SET
      , 'My authors with two NULLs distinct?');
END;
/