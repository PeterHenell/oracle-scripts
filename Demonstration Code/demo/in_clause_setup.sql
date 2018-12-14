DROP TABLE in_clause_tab
/

CREATE TABLE in_clause_tab (
   ID INTEGER,
   title VARCHAR2(100),
   description VARCHAR2(2000))
/   

BEGIN
   INSERT INTO in_clause_tab
        VALUES (1, 'How do I write a loop?'
              , 'What are the different ways I can write a loop in PL/SQL');

   INSERT INTO in_clause_tab
        VALUES (2, 'Use cursor FOR loop?'
              , 'Is there a reason any longer to use a cursor FOR loop, since I can now use BULK COLLECT?');

   INSERT INTO in_clause_tab
        VALUES (3, 'Which version of PL/SQL is best?'
              , 'What is the best version of PL/SQL?');

   FOR indx IN 1 .. 10000
   LOOP
      INSERT INTO in_clause_tab
           VALUES (indx + 3, 'Title ' || indx, 'Description ' || indx);
   END LOOP;

   COMMIT;
END;
/

REM Copy of relational table as an object type, used in nested table defintion

DROP TYPE in_clause_ot FORCE
/
DROP TYPE in_clause_tab_nt FORCE
/
DROP TYPE pky_nt FORCE
/

CREATE TYPE in_clause_ot AS OBJECT (
   ID            INTEGER
 , title         VARCHAR2 (100)
 , description   VARCHAR2 (2000)
)
/

CREATE OR REPLACE TYPE in_clause_tab_nt IS TABLE OF in_clause_ot;
/

CREATE OR REPLACE TYPE pky_nt IS TABLE OF INTEGER;
/
