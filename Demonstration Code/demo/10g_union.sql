DECLARE
   our_authors   strings_nt;
BEGIN
   authors_pkg.init_authors;
   our_authors :=
      authors_pkg.steven_authors MULTISET UNION authors_pkg.veva_authors;

   authors_pkg.show_authors ('Steven and Veva', our_authors);

   /* Use MULTISET UNION inside SQL */
   DBMS_OUTPUT.put_line ('Union inside SQL');

   FOR rec IN (  SELECT COLUMN_VALUE
                   FROM TABLE (
                           authors_pkg.veva_authors
                              MULTISET UNION authors_pkg.steven_authors)
               ORDER BY COLUMN_VALUE)
   LOOP
      DBMS_OUTPUT.put_line (rec.COLUMN_VALUE);
   END LOOP;

   our_authors :=
      authors_pkg.steven_authors
         MULTISET UNION DISTINCT authors_pkg.veva_authors;

   authors_pkg.show_authors ('Steven then Veva with DISTINCT', our_authors);
END;
/