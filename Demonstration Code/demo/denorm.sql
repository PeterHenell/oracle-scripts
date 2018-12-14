-- One to many
SELECT dd.department_id, nms.COLUMN_VALUE
  FROM department_denorms dd, TABLE ( dd.employee_names ) nms
/
-- Apply WHERE clause to nested table value
SELECT dd.department_id, nms.COLUMN_VALUE
  FROM department_denorms dd, TABLE ( dd.employee_names ) nms
 WHERE nms.COLUMN_VALUE LIKE '%e%'
/
-- Cartesian product
SELECT dd.department_id, nms.COLUMN_VALUE NAME, ids.COLUMN_VALUE ID
  FROM department_denorms dd
     , TABLE ( dd.employee_names ) nms
     , TABLE ( dd.employee_ids ) ids
/
-- Change values in nested table.
-- Note: you cannot make "piecemeal" changes to varrays. You will have
-- to replace them in their entirety.
UPDATE TABLE ( SELECT employee_ids
                 FROM department_denorms
                WHERE department_id = 50 )
   SET COLUMN_VALUE = -1 *  COLUMN_VALUE
/
SELECT ids.COLUMN_VALUE
  FROM TABLE ( SELECT employee_ids
                 FROM department_denorms
                WHERE department_id = 50 ) ids
/
