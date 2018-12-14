DROP TYPE numbers_t FORCE
/

CREATE OR REPLACE TYPE numbers_t IS TABLE OF NUMBER
/

CREATE OR REPLACE TYPE num_numbers_t IS TABLE OF numbers_t
/

DECLARE
   n1   num_numbers_t := num_numbers_t (numbers_t (1), numbers_t (2));
   n2   num_numbers_t := num_numbers_t (numbers_t (1), numbers_t (2));
   n3   num_numbers_t := num_numbers_t ();
BEGIN
   IF n1 = n2
   THEN
      DBMS_OUTPUT.put_line ('=');
   END IF;

   IF n1 <> n3
   THEN
      DBMS_OUTPUT.put_line ('<>');
   END IF;

   n3 := n1 MULTISET UNION n2;
   n3 := n1 MULTISET INTERSECT n2;
   n3 := n1 MULTISET EXCEPT n2;
END;
/