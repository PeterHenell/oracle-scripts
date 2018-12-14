CREATE OR REPLACE PACKAGE emp_pkg
IS
   l_employees employees%ROWTYPE;
   
   TYPE comp_rectype IS RECORD (salcomp emp.sal%TYPE, total_salary NUMBER);

   FUNCTION bonus_amt (emp_in IN emp.empno%TYPE, comp_in IN comp_rectype)
      RETURN NUMBER;
END;
/

DECLARE
   comp_rec   emp_pkg.comp_rectype;
BEGIN
   comp_rec.salcomp := 10000;
   DBMS_OUTPUT.put_line (emp_pkg.bonus_amt (7499, comp_rec));
END;
/