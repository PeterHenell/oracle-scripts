CREATE TABLE otn_demo (num NUMBER, name VARCHAR2(100))
/

CREATE OR REPLACE PACKAGE otn_demo_insert
IS
   TYPE otn_demo_aat IS TABLE OF otn_demo%ROWTYPE
      INDEX BY PLS_INTEGER;

   PROCEDURE insert_rows ( rows_in IN otn_demo_aat );
END otn_demo_insert;
/
CREATE OR REPLACE PACKAGE BODY otn_demo_insert
IS
   PROCEDURE insert_rows ( rows_in IN otn_demo_aat )
   IS
   BEGIN
$IF DBMS_DB_VERSION.VER_LE_10_1
$THEN
   DECLARE
      l_dense otn_demo_aat;
      l_index PLS_INTEGER := rows_in.FIRST;
   BEGIN
      WHILE (l_index IS NOT NULL)
      LOOP
         l_dense (l_dense.COUNT + 1) := rows_in (l_index);
         l_index := rows_in.NEXT (l_index);
      END LOOP;
      
      FORALL indx IN l_dense.FIRST .. l_dense.LAST
         INSERT INTO otn_demo VALUES l_dense (indx);
   END;
$ELSE
      FORALL indx IN INDICES OF rows_in
         INSERT INTO otn_demo VALUES rows_in (indx);
$END
   END insert_rows;
END otn_demo_insert;
/
