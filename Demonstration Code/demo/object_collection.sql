drop type bird_t;
drop type pet_t;


/* Formatted on 2001/12/28 15:35 (Formatter Plus v4.5.2) */
CREATE TYPE pet_t IS OBJECT (
   tag_no                        INTEGER,
   NAME                          VARCHAR2 (60),
   MEMBER FUNCTION set_tag_no (new_tag_no IN INTEGER)
      RETURN pet_t)
   NOT FINAL;
/

CREATE TYPE BODY Pet_t 
AS
   MEMBER FUNCTION set_tag_no (new_tag_no IN INTEGER) RETURN Pet_t 
   IS
      the_pet Pet_t := SELF;  -- initialize to "current" object
   BEGIN
      the_pet.tag_no := new_tag_no;
      RETURN the_pet;
   END;
END;
/

create type bird_t under pet_t (
   wingspan number);
/

/* Formatted on 2001/12/28 15:35 (Formatter Plus v4.5.2) */
DECLARE
   TYPE pets_t IS TABLE OF pet_t;

   pets   pets_t
   := pets_t (
         pet_t (1050, 'Sammy'),
         bird_t (1075, 'Mercury', 14)
      );
BEGIN
   FOR indx IN pets.FIRST .. pets.LAST
   LOOP
      DBMS_OUTPUT.put_line (pets (indx).NAME);
   END LOOP;
END;
/
  
