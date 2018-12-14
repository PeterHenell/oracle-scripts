drop type living_thing_ot force;
drop type person_ot force;

CREATE OR REPLACE TYPE person_ot
   IS OBJECT 
 (
   NAME    VARCHAR2 (100),
   weight  NUMBER,
   dob     TIMESTAMP (3),
 
   MEMBER FUNCTION age 
      RETURN INTERVAL YEAR TO MONTH
  );
/

CREATE OR REPLACE TYPE BODY person_ot
IS 
   MEMBER FUNCTION age 
      RETURN INTERVAL YEAR TO MONTH
   IS
      retval INTERVAL YEAR TO MONTH;
   BEGIN
      RETURN (SYSDATE - SELF.dob) YEAR TO MONTH;
   END;
END;
/

DECLARE
   steven person_ot :=
      person_ot (
         'Steven', 175, '23-SEP-1958');
BEGIN
   IF steven.age > 
         INTERVAL '18' YEAR 
   THEN
      DBMS_OUTPUT.PUT_LINE (
         'Time for ' || steven.name || 
         ' to get a job!');
   END IF;
END;

