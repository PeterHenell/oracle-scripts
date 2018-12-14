DROP TABLE subjects
/
DROP TYPE subject_t FORCE
/

/* A table containing a subject and its broader term; from the 
   Oracle PL/SQL Programming Fourth Edition chapter on object technology.
   Base example set if a library with books and subjects which those
   books cover. */
   
CREATE OR REPLACE TYPE subject_t AS OBJECT (
   NAME               VARCHAR2 (2000)
 , broader_term_ref   REF subject_t
)
/

/* Define an object table wiht a primary key on the name column and 
   foreign key on the broader_term_ref column. 

   Note: in this simple example, the REF points back to the same table,
   but it can also point to other object tables.   
*/
   
CREATE TABLE subjects OF subject_t
  (CONSTRAINT subject_pk PRIMARY KEY (NAME),
   CONSTRAINT subject_self_ref FOREIGN KEY (broader_term_ref)
      REFERENCES subjects)
/

BEGIN
   INSERT INTO subjects
        VALUES (subject_t ('Computer file', NULL));

   INSERT INTO subjects
        VALUES (subject_t ('Computer program language', NULL));

   INSERT INTO subjects
        VALUES (subject_t ('Relational databases', NULL));

   INSERT INTO subjects
        VALUES (subject_t ('Oracle', (SELECT REF (s)
                                        FROM subjects s
                                       WHERE NAME = 'Computer file')));

   INSERT INTO subjects
        VALUES (subject_t ('PL/SQL'
                         , (SELECT REF (s)
                              FROM subjects s
                             WHERE NAME = 'Computer program language')
                          ));

   COMMIT;
END;
/

/* Not very interesting hex values.... */

SELECT VALUE (s)
  FROM subjects s
/

/* Much more interesting: I take the REF, "dereference" it to the object,
   and display the name. */
   
SELECT s.NAME, DEREF (s.broader_term_ref).NAME bt
  FROM subjects s
/

/* I can also now drop the DEREF function; Oracle will automatically do it for me */

SELECT s.name, s.broader_term_ref.name bt FROM subjects s
/

/*
REF-based navigation in the WHERE clause....
*/

SELECT VALUE(s).name FROM subjects s
 WHERE s.broader_term_ref.name = 'Computer program language'
/ 