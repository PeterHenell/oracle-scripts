DECLARE
   TYPE numbers_t IS TABLE OF NUMBER
                        INDEX BY PLS_INTEGER;

   l_ids   numbers_t;
BEGIN
   IF l_ids.COUNT > 0
   THEN
      FOR indx IN l_ids.FIRST .. l_ids.LAST
      LOOP
         DBMS_OUTPUT.put_line (l_ids (indx));
      END LOOP;
   END IF;

   FORALL l_index IN l_ids.FIRST .. l_ids.LAST
      DELETE FROM employees
            WHERE employee_id = l_ids (l_index);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   ROLLBACK;
END;
/