CREATE OR REPLACE PROCEDURE dynsql_efficiency (counter IN INTEGER)
IS
   cursor_id INTEGER;
   exec_stat INTEGER;
BEGIN
   /*
   || Approach 1: Open, parse, execute and bind and close
   || for each new variable.
   */
   sf_timer.start_timer;
   FOR i IN 1..counter
   LOOP
      cursor_id := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE
         (cursor_id,
         'SELECT employee_id, last_name, first_name, d.department_id,
                 salary, manager_id
            FROM employee E, department D
           WHERE D.department_id = ' || i ||
           ' AND E.department_id = D.department_id
             AND E.employee_id IN
                 (SELECT employee_id
                    FROM employee E2
                   WHERE salary = (SELECT MAX(salary) FROM employee))
             AND last_name LIKE ''S%''
           ORDER BY DECODE (D.department_id, 10, SYSDATE,
              20, SYSDATE + 50,
              30, ADD_MONTHS (SYSDATE,50),
              40, SYSDATE + 500)'
         ,DBMS_SQL.native);
      exec_stat := DBMS_SQL.EXECUTE(cursor_id);
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(cursor_id);

   sf_timer.show_elapsed_time ('Repetitive parse and no bind');
END;
/
