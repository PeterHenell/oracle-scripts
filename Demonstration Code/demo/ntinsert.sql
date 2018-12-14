CREATE OR REPLACE TYPE salaries_nt IS TABLE OF NUMBER;
/

DROP TABLE salhistory;

CREATE TABLE salhistory (
   empno NUMBER,
   salaries salaries_nt
   )
   NESTED TABLE salaries STORE AS sa_salaries;

DECLARE  
   my_sals salaries_nt := salaries_nt (10000, 20000, 30000);
BEGIN   
   INSERT INTO salhistory VALUES (1, my_sals);
   
   INSERT INTO salhistory VALUES (2, salaries_nt (1000, 2000, 3000));
END;
/

SELECT * FROM salhistory;
      
   
