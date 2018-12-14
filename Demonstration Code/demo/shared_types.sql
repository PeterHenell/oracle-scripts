DROP TABLE otn_question;

CREATE TABLE otn_question (
   ID INTEGER,
   title VARCHAR2(100),
   description VARCHAR2(2000));

INSERT INTO otn_question
     VALUES (1, 'How do I write a loop?'
           , 'What are the different ways I can write a loop in PL/SQL');
INSERT INTO otn_question
     VALUES (2, 'Should I use RAISE_APPLICATION_ERROR?'
           , 'Should I use RAISE? Or pass back status codes?');
COMMIT ;

REM I define a package that contains nothing but a couple of
REM collectoin type definitions.

CREATE OR REPLACE PACKAGE shared_types
IS
   TYPE integers_nt IS TABLE OF INTEGER;

   TYPE otn_questions_nt IS TABLE OF otn_question%ROWTYPE;
END shared_types;
/

REM Now I will use the nested table type as the parameter type
REM in a procedure. 

CREATE OR REPLACE PROCEDURE show_nt (
   my_nt_in   IN   shared_types.otn_questions_nt
)
IS
   l_index   PLS_INTEGER;
BEGIN
   l_index := my_nt_in.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (my_nt_in (l_index).title);
      l_index := my_nt_in.NEXT (l_index);
   END LOOP;
END show_nt;
/

REM Now I declare a local variable based on the nested table type,
REM fill it with a BULK COLLECT query and then call the 
REM procedure to display the contents of the nested table.

DECLARE
   l_questions   shared_types.otn_questions_nt;
BEGIN
   SELECT *
   BULK COLLECT INTO l_questions
     FROM otn_question;

   show_nt (l_questions);
END;
/