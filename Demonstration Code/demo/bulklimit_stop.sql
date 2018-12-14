DROP TABLE stuff
/

CREATE TABLE stuff (pk INTEGER, description VARCHAR2 (100))
/

BEGIN
   FOR indx IN 1 .. 4
   LOOP
      INSERT INTO stuff (pk, description
                        )
          VALUES (indx, 'Stuff ' || indx
                 );
   END LOOP;

   COMMIT;
END;
/

DECLARE
   c_limit   CONSTANT PLS_INTEGER := 3;

   CURSOR stuff_cur
   IS
      SELECT *
        FROM stuff;

   TYPE stuff_aat
   IS
      TABLE OF stuff_cur%ROWTYPE
         INDEX BY PLS_INTEGER;

   l_stuff   stuff_aat;
BEGIN
   DBMS_OUTPUT.put_line ('EXIT WHEN %NOTFOUND right after fetch');

   OPEN stuff_cur;

   LOOP
      FETCH stuff_cur BULK COLLECT INTO l_stuff LIMIT c_limit;

      DBMS_OUTPUT.put_line ('  Fetched ' || l_stuff.COUNT || ' rows.');

      EXIT WHEN stuff_cur%NOTFOUND;

      FOR indx IN 1 .. l_stuff.COUNT
      LOOP
         DBMS_OUTPUT.put_line ('  Do stuff ' || indx);
      END LOOP;
   END LOOP;

   CLOSE stuff_cur;

   DBMS_OUTPUT.put_line ('EXIT WHEN COUNT = 0 right after fetch');

   OPEN stuff_cur;

   LOOP
      FETCH stuff_cur BULK COLLECT INTO l_stuff LIMIT c_limit;

      DBMS_OUTPUT.put_line ('  Fetched ' || l_stuff.COUNT || ' rows.');

      EXIT WHEN l_stuff.COUNT = 0;

      FOR indx IN 1 .. l_stuff.COUNT
      LOOP
         DBMS_OUTPUT.put_line ('  Do stuff ' || indx);
      END LOOP;
   END LOOP;

   CLOSE stuff_cur;

   DBMS_OUTPUT.put_line ('EXIT WHEN %NOTFOUND at end of loop');

   OPEN stuff_cur;

   LOOP
      FETCH stuff_cur BULK COLLECT INTO l_stuff LIMIT c_limit;

      DBMS_OUTPUT.put_line ('  Fetched ' || l_stuff.COUNT || ' rows.');

      FOR indx IN 1 .. l_stuff.COUNT
      LOOP
         DBMS_OUTPUT.put_line ('  Do stuff ' || indx);
      END LOOP;

      EXIT WHEN stuff_cur%NOTFOUND;
   END LOOP;

   CLOSE stuff_cur;

   DBMS_OUTPUT.put_line ('EXIT WHEN COUNT < limit at end of loop');

   OPEN stuff_cur;

   LOOP
      FETCH stuff_cur BULK COLLECT INTO l_stuff LIMIT c_limit;

      DBMS_OUTPUT.put_line ('  Fetched ' || l_stuff.COUNT || ' rows.');

      FOR indx IN 1 .. l_stuff.COUNT
      LOOP
         DBMS_OUTPUT.put_line ('  Do stuff ' || indx);
      END LOOP;

      EXIT WHEN l_stuff.COUNT < c_limit;
   END LOOP;

   CLOSE stuff_cur;
END;
/