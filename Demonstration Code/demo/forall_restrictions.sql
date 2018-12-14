/* Bind array must be integer indexed 

   PLS-00657: Implementation restriction: bulk SQL with 
              associative arrays with VARCHAR2 key is not supported.
*/

DECLARE
   TYPE int_by_string_t IS TABLE OF PLS_INTEGER
                              INDEX BY VARCHAR2 (100);

   l_ids   int_by_string_t;
BEGIN
   l_ids (1) := 138;
   l_ids (2) := 147;

   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE employees
         SET last_name = UPPER (last_name)
       WHERE employee_id = l_ids (indx);

   ROLLBACK;
END;
/

/* Only one DML statement per FORALL */

DECLARE
   l_ids     DBMS_SQL.number_table;
   l_names   DBMS_SQL.varchar2a;
BEGIN
   l_ids (1) := 138;
   l_ids (2) := 147;
   
   FORALL indx IN 1 .. l_ids.COUNT
      DELETE FROM employees 
       WHERE employee_id = -1 * l_ids (indx);
      UPDATE employees
         SET last_name = l_names (indx)
       WHERE employee_id = l_ids (indx);

   ROLLBACK;
END;
/

/* Bind array must be densely-filled 

   ORA-22160: element at index [N] does not exist
*/

DECLARE
   l_ids   DBMS_SQL.number_table;
BEGIN
   l_ids (1) := 138;
   l_ids (20) := 147;

   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE employees
         SET last_name = UPPER (last_name)
       WHERE employee_id = l_ids (indx);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   ROLLBACK;
END;
/

/* Indexes cannot be expressions

   PLS-00430: FORALL iteration variable INDX 
              is not allowed in this context
*/

DECLARE
   l_ids     DBMS_SQL.number_table;
BEGIN
   l_ids (1) := 138;
   l_ids (2) := 147;
   
   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE employees
         SET last_name = UPPER (last_name)
       WHERE employee_id = l_ids (indx*2);

   ROLLBACK;
END;
/