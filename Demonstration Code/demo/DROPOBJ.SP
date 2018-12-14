CREATE OR REPLACE PROCEDURE drop_object 
   (type_in IN VARCHAR2, name_in IN VARCHAR2)
IS
   /* The static cursor retrieving all matching objects */
   CURSOR obj_cur IS
      SELECT object_name, object_type
        FROM user_objects
       WHERE object_name LIKE UPPER (name_in)
         AND object_type LIKE UPPER (type_in)
       ORDER BY object_name;
   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN
   /* For each matching object ... */
   FOR obj_rec IN obj_cur
   LOOP
      /* Reusing same cursor, parse and execute the drop statement. */
      DBMS_SQL.PARSE 
         (cur, 
          'DROP ' || obj_rec.object_type || ' ' || obj_rec.object_name, 
          DBMS_SQL.NATIVE);

      fdbk := DBMS_SQL.EXECUTE (cur);
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
