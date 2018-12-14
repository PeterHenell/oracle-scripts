DROP TABLE parts;

CREATE TABLE parts
(
   partnum    NUMBER,
   partname   VARCHAR2 (15)
);

DECLARE
   TYPE parts_t IS TABLE OF parts%ROWTYPE;

   l_parts   parts_t;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE parts';

   /* Load up the table. */
   FOR indx IN 1 .. 100
   LOOP
      INSERT INTO parts
           VALUES (indx, 'Part ' || TO_CHAR (indx));
   END LOOP;

   EXECUTE IMMEDIATE 'SELECT * FROM parts'
      BULK COLLECT INTO l_parts;

   DBMS_OUTPUT.put_line (l_parts.COUNT);
END;
/