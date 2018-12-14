CREATE OR REPLACE PROCEDURE empexc (
   emp_in IN emp.empno%TYPE,
   sal_in IN NUMBER)
IS
   my_exc EXCEPTION;
   v_ename VARCHAR2(10);

   PROCEDURE setsubst  (context IN VARCHAR2)
   IS
   BEGIN
      PLVexc.set_context ('empexc', 
         emp_in,
         sal_in,
         PLVdate.to_char (SYSDATE), 
         delim => '-');
   END;

BEGIN
   PLVexc.nobailout;

   setsubst ('null check');

   IF emp_in IS NULL
   THEN
      RAISE VALUE_ERROR;
   END IF;
   
   setsubst ('negative check');

   IF emp_in < 0
   THEN
      RAISE my_exc;
   END IF;
   
   setsubst ('really big');

   IF emp_in > 10000
   THEN
      RAISE DUP_VAL_ON_INDEX;
   END IF;
   
   setsubst ('implicit query');

   SELECT ename INTO v_ename
     FROM emp
    WHERE empno = emp_in;
   
   p.l (v_ename);
EXCEPTION
   WHEN OTHERS
   THEN
      PLVexc.recNgo (
         PLVsubst.string (
            PLVmsg.text (SQLCODE), 
            PLVexc.context_data, 
            PLVexc.context_delim));
END;
/
DECLARE
   PROCEDURE try_twice (err_in IN INTEGER, emp_in IN INTEGER, sal_in IN NUMBER)
   IS
      v_template PLV.dbmaxvc2 := 'Occurred for employee %s with a salary of %s at %s';
   BEGIN
      empexc (emp_in, sal_in);

      IF err_in IS NOT NULL
      THEN
         PLVmsg.add_text (err_in, v_template);
      END IF;

      empexc (emp_in, sal_in);
   END;
BEGIN
   PLVmsg.del;
   PLVmsg.norestrict;

   PLVexc.nolog;
   PLVexc.trc;
   PLVtrc.nodispmod;

   try_twice (NULL, 7369, 1000);

   try_twice (-1, 10001, 1000);

   try_twice (-6502, NULL, 1000);

   try_twice (100, 7599, 1000);
END;
/
