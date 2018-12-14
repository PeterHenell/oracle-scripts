CREATE OR REPLACE PROCEDURE curexpr_test (
   p_locid NUMBER
)
--May need to run this first @@Locations.tab
IS
   TYPE refcursor IS REF CURSOR;

/* Notes on CURSOR expression:

   1. The query returns only 2 columns, but the second column is
      a cursor that lets us traverse a set of related information.

   2. Queries in CURSOR expression that find no rows do NOT raise
      NO_DATA_FOUND.
*/
   CURSOR all_in_one_cur
   IS
      SELECT l.city
            ,CURSOR (SELECT d.NAME
                           ,CURSOR (SELECT e.last_name
                                      FROM employee e
                                     WHERE e.department_id =
                                                            d.department_id)
                                                                  AS ename
                       FROM department d
                      WHERE l.location_id = d.loc_id
                    ) AS dname
        FROM locations l
       WHERE l.location_id = p_locid;

   department_cur   refcursor;
   employee_cur     refcursor;
   v_city           locations.city%TYPE;
   v_dname          department.NAME%TYPE;
   v_ename          employee.last_name%TYPE;
BEGIN
   OPEN all_in_one_cur;

   LOOP
      FETCH all_in_one_cur
       INTO v_city
           ,department_cur;

      EXIT WHEN all_in_one_cur%NOTFOUND;

      -- Now I can loop through deartments and I do NOT need to
      -- explicitly open that cursor. Oracle did it for me.
      LOOP
         FETCH department_cur
          INTO v_dname
              ,employee_cur;

         EXIT WHEN department_cur%NOTFOUND;

         -- Now I can loop through employee for that department.
         -- Again, I do need to open the cursor explicitly.
         LOOP
            FETCH employee_cur
             INTO v_ename;

            EXIT WHEN employee_cur%NOTFOUND;
            DBMS_OUTPUT.put_line (v_city || ' ' || v_dname || ' '
                                  || v_ename
                                 );
         END LOOP;

         CLOSE employee_cur;   -- Voxware 11/2005
      END LOOP;

      CLOSE department_cur;   -- Voxware 11/2005
   END LOOP;

   CLOSE all_in_one_cur;
END;
/
