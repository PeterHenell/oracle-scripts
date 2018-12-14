CREATE OR REPLACE PROCEDURE empact
/* General emp-action procedure */
   (action_in IN VARCHAR2 := 'US', 
    emp_in IN emp.empno%TYPE,
    sal_in IN NUMBER := NULL, 
    comm_in IN NUMBER := NULL)
IS
   updating_salary CONSTANT BOOLEAN DEFAULT 
      UPPER (action_in) = 'US';
   
   setting_totalcomp CONSTANT BOOLEAN DEFAULT 
      UPPER (action_in) = 'TC';
   
   showing_employee CONSTANT BOOLEAN DEFAULT 
      UPPER (action_in) = 'SE';
   
   CURSOR emp_cur (emp_in IN emp.empno%TYPE)
   IS
      SELECT ename, sal, totcomp (sal, comm) totalcomp, hiredate
        FROM emp
       WHERE empno = emp_in;
       
   emp_rec emp_cur%ROWTYPE;

   PROCEDURE updsal 
      (sal_in IN NUMBER, comm_in IN NUMBER := NULL)
   IS
   BEGIN
      UPDATE emp 
         SET sal = totcomp (NVL (sal_in, sal), comm_in) 
       WHERE empno = emp_in;  
      
      IF SQL%ROWCOUNT = 0
      THEN
         p.l ('No employee found for', emp_in);
         
      ELSIF SQL%ROWCOUNT = 1
      THEN
         p.l ('Salary updated to', totcomp (sal_in, comm_in));
         
      ELSIF SQL%ROWCOUNT > 1
      THEN
         p.l ('Multiple records for', emp_in);
         
      END IF;    
   END; 
   
   PROCEDURE println (str IN VARCHAR2, val IN NUMBER)
   IS
   BEGIN
      p.l (emp_rec.ename || ' ' || str, val);      
   END; 
   
   PROCEDURE println (str IN VARCHAR2, val IN DATE)
   IS
   BEGIN
      p.l (emp_rec.ename || ' ' || str, val);      
   END; 
   
BEGIN
   IF updating_salary 
   THEN 
      updsal (sal_in);
           
   ELSIF setting_totalcomp
   THEN
      updsal (sal_in, comm_in);

   ELSIF showing_employee
   THEN
      /* Show the emp information. */
      OPEN emp_cur (emp_in);
      FETCH emp_cur INTO emp_rec;

      IF emp_cur%NOTFOUND 
      THEN 
         p.l ('No employee found for', emp_in);
      ELSE
         println ('salary', emp_rec.sal);
         println ('total comp', emp_rec.totalcomp);
         println ('hiredate', emp_rec.hiredate);
      END IF;
      CLOSE emp_cur;
   END IF;
END;
/
CREATE OR REPLACE PROCEDURE showsal 
(emp_in IN NUMBER) IS vsal NUMBER;
BEGIN
   SELECT sal INTO vsal FROM emp WHERE empno = emp_in;
   p.l (emp_in, vsal);
END;
/