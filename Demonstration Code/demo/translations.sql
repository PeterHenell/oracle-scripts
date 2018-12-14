DROP TABLE translations;

CREATE TABLE translations (
   english varchar2(200),
   french varchar2(200));

BEGIN
   INSERT INTO translations
        VALUES ('computer', 'ordinateur');

   INSERT INTO translations
        VALUES ('tree', 'arbre');

   INSERT INTO translations
        VALUES ('book', 'livre');

   INSERT INTO translations
        VALUES ('cabbage', 'chou');

   INSERT INTO translations
        VALUES ('country', 'pays');

   INSERT INTO translations
        VALUES ('vehicle', 'voiture');

   INSERT INTO translations
        VALUES ('garlic', 'ail');

   INSERT INTO translations
        VALUES ('apple', 'pomme');

   INSERT INTO translations
        VALUES ('desk', 'éscritoire');

   INSERT INTO translations
        VALUES ('furniture', 'meubles');

   -- Give it some volume with which to work
   FOR indx IN 1 .. 10000
   LOOP
      INSERT INTO translations
           VALUES ('english' || indx, 'french' || indx);
   END LOOP;

   COMMIT;
END;
/

create index translations_english on translations(english);