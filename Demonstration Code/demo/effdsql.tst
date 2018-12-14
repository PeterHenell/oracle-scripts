/* Formatted by PL/Formatter v3.1.2.1 on 2001/05/16 09:22 */

CREATE OR REPLACE PROCEDURE dynsql_efficiency (
   counter   IN   INTEGER
)
IS
   cursor_id   INTEGER;
   exec_stat   INTEGER;
BEGIN
   /*
   || Approach 1: Open, parse, execute and bind and close
   || for each new variable.
   */
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      cursor_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (cursor_id,
         'SELECT employee_id, last_name, first_name, d.department_id,
                 salary, manager_id
            FROM employee E, department D
           WHERE D.department_id = ' ||
            i ||
            ' AND E.department_id = D.department_id
             AND E.employee_id IN
                 (SELECT employee_id
                    FROM employee E2
                   WHERE salary = (SELECT MAX(salary) FROM employee))
             AND last_name LIKE ''S%''
           ORDER BY DECODE (D.department_id, 10, SYSDATE,
              20, SYSDATE + 50,
              30, ADD_MONTHS (SYSDATE,50),
              40, SYSDATE + 500)',
         DBMS_SQL.native
      );
      exec_stat := DBMS_SQL.execute (cursor_id);
      DBMS_SQL.close_cursor (cursor_id);
   END LOOP;

   sf_timer.show_elapsed_time ('Repetitive parse and no bind');
   /*
   || Approach 2: Parse and bind only when necessary
   */
   sf_timer.start_timer;
   cursor_id := DBMS_SQL.open_cursor;
   /*
   || parse first outside of loop
   */
   DBMS_SQL.parse (cursor_id,
      'SELECT employee_id, last_name, first_name, d.department_id,
                 salary, manager_id
            FROM employee E, department D
           WHERE D.department_id = :diff_name
             AND E.department_id = D.department_id
             AND E.employee_id IN
                 (SELECT employee_id
                    FROM employee E2
                   WHERE salary = (SELECT MAX(salary) FROM employee))
             AND last_name LIKE ''S%''
           ORDER BY DECODE (D.department_id, 10, SYSDATE,
              20, SYSDATE + 50,
              30, ADD_MONTHS (SYSDATE,50),
              40, SYSDATE + 500)',
      DBMS_SQL.native
   );

   FOR i IN 1 .. counter
   LOOP
      /*
      || bind and excecute each loop iteration
      || using host vars
      */
      DBMS_SQL.bind_variable (cursor_id, 'diff_name', i);
      exec_stat := DBMS_SQL.execute (cursor_id);
   END LOOP;

   DBMS_SQL.close_cursor (cursor_id);
   sf_timer.show_elapsed_time ('Single parse');
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      cursor_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (cursor_id,
         'SELECT employee_id, last_name, first_name, d.department_id,
                    salary, manager_id
               FROM employee E, department D
              WHERE D.department_id = :diff_name
                AND E.department_id = D.department_id
                AND E.employee_id IN
                    (SELECT employee_id
                       FROM employee E2
                      WHERE salary = (SELECT MAX(salary) FROM employee))
                AND last_name LIKE ''S%''
              ORDER BY DECODE (D.department_id, 10, SYSDATE,
                 20, SYSDATE + 50,
                 30, ADD_MONTHS (SYSDATE,50),
                 40, SYSDATE + 500)',
         DBMS_SQL.native
      );
      DBMS_SQL.bind_variable (cursor_id, 'diff_name', i);
      exec_stat := DBMS_SQL.execute (cursor_id);
      DBMS_SQL.close_cursor (cursor_id);
   END LOOP;

   sf_timer.show_elapsed_time ('Repetitive parse with bind');
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      EXECUTE IMMEDIATE 'SELECT employee_id, last_name, first_name, d.department_id,
                    salary, manager_id
               FROM employee E, department D
              WHERE D.department_id = :diff_name
                AND E.department_id = D.department_id
                AND E.employee_id IN
                    (SELECT employee_id
                       FROM employee E2
                      WHERE salary = (SELECT MAX(salary) FROM employee))
                AND last_name LIKE ''S%''
              ORDER BY DECODE (D.department_id, 10, SYSDATE,
                 20, SYSDATE + 50,
                 30, ADD_MONTHS (SYSDATE,50),
                 40, SYSDATE + 500)' USING i;
   END LOOP;

   sf_timer.show_elapsed_time ('NDS exec immediate with bind');
END;
/

