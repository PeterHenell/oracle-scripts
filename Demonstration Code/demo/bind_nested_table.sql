CREATE OR REPLACE TYPE n_t IS TABLE OF NUMBER
/

DECLARE
   n   n_t := n_t (1, 2, 3);
   l   NUMBER;
BEGIN
   EXECUTE IMMEDIATE 'select * from table (:tab)
        where column_value = 1' INTO l USING n;

   DBMS_OUTPUT.put_line (l);
END;
/