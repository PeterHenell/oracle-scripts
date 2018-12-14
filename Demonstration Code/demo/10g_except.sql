CREATE OR REPLACE TYPE strings_nt IS TABLE OF VARCHAR2 (1000)
/

CREATE OR REPLACE PACKAGE authors_pkg
IS
   steven_authors   strings_nt
                       := strings_nt ('ROBIN HOBB'
                                    , 'ROBERT HARRIS'
                                    , 'ROBERT HARRIS'
                                    , 'DAVID BRIN'
                                    , 'DAVID BRIN'
                                    , 'SHERI S. TEPPER'
                                    , 'CHRISTOPHER ALEXANDER');
   veva_authors     strings_nt
                       := strings_nt ('ROBIN HOBB'
                                    , 'SHERI S. TEPPER'
                                    , 'ANNE MCCAFFREY'
                                    , 'DAVID BRIN'
                                    , 'DAVID BRIN');

   eli_authors      strings_nt
      := strings_nt ('PIERS ANTHONY', 'SHERI S. TEPPER', 'DAVID BRIN');

   PROCEDURE show_authors (title_in IN VARCHAR2, authors_in IN strings_nt);
END;
/

CREATE OR REPLACE PACKAGE BODY authors_pkg
IS
   PROCEDURE show_authors (title_in IN VARCHAR2, authors_in IN strings_nt)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (title_in);

      FOR indx IN 1 .. authors_in.COUNT
      LOOP
         DBMS_OUTPUT.put_line (indx || ' = ' || authors_in (indx));
      END LOOP;
   END show_authors;
END;
/

DECLARE
   our_authors   strings_nt := strings_nt ();
BEGIN
   our_authors :=
      authors_pkg.veva_authors MULTISET EXCEPT authors_pkg.steven_authors;

   authors_pkg.show_authors (q'[Only Veva's]', our_authors);

   our_authors :=
      authors_pkg.steven_authors MULTISET EXCEPT authors_pkg.veva_authors;

   authors_pkg.show_authors (q'[Only Steven's]', our_authors);
   our_authors :=
      authors_pkg.steven_authors
         MULTISET EXCEPT DISTINCT authors_pkg.veva_authors;

   authors_pkg.show_authors (q'[Only Steven's without duplicates]'
                           , our_authors);
END;
/