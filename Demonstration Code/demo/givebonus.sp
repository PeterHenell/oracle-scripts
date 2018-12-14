CREATE OR REPLACE PROCEDURE give_bonus (
   dept_in IN employee.department_id%TYPE,
   bonus_in IN NUMBER)
/*
|| Give the same bonus to each employee in the
|| specified department, but only if they have
|| been with the company for at least 6 months.
*/
IS
   dept_rec department%ROWTYPE;

   fdbk INTEGER;
BEGIN
   /* Retrieve all information for the specified department. */
   dept_rec := te_department.onerow (dept_in);

   /* Make sure the department ID was valid. */
   IF te_department.isnullpky (dept_rec)
   THEN
      DBMS_OUTPUT.PUT_LINE (
         'Invalid department ID specified: ' || dept_in);   
   ELSE
      /* Display the header. */
      DBMS_OUTPUT.PUT_LINE (
         'Applying Bonuses of ' || bonus_in || 
         ' to the ' || dept_rec.name || ' Department');
   END IF;

   /* Make sure that the appropriate cursor is closed. */

   te_employee.close_emp_dept_lookup_all_cur;

   /* For each employee in the specified department... */
   FOR rec IN te_employee.emp_dept_lookup_all_cur (
      dept_in)
   LOOP
      IF ADD_MONTHS (SYSDATE, -6) > rec.hire_date 
      THEN
         /* Use the encapsulated update procedure 
            specifically for this column. */

         te_employee.upd$salary (
            rec.employee_id,
            rec.salary + bonus_in,
            fdbk);

         /* Make sure the update was successful. */
         IF fdbk = 1
         THEN
            DBMS_OUTPUT.PUT_LINE (
               '* Bonus applied to ' ||
               rec.last_name); 
         ELSE
            DBMS_OUTPUT.PUT_LINE (
               '* Unable to apply bonus to ' ||
               rec.last_name); 
         END IF;
      END IF;
   END LOOP;
END;
/
