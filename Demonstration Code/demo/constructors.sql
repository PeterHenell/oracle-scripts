DROP TYPE plch_persons_nt FORCE
/

DROP TYPE plch_numbers_nt FORCE
/

DROP TYPE plch_person_ot FORCE
/

CREATE OR REPLACE TYPE plch_numbers_nt IS TABLE OF NUMBER
/

CREATE TYPE plch_person_ot IS OBJECT
       (name VARCHAR2 (100), favorite_numbers plch_numbers_nt)
/

CREATE OR REPLACE TYPE plch_persons_nt IS TABLE OF plch_person_ot
/

DECLARE
   l_numbers   plch_numbers_nt := plch_numbers_nt ();
   l_person1   plch_person_ot := plch_person_ot ();
   l_person2   plch_person_ot := plch_person_ot ();
   l_persons   plch_persons_nt := plch_persons_nt ();
BEGIN
   l_person1.name := 'Benjamin Franklin';
   l_person1.favorite_numbers := l_numbers;
   l_person2.name := 'George Washington';
   l_person2.favorite_numbers := '2,47';
   l_persons := plch_persons_nt (l_person1, l_person2);

   DBMS_OUTPUT.put_line (l_persons.COUNT);
END;
/

DECLARE
   l_numbers   plch_numbers_nt := plch_numbers_nt ();
   l_person1   plch_person_ot
                  := plch_person_ot ('Benjamin Franklin', l_numbers);
   l_person2   plch_person_ot
                  := plch_person_ot ('George Washington', '2,47');
   l_persons   plch_persons_nt
                  := plch_persons_nt (l_person1, l_person2);
BEGIN
   DBMS_OUTPUT.put_line (l_persons.COUNT);
END;
/

DECLARE
   l_numbers   plch_numbers_nt := plch_numbers_nt (7, 22);
   l_person1   plch_person_ot
      := plch_person_ot ('Benjamin Franklin', l_numbers);
   l_person2   plch_person_ot
      := plch_person_ot ('George Washington'
                       , plch_numbers_nt (2, 47));
   l_persons   plch_persons_nt
                  := plch_persons_nt (l_person1, l_person2);
BEGIN
   DBMS_OUTPUT.put_line (l_persons.COUNT);
END;
/

DECLARE
   l_persons   plch_persons_nt
      := plch_persons_nt (
            plch_person_ot ('Benjamin Franklin'
                          , plch_numbers_nt (7, 22))
          , plch_person_ot ('George Washington'
                          , plch_numbers_nt (2, 47)));
BEGIN
   DBMS_OUTPUT.put_line (l_persons.COUNT);
END;
/