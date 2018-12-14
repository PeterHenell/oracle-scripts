/*
Remove all rooms specified by the (possibly wildcarded) name.

If the name is NULL, raise an error.

Note that removal of room contents does NOT cascade.
*/

CREATE OR REPLACE PROCEDURE remove_rooms_by_name (
   NAME_IN IN rooms.NAME%TYPE)
IS
BEGIN
   IF NAME_IN IS NULL
   THEN
      RAISE PROGRAM_ERROR;
   END IF;

   DELETE FROM rooms WHERE NAME LIKE NAME_IN;
   
END remove_rooms_by_name;
/