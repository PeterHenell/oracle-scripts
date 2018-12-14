DROP TABLE mini_employees
/

CREATE TABLE mini_employees (name  VARCHAR2 (100), salary NUMBER (3))
/

BEGIN
   INSERT INTO mini_employees
       VALUES ('Sam', 10
              );

   INSERT INTO mini_employees
       VALUES ('Sally', 100
              );

   INSERT INTO mini_employees
       VALUES ('Tom', 10
              );

   INSERT INTO mini_employees
       VALUES ('Theodore', 20
              );

   COMMIT;
END;
/

  SELECT name, salary
    FROM mini_employees
   WHERE name LIKE 'S%' OR name LIKE 'T%'
ORDER BY name
/

DECLARE
   l_names   DBMS_SQL.varchar2s;
BEGIN
   l_names (1) := 'T%';
   l_names (2) := 'S%';

   FORALL indx IN 1 .. l_names.COUNT
   SAVE EXCEPTIONS
      UPDATE mini_employees
         SET salary = salary * 10
       WHERE name LIKE l_names (indx);
EXCEPTION
   WHEN OTHERS
   THEN
      /* In real world, never do this! */
      NULL;
END;
/

  SELECT name, salary
    FROM mini_employees
   WHERE name LIKE 'S%' OR name LIKE 'T%'
ORDER BY name
/

ROLLBACK
/