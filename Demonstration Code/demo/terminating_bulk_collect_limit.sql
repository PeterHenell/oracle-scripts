DROP TABLE ten_rows
/

CREATE TABLE ten_rows (n NUMBER)
/

DECLARE
   nums   DBMS_SQL.number_table;

   CURSOR cur
   IS
      SELECT *
        FROM ten_rows;
BEGIN
   FOR indx IN 1 .. 10
   LOOP
      INSERT INTO ten_rows
          VALUES (indx
                 );
   END LOOP;

   OPEN cur;

   LOOP
      FETCH cur
      BULK COLLECT INTO nums
      LIMIT 5;

      DBMS_OUTPUT.put_line (nums.COUNT);
      bpl (cur%NOTFOUND);
      EXIT WHEN cur%NOTFOUND;
   END LOOP;
END;
/