CREATE OR REPLACE TYPE parts_ot IS OBJECT (
   ID NUMBER
 , name VARCHAR2 ( 100 )
 , part_type VARCHAR2 ( 100 )
);
/

CREATE OR REPLACE TYPE parts_nt AS TABLE OF parts_ot;
/

CREATE OR REPLACE FUNCTION parts_function
   RETURN parts_nt
IS
   l_part parts_ot := parts_ot ( NULL, NULL, NULL );
   retval parts_nt := parts_nt ( NULL, NULL, NULL );
BEGIN
   retval.EXTEND ( 3 );
   l_part.ID := 100;
   l_part.name := 'Gidget';
   l_part.part_type := 'FLIBBER';
   retval ( 1 ) := l_part;
   l_part.ID := 200;
   l_part.name := 'Gadget';
   l_part.part_type := 'FLUBBER';
   retval ( 2 ) := l_part;
   l_part.ID := 300;
   l_part.name := 'Arcwater';
   l_part.part_type := 'FLUBBER';
   retval ( 3 ) := l_part;
   RETURN retval;
END parts_function;
/

SELECT   part_type, COUNT ( * )
    FROM TABLE ( parts_function )
GROUP BY part_type
/
