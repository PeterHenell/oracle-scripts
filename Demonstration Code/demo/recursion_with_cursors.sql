CREATE OR REPLACE PROCEDURE getchildren (
   pparent    IN       NUMBER
 , pobjects   OUT      sys_refcursor
)
IS
   CURSOR emps_for_mgr
   IS
      SELECT employee_id
        FROM employee
       WHERE manager_id = pparent;   /* Get the children for PParent */
BEGIN
   FOR empid IN emps_for_mgr
   LOOP
      DBMS_OUTPUT.put_line ('Object found, ID = ' || empid.employee_id);

      OPEN pobjects FOR
         SELECT employee_id
           FROM employee
          WHERE department_id = 10;

      getchildren (empid.employee_id, pobjects);
   END LOOP;
END getchildren;
