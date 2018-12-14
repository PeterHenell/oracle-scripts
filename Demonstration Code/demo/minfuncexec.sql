/* This technique is NOT VERIFIED at this time (9/99) */

SET PAGESIZE 999

CREATE OR REPLACE FUNCTION count_this
   (num IN NUMBER) RETURN INTEGER
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('a');
   RETURN num;
END;
/
 
SELECT count_this (employee_id)
  FROM employee
 WHERE ROWNUM <= 50
   AND count_this (employee_id) > 3;

SELECT name, type, executions
  FROM V$DB_OBJECT_CACHE
 WHERE /*owner = USER
   AND */INSTR (UPPER (name), 'COUNT_THIS') > 0
   AND INSTR (UPPER (name), 'DB_OBJECT_CACHE') = 0;

SELECT func_value
  FROM
     (SELECT count_this (employee_id) AS func_value
        FROM employee
       WHERE ROWNUM <= 50
         AND count_this (employee_id) > 3);

SELECT owner ||'.' || name name, executions
  FROM V$DB_OBJECT_CACHE
 WHERE /*owner = USER
   AND */INSTR (UPPER (name), 'COUNT_THIS') > 0
   AND INSTR (UPPER (name), 'DB_OBJECT_CACHE') = 0; 
