DROP TABLE test_table;
CREATE TABLE test_table (name VARCHAR2(100), description VARCHAR2(1000));
INSERT INTO test_table VALUES ('GEORGIE', 'Handsome fellow');
INSERT INTO test_table VALUES ('PAULA', 'Sharp as a tack');
COMMIT;

DECLARE
   TYPE test_table_tc IS TABLE OF test_table.description%TYPE
      INDEX BY PLS_INTEGER;

   l_list   test_table_tc;
BEGIN
   SELECT        description
   BULK COLLECT INTO l_list
            FROM test_table
   FOR UPDATE OF name;
   
   DBMS_LOCK.SLEEP (30);
   
   FORALL indx IN l_list.FIRST .. l_list.LAST
      UPDATE test_table SET name = l_list(indx);
END;
/

REM Run from another session within 30 seconds....

BEGIN
   UPDATE test_table SET name = 'GEORGIE'
    WHERE name = 'GEORGIE';
END;
/
	