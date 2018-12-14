CREATE OR REPLACE VIEW emp_summary_v
AS
     SELECT department_id,
            SUM (salary) sum_salary,
            COUNT (*) num_employees
       FROM employees
   GROUP BY department_id
/

CREATE OR REPLACE VIEW emp_dept_v
AS
   SELECT d.department_name,
          v.sum_salary,
          v.num_employees,
          e.last_name
     FROM emp_summary_v v,
          employees e,
          departments d
    WHERE     d.department_id =
                 e.department_id
          AND d.department_id =
                 v.department_id
/

DECLARE
   l_output   VARCHAR2 (32767);
BEGIN
   DBMS_UTILITY.expand_sql_text (
      'select * from emp_dept_v',
      l_output);
   DBMS_OUTPUT.put_line (l_output);
END;
/

/* Formatted output (output from procedure is just one long line) */

SELECT "A1"."DEPARTMENT_NAME"
          "DEPARTMENT_NAME",
       "A1"."SUM_SALARY" "SUM_SALARY",
       "A1"."NUM_EMPLOYEES" "NUM_EMPLOYEES",
       "A1"."LAST_NAME" "LAST_NAME"
  FROM (SELECT "A2"."DEPARTMENT_NAME"
                  "DEPARTMENT_NAME",
               "A4"."SUM_SALARY"
                  "SUM_SALARY",
               "A4"."NUM_EMPLOYEES"
                  "NUM_EMPLOYEES",
               "A3"."LAST_NAME" "LAST_NAME"
          FROM (  SELECT "A5"."DEPARTMENT_ID"
                            "DEPARTMENT_ID",
                         SUM ("A5"."SALARY")
                            "SUM_SALARY",
                         COUNT (*)
                            "NUM_EMPLOYEES"
                    FROM hr."EMPLOYEES" "A5"
                GROUP BY "A5"."DEPARTMENT_ID")
               "A4",
               hr."EMPLOYEES" "A3",
               hr."DEPARTMENTS" "A2"
         WHERE     "A2"."DEPARTMENT_ID" =
                      "A3"."DEPARTMENT_ID"
               AND "A2"."DEPARTMENT_ID" =
                      "A4"."DEPARTMENT_ID")
       "A1"
/