CREATE OR REPLACE PACKAGE refcur
IS
   TYPE refcur_t IS REF CURSOR;

   PROCEDURE closecv (cv_in IN refcur_t);
   
   PROCEDURE testit;
   
END;
/
CREATE OR REPLACE PACKAGE BODY refcur
IS
   PROCEDURE closecv (cv_in IN refcur_t)
   IS
   BEGIN
      CLOSE cv_in;
   END;

   PROCEDURE testit
   IS
      cv refcur_t;
   BEGIN
      OPEN cv FOR
         SELECT *
           FROM employee;
      closecv (cv);
   END;
END;
/      
