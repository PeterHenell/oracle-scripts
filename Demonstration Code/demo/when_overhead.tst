CREATE OR REPLACE TRIGGER emp_bur
   BEFORE UPDATE
   ON employee
   FOR EACH ROW
   WHEN (   (   OLD.employee_id != NEW.employee_id
             OR OLD.employee_id IS NULL AND NEW.employee_id IS NOT NULL
             OR NEW.employee_id IS NULL AND OLD.employee_id IS NOT NULL
            )
         OR (   OLD.last_name != NEW.last_name
             OR OLD.last_name IS NULL AND NEW.last_name IS NOT NULL
             OR NEW.last_name IS NULL AND OLD.last_name IS NOT NULL
            )
         OR (   OLD.first_name != NEW.first_name
             OR OLD.first_name IS NULL AND NEW.first_name IS NOT NULL
             OR NEW.first_name IS NULL AND OLD.first_name IS NOT NULL
            )
         OR (   OLD.middle_initial != NEW.middle_initial
             OR     OLD.middle_initial IS NULL
                AND NEW.middle_initial IS NOT NULL
             OR     NEW.middle_initial IS NULL
                AND OLD.middle_initial IS NOT NULL
            )
         OR (   OLD.job_id != NEW.job_id
             OR OLD.job_id IS NULL AND NEW.job_id IS NOT NULL
             OR NEW.job_id IS NULL AND OLD.job_id IS NOT NULL
            )
         OR (   OLD.manager_id != NEW.manager_id
             OR OLD.manager_id IS NULL AND NEW.manager_id IS NOT NULL
             OR NEW.manager_id IS NULL AND OLD.manager_id IS NOT NULL
            )
         OR (   OLD.hire_date != NEW.hire_date
             OR OLD.hire_date IS NULL AND NEW.hire_date IS NOT NULL
             OR NEW.hire_date IS NULL AND OLD.hire_date IS NOT NULL
            )
         OR (   OLD.salary != NEW.salary
             OR OLD.salary IS NULL AND NEW.salary IS NOT NULL
             OR NEW.salary IS NULL AND OLD.salary IS NOT NULL
            )
         OR (   OLD.commission != NEW.commission
             OR OLD.commission IS NULL AND NEW.commission IS NOT NULL
             OR NEW.commission IS NULL AND OLD.commission IS NOT NULL
            )
         OR (   OLD.department_id != NEW.department_id
             OR OLD.department_id IS NULL AND NEW.department_id IS NOT NULL
             OR NEW.department_id IS NULL AND OLD.department_id IS NOT NULL
            )
         OR (   OLD.empno != NEW.empno
             OR OLD.empno IS NULL AND NEW.empno IS NOT NULL
             OR NEW.empno IS NULL AND OLD.empno IS NOT NULL
            )
         OR (   OLD.ename != NEW.ename
             OR OLD.ename IS NULL AND NEW.ename IS NOT NULL
             OR NEW.ename IS NULL AND OLD.ename IS NOT NULL
            )
         OR (   OLD.created_by != NEW.created_by
             OR OLD.created_by IS NULL AND NEW.created_by IS NOT NULL
             OR NEW.created_by IS NULL AND OLD.created_by IS NOT NULL
            )
         OR (   OLD.created_on != NEW.created_on
             OR OLD.created_on IS NULL AND NEW.created_on IS NOT NULL
             OR NEW.created_on IS NULL AND OLD.created_on IS NOT NULL
            )
         OR (   OLD.changed_by != NEW.changed_by
             OR OLD.changed_by IS NULL AND NEW.changed_by IS NOT NULL
             OR NEW.changed_by IS NULL AND OLD.changed_by IS NOT NULL
            )
         OR (   OLD.changed_on != NEW.changed_on
             OR OLD.changed_on IS NULL AND NEW.changed_on IS NOT NULL
             OR NEW.changed_on IS NULL AND OLD.changed_on IS NOT NULL
            )
        )
BEGIN
   NULL;
END emp_bur;
/

BEGIN
   EXECUTE IMMEDIATE 'alter trigger emp_bur enable';

   sf_timer.start_timer;

   FOR x IN 1 .. 10000
   LOOP
      UPDATE employee
         SET last_name = last_name
       WHERE department_id = 10;
   END LOOP;

   sf_timer.show_elapsed_time ('with trigger');
   ROLLBACK;

   EXECUTE IMMEDIATE 'alter trigger emp_bur disable';

   sf_timer.start_timer;

   FOR x IN 1 .. 10000
   LOOP
      UPDATE employee
         SET last_name = last_name
       WHERE department_id = 10;
   END LOOP;

   sf_timer.show_elapsed_time ('disabled trigger');
   ROLLBACK;

   EXECUTE IMMEDIATE 'drop trigger emp_bur';

   sf_timer.start_timer;

   FOR x IN 1 .. 10000
   LOOP
      UPDATE employee
         SET last_name = last_name
       WHERE department_id = 10;
   END LOOP;

   sf_timer.show_elapsed_time ('dropped trigger');
   ROLLBACK;
   
/*
with trigger Elapsed: 1.7 seconds.
disabled trigger Elapsed: 1.68 seconds.
dropped trigger Elapsed: 1.05 seconds.

with trigger Elapsed: 1.43 seconds.
disabled trigger Elapsed: 1.49 seconds.
dropped trigger Elapsed: 1.25 seconds.

with trigger Elapsed: 1.38 seconds.
disabled trigger Elapsed: 1.45 seconds.
dropped trigger Elapsed: 1.14 seconds.
*/
END;
/