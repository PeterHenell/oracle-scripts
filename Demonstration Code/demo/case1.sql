/* Using IF */

CREATE OR REPLACE FUNCTION grade_translator (grade_in IN VARCHAR2)
   RETURN VARCHAR2
IS
   retval   VARCHAR2 (100);
BEGIN
   IF grade_in = 'A'
   THEN
      retval := 'Excellent';
   ELSIF grade_in = 'B'
   THEN
      retval := 'Very Good';
   ELSIF grade_in = 'C'
   THEN
      retval := 'Good';
   ELSIF grade_in = 'D'
   THEN
      retval := 'Fair';
   ELSIF grade_in = 'F'
   THEN
      retval := 'Poor';
   ELSE
      retval := 'No such grade';
   END IF;

   RETURN retval;
END;
/

/* Searched CASE statement */

CREATE OR REPLACE FUNCTION grade_translator (grade_in IN VARCHAR2)
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
         retval := 'Poor';
      ELSE
         retval := 'No such grade';
   END CASE;

   RETURN retval;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (grade_translator ('A'));
END;
/

/* Simple CASE expression */

CREATE OR REPLACE FUNCTION grade_translator (grade_in IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE grade_in
             WHEN 'A' THEN 'Excellent'
             WHEN 'B' THEN 'Very Good'
             WHEN 'C' THEN 'Good'
             WHEN 'D' THEN 'Fair'
             WHEN 'F' THEN 'Poor'
             ELSE 'No such grade'
          END;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (grade_translator ('A'));
END;
/

DECLARE -- Example of CASE searched expression
   cant_play_now   BOOLEAN;
   how_young INTERVAL YEAR TO MONTH
         := (SYSDATE - TO_DATE ('09-23-1958', 'MM-DD-YYYY')) YEAR TO MONTH;
   max_age         CONSTANT INTERVAL YEAR TO MONTH := INTERVAL '16' YEAR;
   min_age         CONSTANT INTERVAL YEAR TO MONTH := INTERVAL '70' YEAR;
BEGIN
   -- Notice: no semi-colons between WHEN clauses.
   cant_play_now :=
      CASE
         WHEN how_young < min_age THEN FALSE
         WHEN how_young > max_age THEN FALSE
         ELSE TRUE
      END;

   IF cant_play_now
   THEN
      must_go_to_work;
   END IF;
END;