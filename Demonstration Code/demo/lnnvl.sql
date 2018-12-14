CREATE TABLE plch_employees
(
   employee_id      INTEGER
 ,  last_name        VARCHAR2 (100)
 ,  salary           NUMBER
 ,  commission_pct   NUMBER
)
/


INSERT INTO plch_employees
     VALUES (100
           ,  'Picasso'
           ,  1000000
           ,  .3)
/

INSERT INTO plch_employees
     VALUES (200
           ,  'Mondrian'
           ,  1000000
           ,  .15)
/

INSERT INTO plch_employees
     VALUES (300
           ,  'O''Keefe'
           ,  1000000
           ,  NULL)
/

COMMIT
/

  SELECT last_name
    FROM plch_employees e
   WHERE e.commission_pct <= .2 OR e.commission_pct IS NULL
ORDER BY last_name
/

  SELECT last_name
    FROM plch_employees e
   WHERE LNNVL (e.commission_pct > .2)
ORDER BY last_name
/

  SELECT last_name
    FROM plch_employees e
   WHERE e.commission_pct <= .2
ORDER BY last_name
/

SELECT last_name
  FROM plch_employees e1
 WHERE e1.commission_pct <= .2
UNION
SELECT last_name
  FROM plch_employees e2
 WHERE e2.commission_pct IS NULL
/

/* Clean up */

DROP TABLE plch_employees
/