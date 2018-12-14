CREATE OR REPLACE PROCEDURE showemps81 (
   where_in IN VARCHAR2 := NULL)
IS
   --TYPE cv_typ IS REF CURSOR;
   cv SYS_REFCURSOR;
   rec employee%ROWTYPE;
BEGIN
   OPEN cv FOR 
      'SELECT * FROM employee 
        WHERE ' || NVL (where_in, '1=1');
   LOOP
      FETCH cv INTO rec;
      EXIT WHEN cv%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE (
         TO_CHAR (rec.employee_id) || '=' || rec.last_name);
   END LOOP;
   CLOSE cv;
END;
/

