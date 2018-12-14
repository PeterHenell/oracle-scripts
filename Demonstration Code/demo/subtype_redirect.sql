connect hr/hr

CREATE OR REPLACE PACKAGE hr_type
IS
   SUBTYPE hr_n_t IS NUMBER;
END;
/

CREATE PUBLIC SYNONYM hr_type FOR hr.hr_type
/

GRANT EXECUTE ON hr_type TO scott
/
connect scott/tiger

CREATE OR REPLACE PACKAGE scott_type
IS
   SUBTYPE scott_n_t IS hr_type.hr_n_t;

   PROCEDURE use_type (n_in IN scott_n_t);
END;
/

CREATE OR REPLACE PACKAGE BODY scott_type
IS
   PROCEDURE use_type (n_in IN scott_n_t)
   IS
      n   scott_n_t;
   BEGIN
      n := n_in;
   END;
END;
/