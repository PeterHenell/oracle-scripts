DECLARE
   TYPE name_ntt IS TABLE OF employees.last_name%TYPE;

   -- I initialize these two lists to demonstrate some odd
   -- behavior regarding NULL values in these structures.
   ln50d   name_ntt := name_ntt ('a', 'b', NULL);
   ln50a   name_ntt := name_ntt ('b', 'a', NULL);
   ln100   name_ntt := name_ntt ();
BEGIN
   /* Null values in both arrays result in null for equality operator */
   DBMS_OUTPUT.put_line ('Both collections have null elements....');

   IF ln50a = ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN50A and LN50D are equal');
   ELSIF ln50a != ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN50A and LN50D are not equal');
   ELSE
      DBMS_OUTPUT.put_line ('NULL');
   END IF;

     /* Order does not matter */

     SELECT last_name
       BULK COLLECT INTO ln50d
       FROM employees
      WHERE department_id = 50
   ORDER BY last_name DESC;

     SELECT last_name
       BULK COLLECT INTO ln50a
       FROM employees
      WHERE department_id = 50
   ORDER BY last_name ASC;

   SELECT last_name
     BULK COLLECT INTO ln100
     FROM employees
    WHERE department_id = 100;

   IF ln50a = ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN50A and LN50D are equal');
   ELSIF ln50a != ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN50A and LN50D are not equal');
   ELSE
      DBMS_OUTPUT.put_line ('NULL');
   END IF;

   DBMS_OUTPUT.put_line ('Only one collection has a null....');

   IF ln100 = ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN100 and LN50D are equal');
   ELSIF ln100 != ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN100 and LN50D are not equal');
   ELSE
      DBMS_OUTPUT.put_line ('NULL');
   END IF;

   DBMS_OUTPUT.put_line ('Add null to just one bulk collected array and...');
   ln50d.EXTEND;
   ln50d (ln50d.LAST) := NULL;
   ln50a.EXTEND;
   ln50a (ln50a.LAST) := 'X';

   IF ln50a = ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN50A and LN50D are equal');
   ELSIF ln50a != ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN50A and LN50D are not equal');
   ELSE
      DBMS_OUTPUT.put_line ('NULL');
   END IF;

   IF ln100 = ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN100 and LN50D are equal');
   ELSIF ln100 != ln50d
   THEN
      DBMS_OUTPUT.put_line ('LN100 and LN50D are not equal');
   ELSE
      DBMS_OUTPUT.put_line ('NULL');
   END IF;
END;
/