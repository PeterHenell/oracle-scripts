CREATE OR REPLACE PROCEDURE adjust_ratings (gender_in IN VARCHAR2)
IS
BEGIN
   /* Execute many queries and DML statements. */
   --COMMIT;
   my_commit.perform_commit ('Complete adjustment of ratings.');
END adjust_ratings;
/

/* Test Script */

BEGIN
   my_commit.turn_off ();
   adjust_ratings ('MALE');
   ROLLBACK;
END;
/