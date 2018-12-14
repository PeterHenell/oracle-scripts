create or replace  PACKAGE emp_pkg
IS
   TYPE comp_rectype IS RECORD 
     (salcomp emp.sal%TYPE, total NUMBER);

   FUNCTION bonus_amt 
     (emp_in IN emp.empno%TYPE,
      comp_in IN comp_rectype) RETURN NUMBER;
END;
/

DECLARE   
   comp_rec emp_pkg.comp_rectype;
BEGIN  
   comp_rec.salcomp := 10000;
   p.l (emp_pkg.bonus_amt (7499, comp_rec));
END;
/
