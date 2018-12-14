/* Used in 2010 q3 playoff */

-- $REVISION $1.0 $

/* Create a new question */

DECLARE
   l_question_id   INTEGER;
   l_quiz_id       INTEGER;
   
   l_parent   INTEGER := 187;
   tid        INTEGER;
   l2         INTEGER;

   PROCEDURE ins (t        VARCHAR2
                , p        INTEGER
                , s        INTEGER
                , pk   OUT INTEGER)
   IS
      l   INTEGER;
   BEGIN
      qdb_topics_cp.ins (topic_id_out         => l
                       , domain_id_in         => 1
                       , text_in              => t
                       , parent_topic_id_in   => p
                       , sibling_pos_in       => s);
      DBMS_OUTPUT.put_line (t || ' = ' || l);
      pk := l;
   END;

   PROCEDURE ins (t VARCHAR2, p INTEGER, s INTEGER DEFAULT 1)
   IS
      l   INTEGER;
   BEGIN
      ins (t
         , p
         , s
         , l);
   END;
BEGIN
ins ('INDEX BY Clause with %TYPE Against INTEGER Column', 1375, 1, tid);
   qdb_questions_cp.
    ins (
      question_id_out          => l_question_id
    , topic_id_in              => tid                             /* TITLE */
    , difficulty_id_in         => 4                          /* 2 B 3 I 4 A */
    , category_id_in           => 1
    , question_type_id_in      => 2
    , override_version_in => NULL    
    , question_in              => '
<p>
I create and populate the following table:
</p>
<pre>
DROP TABLE plch_parts
/

CREATE TABLE plch_parts
(
   partnum    INTEGER
 , partname   VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (1, ''Mouse'');

   INSERT INTO plch_parts
        VALUES (100, ''Keyboard'');

   INSERT INTO plch_parts
        VALUES (500, ''Monitor'');

   COMMIT;
END;
/
</pre>
<p>
Which choices shows text that will be displayed on the screen when I run the following
block?
</p>
<pre>
DECLARE
   TYPE names_by_partnum_t IS 
           TABLE OF plch_parts.partname%TYPE
           INDEX BY plch_parts.partnum%TYPE;

   l_names   names_by_partnum_t;
BEGIN
   SELECT partname
     BULK COLLECT INTO l_names
     FROM plch_parts;

   DBMS_OUTPUT.put_line (''Count = '' || l_names.COUNT);
EXCEPTION 
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_ERROR_STACK);   
END;
/
</pre>'
    , answer_in                => '<p>You can index an associative array by either
integers or strings. But integer values are constrained to the range specified by
the BINARY_INTEGER datatype: from -2147483647 to 2147483647. The range of values
allowed for a SQL INTEGER column is, however, far larger. It is, therefore, not
acceptable as the datatype for the index of an associative array. If you try to INDEX BY
a datatype specified through %TYPE on an INTEGER column, Oracle will raise the 
"PLS-00315: Implementation restriction: unsupported table index type" error.
</p>
<p>
Note that this is a PL/SQL compile-time error (all PLS errors are), so the exception section
cannot trap this error and display a message.
</p>
<p>
Here is the code I used to check my answers:
</p>
<pre>
DROP TABLE plch_parts
/

CREATE TABLE plch_parts
(
   partnum    INTEGER
 , partname   VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (1, ''Mouse'');

   INSERT INTO plch_parts
        VALUES (100, ''Keyboard'');

   INSERT INTO plch_parts
        VALUES (500, ''Monitor'');

   COMMIT;
END;
/

DECLARE
   TYPE names_by_partnum_t IS TABLE OF plch_parts.partname%TYPE
                                 INDEX BY plch_parts.partnum%TYPE;

   l_names   names_by_partnum_t;
BEGIN
   SELECT partname
     BULK COLLECT INTO l_names
     FROM plch_parts;

   DBMS_OUTPUT.put_line (''Count = '' || l_names.COUNT);
EXCEPTION 
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_ERROR_STACK);
END;
/

/* Same error with explicit INTEGER type */

DECLARE
   TYPE names_by_partnum_t IS TABLE OF plch_parts.partname%TYPE
                                 INDEX BY INTEGER;

   l_names   names_by_partnum_t;
BEGIN
   SELECT partname
     BULK COLLECT INTO l_names
     FROM plch_parts;

   DBMS_OUTPUT.put_line (l_names.COUNT);
END;
/
</pre>'
    , expected_minutes_in      => 2
    , approved_in              => 'Y'
    , approved_by_user_id_in   => 5);
   DBMS_OUTPUT.put_line ('Question ID = ' || l_question_id);
   qdb_mc_options_cp.ins (question_id_in   => l_question_id
                        , text_in          => '<pre>PLS-00315: Implementation restriction: unsupported table index type</pre>'
                        , explanation_in   => ''
                        , is_correct_in    => 'Y'
                        , option_pos_in    => 1);
   qdb_mc_options_cp.ins (question_id_in   => l_question_id
                        , text_in          => '<pre>ORA-06502: PL/SQL: numeric or value error</pre>'
                        , explanation_in   => ''
                        , is_correct_in    => 'N'
                        , option_pos_in    => 2);
   qdb_mc_options_cp.ins (question_id_in   => l_question_id
                        , text_in          => '<pre>ORA-06501: PL/SQL: program error</pre>'
                        , explanation_in   => ''
                        , is_correct_in    => 'N'
                        , option_pos_in    => 3);
   qdb_mc_options_cp.ins (question_id_in   => l_question_id
                        , text_in          => '<pre>Count = 3</pre>'
                        , explanation_in   => ''
                        , is_correct_in    => 'N'
                        , option_pos_in    => 4);

   COMMIT;
END;
/