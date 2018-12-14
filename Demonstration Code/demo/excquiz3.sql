BEGIN
   <<outer>>
   DECLARE
      aname   VARCHAR2 (5);
   BEGIN
      <<inner>>
      DECLARE
         aname   VARCHAR2 (20);
      BEGIN
         OUTER.aname := 'Big String';
      EXCEPTION
         WHEN VALUE_ERROR
         THEN
            RAISE NO_DATA_FOUND;
			
         WHEN NO_DATA_FOUND
         THEN
            DBMS_OUTPUT.put_line ('Inner block');
      END INNER;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line ('Outer block');
   END OUTER;
END;
/
