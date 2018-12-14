DECLARE
   TYPE r IS REF CURSOR;

   cv   r;

   TYPE ct IS TABLE OF employee%ROWTYPE;

   c    ct := ct ();
BEGIN
   OPEN cv FOR
      SELECT *
        FROM employee;

   LOOP
      FETCH cv
      BULK COLLECT INTO c LIMIT 5;

      EXIT WHEN cv%NOTFOUND;
   END LOOP;
END;