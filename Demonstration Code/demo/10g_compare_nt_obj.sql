/* Comparison conditions:
   http://download.oracle.com/docs/cd/E11882_01/server.112/e17118/conditions002.htm#i1033286
*/
   
DROP TYPE vet_visit_t FORCE
/

DROP TYPE vet_visits_t FORCE
/

CREATE TYPE vet_visit_t IS OBJECT
       (visit_date DATE
      , reason VARCHAR2 (100)
      , MAP MEMBER FUNCTION visit_map
           RETURN INTEGER);
/

CREATE OR REPLACE TYPE BODY vet_visit_t
IS
   MAP MEMBER FUNCTION visit_map
      RETURN INTEGER
   IS
   BEGIN
      RETURN CASE
                WHEN self.visit_date < SYSDATE - 10 THEN 100
                WHEN self.visit_date < SYSDATE THEN 10
                ELSE 1
             END;
   END;
END;
/

CREATE OR REPLACE TYPE vet_visits_t IS TABLE OF vet_visit_t
/

DECLARE
   mercury_visits   vet_visits_t
      := vet_visits_t (vet_visit_t (SYSDATE - 20, 'Clip wings')
                     , vet_visit_t (SYSDATE - 5, 'Check cholesterol'));
   moshe_visits     vet_visits_t
                       := vet_visits_t (vet_visit_t (SYSDATE, 'Overweight'));
   moshe2_visits    vet_visits_t
                       := vet_visits_t (vet_visit_t (SYSDATE, 'Overweight'));
BEGIN
   IF mercury_visits = moshe_visits
   THEN
      DBMS_OUTPUT.put_line ('Same visits!');
   ELSE
      DBMS_OUTPUT.put_line ('Different visits!');
   END IF;

   IF moshe_visits = moshe2_visits
   THEN
      DBMS_OUTPUT.put_line ('Same visits!');
   ELSE
      DBMS_OUTPUT.put_line ('Different visits!');
   END IF;
END;
/