DECLARE
   l   DBMS_SQL.varchar2s;

   PROCEDURE setup
   IS
   BEGIN
      l.DELETE;
      l (1) := 'a';
      l (2) := 'b';
      l (3) := 'c';
      l (4) := 'd';
   END;

   PROCEDURE show
   IS
   BEGIN
      p.l ('Contents:');

      FOR indx IN l.FIRST .. l.LAST
      LOOP
         p.l (indx || '-' || l (indx));
      END LOOP;
   END;
BEGIN
   setup;
   shift_contents (l, 2, 2, 'XXX');
   show;
   setup;
   shift_contents (l, -2, 2, 'XXX');
   show;
   setup;
   shift_contents (l, -10, 1, 'XXX');
   show;
   setup;
   shift_contents (l, 10, 4, 'XXX');
   show;
   setup;
   shift_contents (l, 1, 100, 'XXX');
   show;
   setup;
   shift_contents (l, -1, -50, 'XXX');
   show;
END;
/