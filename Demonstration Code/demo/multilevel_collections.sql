DROP TYPE pet_t FORCE;
DROP TYPE vet_visit_t FORCE;
DROP TYPE vet_visit_lists_t FORCE;

CREATE TYPE vet_visit_t IS OBJECT
(
   visit_date DATE
 ,  reason VARCHAR2 (100)
);
/

CREATE TYPE vet_visit_lists_t IS TABLE OF vet_visit_t
/

CREATE TYPE pet_t IS OBJECT
(
   tag_no INTEGER
 ,  name VARCHAR2 (60)
 ,  breed VARCHAR2 (100)
 ,  petcare vet_visit_lists_t
);
/

DECLARE
   TYPE bunch_of_pets_t IS TABLE OF pet_t
                              INDEX BY PLS_INTEGER;

   my_pets        bunch_of_pets_t;
   l_first_pet    pet_t;
   l_last_visit   vet_visit_t;
BEGIN
   my_pets (1) :=
      pet_t (
         100
       ,  'Mercury'
       ,  'African Grey Parrot'
       ,  vet_visit_lists_t (
             vet_visit_t ('01-Jan-2001', 'Clip wings')
           ,  vet_visit_t ('01-Apr-2002'
                         ,  'Check cholesterol')));
   DBMS_OUTPUT.put_line (my_pets (my_pets.FIRST).name);
   
   DBMS_OUTPUT.put_line (
      my_pets (my_pets.FIRST).petcare (
         my_pets (my_pets.FIRST).petcare.LAST).reason);
         
   DBMS_OUTPUT.put_line (my_pets.COUNT);
   DBMS_OUTPUT.put_line (
      my_pets (my_pets.FIRST).petcare.FIRST);
   --
   -- Hiding the details
   --
   l_first_pet := my_pets (my_pets.FIRST);
   l_last_visit :=
      l_first_pet.petcare (l_first_pet.petcare.LAST);
   DBMS_OUTPUT.put_line (l_last_visit.reason);
END;
/