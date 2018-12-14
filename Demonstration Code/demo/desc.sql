
CREATE TYPE numtab IS TABLE OF NUMBER;
/

CREATE TYPE datearray IS VARRAY (10) OF DATE;
/

CREATE TYPE hiredatetab IS TABLE OF DATE;
/

CREATE TYPE obj_t AS OBJECT
(
   starttime INTEGER,
   endtime INTEGER,
   repetitions INTEGER,
   name VARCHAR2 (2000),
   srcinfo numtab
);
/

SHO ERR

CREATE OR REPLACE PACKAGE desctest
IS
   TYPE aa_rowtype IS TABLE OF employees%ROWTYPE
                         INDEX BY VARCHAR2 (200);

   TYPE aa_type IS TABLE OF employees%ROWTYPE
                      INDEX BY employees.last_name%TYPE;

   -- SEQUENCE 0 ARGUMENT_NAME NULL
   PROCEDURE prog1;

   PROCEDURE prog2 (arg1    IN VARCHAR2 DEFAULT 'ABC',
                    arg2    IN DATE DEFAULT SYSDATE,
                    blob1   IN BLOB);

   PROCEDURE prog2 (arg1   IN VARCHAR2,
                    arg2   IN INTEGER,
                    arg3      all_objects%ROWTYPE);

   PROCEDURE prog3 (arg1   IN OUT numtab,
                    arg2      OUT datearray,
                    arg3          obj_t,
                    arg4   IN     aa_rowtype,
                    arg5   IN     aa_type);

   -- RETURN datatype: argument_name null, position 0
   FUNCTION func1
      RETURN INTEGER;

   FUNCTION func2 (arg1 IN INTEGER)
      RETURN BOOLEAN;

   FUNCTION func2 (arg1 IN DATE, arg2 IN NUMBER)
      RETURN all_objects%ROWTYPE;

   FUNCTION func3
      RETURN obj_t;

   FUNCTION func4
      RETURN hiredatetab;

   FUNCTION func5
      RETURN aa_type;
END;
/

DECLARE
   /* PL/SQL tables which will hold the output from calls to
      DBMS_DESCRIBE.DESCRIBE_PROCEDURE */
   g_overload         DBMS_DESCRIBE.number_table;
   g_position         DBMS_DESCRIBE.number_table;
   g_level            DBMS_DESCRIBE.number_table;
   g_argument_name    DBMS_DESCRIBE.varchar2_table;
   g_datatype         DBMS_DESCRIBE.number_table;
   g_default_value    DBMS_DESCRIBE.number_table;
   g_in_out           DBMS_DESCRIBE.number_table;
   g_length           DBMS_DESCRIBE.number_table;
   g_precision        DBMS_DESCRIBE.number_table;
   g_scale            DBMS_DESCRIBE.number_table;
   g_radix            DBMS_DESCRIBE.number_table;
   g_spare            DBMS_DESCRIBE.number_table;
   g_object_name      VARCHAR2 (200);
   c_delim   CONSTANT CHAR (1) := CHR (8);

   PROCEDURE args (obj IN VARCHAR2)
   IS
   BEGIN
      g_object_name := obj;

      DBMS_DESCRIBE.describe_procedure (obj,
                                        NULL,
                                        NULL,
                                        g_overload,
                                        g_position,
                                        g_level,
                                        g_argument_name,
                                        g_datatype,
                                        g_default_value,
                                        g_in_out,
                                        g_length,
                                        g_precision,
                                        g_scale,
                                        g_radix,
                                        g_spare);
   END;

   PROCEDURE show_one (prog_in IN VARCHAR2)
   IS
   BEGIN
      args ('DESCTEST.' || prog_in);

      DBMS_OUTPUT.put_line ('DESC info for ' || prog_in);
      DBMS_OUTPUT.put_line (
         '   Ovld-Pos-Name-NType-VType-Default for ' || prog_in);

      FOR indx IN 1 .. g_overload.COUNT
      LOOP
         IF g_level (indx) = 0
         THEN
            DBMS_OUTPUT.put_line (
                  '   '
               || g_overload (indx)
               || '-'
               || g_position (indx)
               || '-'
               || g_argument_name (indx)
               || '-'
               || g_datatype (indx)
               || '-DEFAULT:'
               || g_default_value (indx));
         END IF;
      END LOOP;
   END;
BEGIN
   FOR rec
      IN (SELECT *
            FROM all_procedures ap
           WHERE     ap.owner = USER
                 AND ap.object_name = 'DESCTEST'
                 AND procedure_name IS NOT NULL)
   LOOP
      show_one (rec.procedure_name);
   END LOOP;
END;
/

/* Clean up */

--DROP TYPE numtab FORCE;
--
--DROP TYPE datearray FORCE;
--
--DROP TYPE hiredatetab FORCE;
--
--DROP TYPE obj_t FORCE;
