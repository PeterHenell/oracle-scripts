DROP TABLE otn_insert
/
CREATE TABLE otn_insert (insert_method VARCHAR2(100), value1 VARCHAR2(100), value2 VARCHAR2(100))
/

DECLARE
   l_insert   VARCHAR2 (500);
   l_value1   otn_insert.value1%TYPE;
   l_value2   otn_insert.value2%TYPE;
BEGIN
   l_value1 := '00001111';
   l_value2 := '11110000';

   INSERT INTO otn_insert
               (insert_method, value1, value2
               )
        VALUES ('Static INSERT', l_value1, l_value2
               );

   l_insert :=
         'INSERT INTO otn_insert (insert_method, value1, value2) 
		     VALUES (''Dynamic Concatenation'','
      || l_value1
      || ','
      || l_value2
      || ')';

	  DBMS_OUTPUT.PUT_LINE (L_insert);
   EXECUTE IMMEDIATE l_insert;

   l_insert :=
      'INSERT INTO otn_insert (insert_method, value1, value2) 
	     VALUES (''Dynamic Binding'',:r1, :r2)';

   EXECUTE IMMEDIATE l_insert
               USING l_value1, l_value2;
END;
/

SELECT *
  FROM otn_insert
/
DROP TABLE otn_insert
/