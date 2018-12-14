CREATE OR REPLACE PROCEDURE give_bonus (
   dept_in    IN   employee_tp.department_id_t
 , bonus_in   IN   employee_tp.bonus_t
)
IS
   l_department     department_tp.department_rt;
   l_employees      employee_tp.employee_tc;
   l_row            PLS_INTEGER;
   l_rows_updated   PLS_INTEGER;
BEGIN
   l_department := department_qp.onerow (dept_in);
   l_employees := employee_qp.ar_fk_emp_department (dept_in);
   l_row := l_array.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      IF employee_rp.eligible_for_bonus (rec)
      THEN
         employee_cp.upd_onecol_pky
            (colname_in          => 'salary'
           , new_value_in        =>   l_employees (l_row).salary
                                    + bonus_in
           , employee_id_in      => l_employees (l_row).employee_id
           , rows_out            => l_rows_updated
            );
      END IF;

      l_row := l_employees.NEXT (l_row);
   END LOOP;
--    ... more processing with name and other elements
END;
/
