CREATE TABLE plch_data (
   n NUMBER, v VARCHAR2(100))
/

BEGIN
   INSERT INTO plch_data VALUES (1, 'Joy');
   COMMIT;
END;
/      

CREATE OR REPLACE PACKAGE plch_frc
IS
   FUNCTION get_v (
      n_in   IN plch_data.n%TYPE)
      RETURN plch_data.v%TYPE
      RESULT_CACHE;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_frc
IS
   FUNCTION get_v (
      n_in   IN plch_data.n%TYPE)
      RETURN plch_data.v%TYPE
      RESULT_CACHE
   IS
      onerow_rec   plch_data%ROWTYPE;
   BEGIN
      DBMS_OUTPUT.put_line ('EXECUTED BODY OF FUNCTION');

      SELECT *
        INTO onerow_rec
        FROM plch_data
       WHERE n = n_in;

      RETURN onerow_rec.v;
   END;
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Package Created');

   DBMS_OUTPUT.put_line (plch_frc.get_v (1));
END;
/

ALTER PACKAGE plch_frc COMPILE
/

BEGIN
   DBMS_OUTPUT.put_line ('ALTER PACKAGE plch_frc COMPILE');

   DBMS_OUTPUT.put_line (plch_frc.get_v (1));
END;
/

ALTER PACKAGE plch_frc COMPILE REUSE SETTINGS
/

BEGIN
   DBMS_OUTPUT.put_line ('ALTER PACKAGE plch_frc COMPILE REUSE SETTINGS');

   DBMS_OUTPUT.put_line (plch_frc.get_v (1));
END;
/

/* Exec DDL without changes */

CREATE OR REPLACE PACKAGE BODY plch_frc
IS
   FUNCTION get_v (
      n_in   IN plch_data.n%TYPE)
      RETURN plch_data.v%TYPE
      RESULT_CACHE
   IS
      onerow_rec   plch_data%ROWTYPE;
   BEGIN
      DBMS_OUTPUT.put_line ('EXECUTED BODY OF FUNCTION');

      SELECT *
        INTO onerow_rec
        FROM plch_data
       WHERE n = n_in;

      RETURN onerow_rec.v;
   END;
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Exec DDL with no changes');

   DBMS_OUTPUT.put_line (plch_frc.get_v (1));
END;
/

/* Exec DDL with minor changes */

CREATE OR REPLACE PACKAGE BODY plch_frc IS
   FUNCTION get_v (n_in   IN plch_data.n%TYPE)
      RETURN plch_data.v%TYPE RESULT_CACHE IS
      onerow_rec plch_data%ROWTYPE;
   BEGIN
      DBMS_OUTPUT.put_line ('EXECUTED BODY OF FUNCTION');
      SELECT * INTO onerow_rec
        FROM plch_data WHERE n = n_in;
      RETURN onerow_rec.v;
   END;
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Exec DDL with changes');

   DBMS_OUTPUT.put_line (plch_frc.get_v (1));
END;
/

/* Clean up */

DROP PACKAGE plch_frc
/

DROP TABLE plch_data
/
