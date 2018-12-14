DROP TABLE training_months 
/
CREATE TABLE training_months (month_name VARCHAR2(100))
/

BEGIN
   INSERT INTO training_months
        VALUES ('January');

   INSERT INTO training_months
        VALUES ('February');

   INSERT INTO training_months
        VALUES ('March');

   INSERT INTO training_months
        VALUES ('April');

   INSERT INTO training_months
        VALUES ('May');

   INSERT INTO training_months
        VALUES ('June');

   INSERT INTO training_months
        VALUES ('July');

   INSERT INTO training_months
        VALUES ('August');

   INSERT INTO training_months
        VALUES ('September');

   INSERT INTO training_months
        VALUES ('October');

   INSERT INTO training_months
        VALUES ('November');

   INSERT INTO training_months
        VALUES ('December');

   INSERT INTO training_months
        VALUES ('Feuerember');

   COMMIT;
END;
/

DECLARE
   TYPE at_most_twelve_t IS VARRAY (12) OF VARCHAR2 (100);

   l_months   at_most_twelve_t;
BEGIN
   SELECT month_name
   BULK COLLECT INTO l_months
     FROM training_months;

   FOR indx IN 1 .. l_months.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_months (indx));
   END LOOP;
END;
/