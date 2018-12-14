DROP TABLE explimpl_data
/

CREATE TABLE explimpl_data
(
   n      INTEGER PRIMARY KEY
 , name   VARCHAR2 (100)
)
/

BEGIN
   FOR indx IN 1 .. 100000
   LOOP
      INSERT INTO explimpl_data
      VALUES (indx, 'My name is ' || indx);
   END LOOP;

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE explimpl
AS
   FUNCTION explicit (n_in IN explimpl_data.n%TYPE)
      RETURN explimpl_data%ROWTYPE;

   FUNCTION implicit (n_in IN explimpl_data.n%TYPE)
      RETURN explimpl_data%ROWTYPE;

   FUNCTION explicit_with_conversion (n_in IN explimpl_data.n%TYPE)
      RETURN explimpl_data%ROWTYPE;
END explimpl;
/

CREATE OR REPLACE PACKAGE BODY explimpl
IS
   FUNCTION implicit (n_in IN explimpl_data.n%TYPE)
      RETURN explimpl_data%ROWTYPE
   IS
      onerow_rec   explimpl_data%ROWTYPE;
   BEGIN
      SELECT *
        INTO onerow_rec
        FROM explimpl_data
       WHERE n = n_in;

      RETURN onerow_rec;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN onerow_rec;
   END implicit;

   FUNCTION explicit (n_in IN explimpl_data.n%TYPE)
      RETURN explimpl_data%ROWTYPE
   IS
      CURSOR onerow_cur
      IS
         SELECT *
           FROM explimpl_data
          WHERE n = n_in;

      onerow_rec   explimpl_data%ROWTYPE;
   BEGIN
      OPEN onerow_cur;

      FETCH onerow_cur
        INTO onerow_rec;

      CLOSE onerow_cur;

      RETURN onerow_rec;
   END explicit;

   FUNCTION explicit_with_conversion (n_in IN explimpl_data.n%TYPE)
      RETURN explimpl_data%ROWTYPE
   IS
      CURSOR onerow_cur
      IS
         SELECT *
           FROM explimpl_data
          WHERE n = TO_CHAR (n_in);

      onerow_rec   explimpl_data%ROWTYPE;
   BEGIN
      OPEN onerow_cur;

      FETCH onerow_cur
        INTO onerow_rec;

      CLOSE onerow_cur;

      RETURN onerow_rec;
   END explicit_with_conversion;
END explimpl;
/

CREATE OR REPLACE PROCEDURE compare_explimpl (
   title_in   IN VARCHAR2
 , counter_in IN INTEGER
 , n_in       IN explimpl_data.n%TYPE := 138
)
IS
   emprec   explimpl_data%ROWTYPE;
BEGIN
   DBMS_OUTPUT.put_line ('Compare Explicit and Implicit: ');
   DBMS_OUTPUT.put_line (title_in);
   DBMS_OUTPUT.
    put_line ('Iterations and Primary Key: ' || counter_in || '-' || n_in);
   sf_timer.start_timer;

   FOR i IN 1 .. counter_in
   LOOP
      emprec := explimpl.implicit (n_in);
   END LOOP;

   sf_timer.show_elapsed_time ('Implicit');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter_in
   LOOP
      emprec := explimpl.explicit (n_in);
   END LOOP;

   sf_timer.show_elapsed_time ('Explicit');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter_in
   LOOP
      emprec := explimpl.explicit_with_conversion (n_in);
   END LOOP;

   sf_timer.show_elapsed_time ('Explicit with datatype conversion');
   DBMS_OUTPUT.put_line ('....');
END compare_explimpl;
/

BEGIN
   compare_explimpl ('Many iterations, successful lookup', 100000, 138);
   compare_explimpl ('Many, unsuccessful lookup', 100000, 138980);
END;
/

/* On 11.2

Compare Explicit and Implicit: 
Many iterations, successful lookup
Iterations and Primary Key: 100000-138
Implicit - Elapsed CPU : 4.98 seconds.
Explicit - Elapsed CPU : 5.96 seconds.
Explicit with datatype conversion - Elapsed CPU : 6.29 seconds.

Compare Explicit and Implicit: 
Many, unsuccessful lookup
Iterations and Primary Key: 100000-138980
Implicit - Elapsed CPU : 6.56 seconds.
Explicit - Elapsed CPU : 6.7 seconds.
Explicit with datatype conversion - Elapsed CPU : 7.21 seconds.

*/