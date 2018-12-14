CREATE OR REPLACE PROCEDURE showemps3 (
   prefix_in IN VARCHAR2 := NULL,
   where_in IN VARCHAR2 := NULL)
IS
   TYPE refcur IS REF CURSOR;
   cv refcur;
   nm employee.last_name%TYPE;
   id employee.employee_id%TYPE;
   fdbk INTEGER;
BEGIN
   OPEN cv FOR
      'SELECT employee_id, last_name
         FROM employee
        WHERE ' || NVL (where_in, '1=1');
   LOOP
      FETCH cv INTO id, nm;
      EXIT WHEN cv%NOTFOUND;
      p.l (TO_CHAR (id) || '=' || nm);
   END LOOP;
   
   CLOSE cv;
END;
/

