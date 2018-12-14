CREATE OR REPLACE TYPE o_test AS OBJECT
                  (id NUMBER);
/

CREATE TABLE t_test OF o_test
/

SELECT table_name
  FROM user_tables
 WHERE table_name = 'T_TEST'
/