CREATE OR REPLACE FUNCTION grade_translator (
   grade_in   IN   VARCHAR2
 , step_in    IN   VARCHAR2
)
   RETURN VARCHAR2
IS
   retval   VARCHAR2 (100);
BEGIN
   CASE
      WHEN grade_in = 'A'
      THEN
         retval := 'Excellent';
      WHEN grade_in = 'B'
      THEN
         retval := 'Very Good';
      WHEN grade_in = 'C'
      THEN
         retval := 'Good';
      WHEN grade_in = 'D'
      THEN
         retval := 'Fair';
      WHEN grade_in = 'F'
      THEN
         retval :=
                 CASE step_in
                    WHEN 1
                       THEN 'a'
                    WHEN 2
                       THEN 'b'
                    WHEN 3
                       THEN 'c'
                 END;
      ELSE
         IF step_in > 10
         THEN
            retval := 'No such grade';
         ELSE
            retval := 'abc';
         END IF;
   END CASE;

   RETURN retval;
END;
/