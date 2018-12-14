DROP TABLE five_columns
/

CREATE TABLE five_columns
(
   id     NUMBER
 , val1   NUMBER
 , val2   NUMBER
 , val3   NUMBER
 , val4   NUMBER
 , val5   NUMBER
)
/

BEGIN
   INSERT INTO five_columns
       VALUES (1, 1, 2, 3, 4, 5
              );

   INSERT INTO five_columns
       VALUES (2, 10, 20, 30, 40, 50
              );

   COMMIT;
END;
/

CREATE OR REPLACE FUNCTION double_value (val_in IN NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN val_in * 2;
END;
/

DECLARE
   TYPE results_tt IS TABLE OF NUMBER
                         INDEX BY PLS_INTEGER;

   l_results   results_tt;
BEGIN
   FOR col_num IN 1 .. 5
   LOOP
      EXECUTE IMMEDIATE   
        'DECLARE l_curval NUMBER; 
         BEGIN SELECT val' || col_num
            || ' INTO l_curval FROM five_columns WHERE id = :id;'
            || ' :newval := double_value (l_curval); 
         END;'
         USING IN 1 /* The ID value */
                   , OUT l_results (col_num);
   END LOOP;

   FOR indx IN 1 .. l_results.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_results (indx));
   END LOOP;
END;
/


