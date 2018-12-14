CREATE TABLE plch_parts
(
   partnum     INTEGER PRIMARY KEY,
   partname    VARCHAR2 (100) UNIQUE,
   partgroup   VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (1, 'Mouse', 'External');

   INSERT INTO plch_parts
        VALUES (2, 'CPU', 'Internal');

   INSERT INTO plch_parts
        VALUES (3, 'Modem', 'Internal');

   COMMIT;
END;
/

/* FOR UPDATE cannot be used with DISTINCT:

ORA-01786: FOR UPDATE of this query expression is not allowed

*/

CREATE OR REPLACE PROCEDURE plch_update_parts
IS
   l_name   plch_parts.partname%TYPE;
BEGIN
   FOR rec IN (SELECT DISTINCT partgroup
                 FROM plch_parts
                WHERE partgroup LIKE 'Int%'
               FOR UPDATE)
   LOOP
      UPDATE plch_parts
         SET partname = UPPER (partname)
       WHERE partgroup = rec.partgroup;

      DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   END LOOP;
END;
/

BEGIN
   plch_update_parts ();
END;
/

/* FOR UPDATE cannot be used with MIN:

ORA-01786: FOR UPDATE of this query expression is not allowed

*/

CREATE OR REPLACE PROCEDURE plch_update_parts
IS
   l_name   plch_parts.partname%TYPE;
BEGIN
   FOR rec IN (SELECT MIN (partgroup)
                 FROM plch_parts
                WHERE partgroup LIKE 'Int%'
               FOR UPDATE)
   LOOP
      UPDATE plch_parts
         SET partname = UPPER (partname)
       WHERE partgroup = rec.partgroup;

      DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   END LOOP;
END;
/

BEGIN
   plch_update_parts ();
END;
/

/* FOR UPDATE is fine when fetching individual rows */

CREATE OR REPLACE PROCEDURE plch_update_parts
IS
   l_name   plch_parts.partname%TYPE;
BEGIN
   FOR rec IN (SELECT partgroup
                 FROM plch_parts
                WHERE partgroup LIKE 'Int%' AND ROWNUM < 2
               FOR UPDATE)
   LOOP
      UPDATE plch_parts
         SET partname = UPPER (partname)
       WHERE partgroup = rec.partgroup;

      DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   END LOOP;
END;
/

BEGIN
   plch_update_parts ();
END;
/

/* "Hide" the DISTINCT to avoid ORA-01736, but then get this at runtime:

ORA-02014: cannot select FOR UPDATE from view with DISTINCT, GROUP BY, etc.

 */

CREATE OR REPLACE PROCEDURE plch_update_parts
IS
   l_name   plch_parts.partname%TYPE;
BEGIN
   FOR rec IN (SELECT *
                 FROM (SELECT DISTINCT partgroup
                         FROM plch_parts
                        WHERE partgroup LIKE 'Int%')
               FOR UPDATE)
   LOOP
      UPDATE plch_parts
         SET partname = UPPER (partname)
       WHERE partgroup = rec.partgroup;

      DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   END LOOP;
END;
/

BEGIN
   plch_update_parts ();
END;
/

/* Clean up */

DROP TABLE plch_parts
/

DROP PROCEDURE plch_update_parts
/