CREATE TABLE plch_data
(
   n   NUMBER,
   v   VARCHAR2 (100)
)
/

CREATE OR REPLACE PACKAGE plch_frc
IS
   FUNCTION get_v (n_in IN plch_data.n%TYPE)
      RETURN plch_data.v%TYPE
      RESULT_CACHE;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_frc
IS
   FUNCTION get_v (n_in IN plch_data.n%TYPE)
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

SELECT TO_CHAR (last_ddl_time, 'HH24:MI:SS') last_changed
  FROM user_objects
 WHERE object_name = 'PLCH_FRC' AND object_type = 'PACKAGE BODY'
/

BEGIN
   DBMS_LOCK.sleep (10);
END;
/

/* Exec DDL without changes */

CREATE OR REPLACE PACKAGE BODY plch_frc
IS
   FUNCTION get_v (n_in IN plch_data.n%TYPE)
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

SELECT TO_CHAR (last_ddl_time, 'HH24:MI:SS') last_changed
  FROM user_objects
 WHERE object_name = 'PLCH_FRC' AND object_type = 'PACKAGE BODY'
/

/* Clean up */

DROP PACKAGE plch_frc
/

DROP TABLE plch_data
/