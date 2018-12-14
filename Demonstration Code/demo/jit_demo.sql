CREATE OR REPLACE PROCEDURE jit_demo
IS
   p_empdet   employee_pkg.tbl_emp_details;
BEGIN
   employee_pkg.get_employee_details (7499, p_empdet);

   IF p_empdet IS NOT NULL
   THEN
      IF p_empdet.COUNT > 0
      THEN
         DBMS_OUTPUT.put_line (
               'ENAME = '
            || p_empdet (p_empdet.FIRST).ename
         );
      END IF;
   END IF;

   DBMS_DEBUG.debug_off;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_DEBUG.debug_off;
END;
/
