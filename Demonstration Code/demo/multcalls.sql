DROP TABLE table1;

CREATE TABLE table1 (
   field1 VARCHAR2(10),
   field2 VARCHAR2(10),
   field3 VARCHAR2(10)
   );

INSERT INTO table1 VALUES ('steven', 'veva', 'eli');

CREATE OR REPLACE FUNCTION my_function (
   parm1 IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   dbms_output.put_line ('My_Function');
   RETURN 'a';
END;
/

SELECT my_function(field1),
       my_function(field2)
FROM   table1;

BEGIN
    dbms_output.put_line ('all done');
END;
/
