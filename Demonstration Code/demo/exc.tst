CREATE OR REPLACE PROCEDURE empexc (emp_in IN emp.empno%TYPE)
IS
   my_exc EXCEPTION;
   v_ename VARCHAR2(10);
BEGIN
   PLVexc.nobailout;

   IF emp_in IS NULL
   THEN
      RAISE VALUE_ERROR;
   END IF;
   
   IF emp_in < 0
   THEN
      RAISE my_exc;
   END IF;
   
   IF emp_in > 10000
   THEN
      RAISE DUP_VAL_ON_INDEX;
   END IF;
   
   SELECT ename INTO v_ename
     FROM emp
    WHERE empno = emp_in;
   
   p.l (v_ename);
EXCEPTION
   WHEN VALUE_ERROR /* NULL emp_id */
   THEN
      PLVexc.recNbailout;
      
   WHEN NO_DATA_FOUND
   THEN
      PLVexc.recNgo ('No employee record for ' || emp_in);
      
   WHEN OTHERS
   THEN
      PLVexc.recNstop;
END;
/
