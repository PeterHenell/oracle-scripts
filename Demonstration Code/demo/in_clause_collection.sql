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

CREATE OR REPLACE TYPE integers_nt IS TABLE OF INTEGER;
/

CREATE OR REPLACE FUNCTION in_otn_question_cv (list_in IN integers_nt)
   RETURN sys_refcursor
IS
   retval   sys_refcursor;
BEGIN
   OPEN retval FOR
      SELECT *
        FROM otn_question
       WHERE ID IN (SELECT column_value
                      FROM TABLE (CAST (list_in AS integers_nt)));

   RETURN retval;
END in_otn_question_cv;
/

DECLARE
   l_ids         integers_nt             := integers_nt (1, 3);
   l_questions   sys_refcursor;
   l_one         otn_question%ROWTYPE;
BEGIN
   DBMS_OUTPUT.put_line ('Using CAST of Nested table');
   l_questions := in_otn_question_cv (l_ids);

   LOOP
      FETCH l_questions
       INTO l_one;

      EXIT WHEN l_questions%NOTFOUND;
      DBMS_OUTPUT.put_line (l_one.title);
   END LOOP;
END;
/

REM Or using new SQL MEMBER OF syntax...

CREATE OR REPLACE FUNCTION in_otn_question_cv (list_in IN integers_nt)
   RETURN sys_refcursor
IS
   retval   sys_refcursor;
BEGIN
   OPEN retval FOR
      SELECT *
        FROM otn_question
       WHERE id MEMBER OF list_in;

   RETURN retval;
END in_otn_question_cv;
/

DECLARE
   l_ids         integers_nt             := integers_nt (1, 3);
   l_questions   sys_refcursor;
   l_one         otn_question%ROWTYPE;
BEGIN
   DBMS_OUTPUT.put_line ('Using MEMBER OF...');
   l_questions := in_otn_question_cv (l_ids);

   LOOP
      FETCH l_questions
       INTO l_one;

      EXIT WHEN l_questions%NOTFOUND;
      DBMS_OUTPUT.put_line (l_one.title);
   END LOOP;
END;
/
