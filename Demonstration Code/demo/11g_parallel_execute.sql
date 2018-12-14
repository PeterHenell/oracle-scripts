CREATE OR REPLACE PROCEDURE apply_raise (pct_in     IN NUMBER
                                      , retries_in IN PLS_INTEGER DEFAULT 2
                                       )
IS
   c_update_statement CONSTANT VARCHAR2 (1000)
         := 'UPDATE /*+ ROWID (dda) */ EMPLOYEES emp 
      SET emp.salary = emp.salary * (1.0 + pct_in/100)
      WHERE ROWID BETWEEN :starting_rowid AND :ending_rowid' ;
   c_task_name   CONSTANT VARCHAR2 (20) := 'Give Raise';
   l_attempts    PLS_INTEGER := 1;
BEGIN
   /* Create a new task with specified name. */
   DBMS_PARALLEL_EXECUTE.CREATE_TASK (c_task_name);

   /* Specify that chunking should be done by ROWID
      for this task, and in groups of 1000. */
   DBMS_PARALLEL_EXECUTE.
   CREATE_CHUNKS_BY_ROWID (task_name => c_task_name
                         , table_owner => USER
                         , table_name => 'EMPLOYEES'
                         , by_row => TRUE
                         , chunk_size => 1000
                          );

   /* Execute this task in parallel, requesting ten
      parallel jobs. If parallel_level = 0, you get
      serial execution. If NULL, then the default
      parallelism will be used. */
  DBMS_PARALLEL_EXECUTE.
      RUN_TASK (task_name => c_task_name
              , sql_stmt => c_update_statement
              , language_flag => DBMS_SQL.native
              , parallel_level => 10
               );

   /* If the task is not yet completed, retry the specified number
      of times using RESUME_TASK. */
   LOOP
      EXIT WHEN DBMS_PARALLEL_EXECUTE.TASK_STATUS (c_task_name) <>
                   DBMS_PARALLEL_EXECUTE.FINISHED
                OR l_attempts > retries_in;
      l_attempts := l_attempts + 1;
      DBMS_PARALLEL_EXECUTE.RESUME_TASK (c_task_name);
   END LOOP;

   /* Either the task is now done or we have run out of retries,
      so time to clean up - drop the task. */
   DBMS_PARALLEL_EXECUTE.DROP_TASK (c_task_name);
END apply_raise;
/

/* User specified chunking by SQL */

CREATE TABLE department_chunks (start_id INTEGER, end_id INTEGER)
/

BEGIN
   INSERT INTO department_chunks
   VALUES (1, 500);

   INSERT INTO department_chunks
   VALUES (501, 1000);

   INSERT INTO department_chunks
   VALUES (1001, 1500);

   COMMIT;
END;
/  

CREATE OR REPLACE  PROCEDURE apply_raise (
   pct_in     IN NUMBER
 , retries_in IN PLS_INTEGER DEFAULT 2
)
IS
   c_update_statement CONSTANT VARCHAR2 (1000)
         := 'UPDATE /*+ ROWID (dda) */ EMPLOYEES emp 
      SET emp.salary = emp.salary * (1.0 + pct_in/100)
      WHERE department_id 
            BETWEEN :starting_deptid AND :ending_deptid' ;
   c_chunk_statement CONSTANT VARCHAR2 (1000) 
         := 'SELECT start_id, end_id FROM department_chunks';
   c_task_name   CONSTANT VARCHAR2 (20) := 'Give Raise';
BEGIN
   DBMS_PARALLEL_EXECUTE.CREATE_TASK (c_task_name);

   DBMS_PARALLEL_EXECUTE.
   CREATE_CHUNKS_BY_SQL (task_name => c_task_name
                         , sql_stmt => c_chunk_statement
                         , by_rowid => FALSE
                          );

  DBMS_PARALLEL_EXECUTE.
      RUN_TASK (task_name => c_task_name
              , sql_stmt => c_update_statement
              , language_flag => DBMS_SQL.native
              , parallel_level => 10
               );

END apply_raise;
/

/* Chunk by numeric column */

CREATE OR REPLACE  PROCEDURE apply_raise (
   pct_in     IN NUMBER
 , retries_in IN PLS_INTEGER DEFAULT 2
)
IS
   c_update_statement CONSTANT VARCHAR2 (1000)
         := 'UPDATE /*+ ROWID (dda) */ EMPLOYEES emp 
      SET emp.salary = emp.salary * (1.0 + pct_in/100)
      WHERE department_id 
            BETWEEN :starting_deptid AND :ending_deptid' ;
   c_task_name   CONSTANT VARCHAR2 (20) := 'Give Raise';
BEGIN
   DBMS_PARALLEL_EXECUTE.CREATE_TASK (c_task_name);

   DBMS_PARALLEL_EXECUTE.
   CREATE_CHUNKS_BY_NUMBER_COL (
        task_name   => c_task_name
      , table_owner => USER
      , table_name  => 'EMPLOYEES'
      , table_column => 'DEPARTMENT_ID'
      , chunk_size => 1000
      );

  DBMS_PARALLEL_EXECUTE.
      RUN_TASK (task_name => c_task_name
              , sql_stmt => c_update_statement
              , language_flag => DBMS_SQL.native
              , parallel_level => 10
               );

END apply_raise;
/