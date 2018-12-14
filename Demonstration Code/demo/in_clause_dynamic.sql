DROP TABLE otn_question;

CREATE TABLE otn_question (
   ID INTEGER,
   title VARCHAR2(100),
   description VARCHAR2(2000));

INSERT INTO otn_question
     VALUES (1, 'How do I write a loop?'
           , 'What are the different ways I can write a loop in PL/SQL');

INSERT INTO otn_question
     VALUES (2, 'Use cursor FOR loop?'
           , 'Is there a reason any longer to use a cursor FOR loop, since I can now use BULK COLLECT?');

INSERT INTO otn_question
     VALUES (3, 'Which version of PL/SQL is best?'
           , 'What is the best version of PL/SQL?');

COMMIT ;

CREATE OR REPLACE FUNCTION in_otn_question_cv (list_in IN VARCHAR2)
   RETURN sys_refcursor
IS
   retval   sys_refcursor;
BEGIN
   OPEN retval FOR    'SELECT * FROM otn_question
          WHERE id IN ('
                   || list_in
                   || ')';

   RETURN retval;
END in_otn_question_cv;
/

DECLARE
   l_questions   sys_refcursor;
   l_one         otn_question%ROWTYPE;
BEGIN
   l_questions := in_otn_question_cv ('1,3');

   LOOP
      FETCH l_questions
       INTO l_one;

      EXIT WHEN l_questions%NOTFOUND;
      DBMS_OUTPUT.put_line (l_one.title);
   END LOOP;
END;
/

REM Or with BULK COLLECT in Oracle9i Release 2 and above....

CREATE OR REPLACE PACKAGE dyn_in
IS
   TYPE question_aat IS TABLE OF otn_question%ROWTYPE
      INDEX BY PLS_INTEGER;

   FUNCTION in_otn_question (list_in IN VARCHAR2)
      RETURN question_aat;
END dyn_in;
/

CREATE OR REPLACE PACKAGE BODY dyn_in
IS
   FUNCTION in_otn_question (list_in IN VARCHAR2)
      RETURN question_aat
   IS
      retval   question_aat;
   BEGIN
      EXECUTE IMMEDIATE    'SELECT * FROM otn_question
          WHERE id IN ('
                        || list_in
                        || ')'
      BULK COLLECT INTO retval;

      RETURN retval;
   END in_otn_question;
END dyn_in;
/

DECLARE
   l_array   dyn_in.question_aat;
   l_row     PLS_INTEGER;
BEGIN
   l_array := dyn_in.in_otn_question ('1,3');
   l_row := l_array.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (l_array (l_row).title);
      l_row := l_array.NEXT (l_row);
   END LOOP;
END;
/

REM Demonstration of max of 1000 elements in list.

CREATE OR REPLACE FUNCTION in_otn_question_cv (
   list_in   IN   VARCHAR2
 , size_in   IN   PLS_INTEGER DEFAULT 11
)
   RETURN sys_refcursor
IS
   l_list VARCHAR2(32767);
   retval   sys_refcursor;
BEGIN
   l_list := RPAD (list_in, size_in, ',1');
   OPEN retval FOR    'SELECT * FROM otn_question
          WHERE id IN ('
                   || l_list
                   || ')';

   RETURN retval;
END in_otn_question_cv;
/

DECLARE
   l_questions   sys_refcursor;
   l_one         otn_question%ROWTYPE;
BEGIN
   l_questions := in_otn_question_cv ('1', 2001); 

   LOOP
      FETCH l_questions
       INTO l_one;

      EXIT WHEN l_questions%NOTFOUND;
      DBMS_OUTPUT.put_line (l_one.title);
   END LOOP;
END;
/