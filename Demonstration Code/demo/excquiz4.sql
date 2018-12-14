DECLARE
   v_totsal NUMBER;
   v_ename emp.ename%TYPE;
BEGIN
   /* There are no rows with deptno = -15 */
   SELECT SUM (sal) INTO v_totsal
     FROM emp 
    WHERE deptno = -15;

   DBMS_OUTPUT.PUT_LINE (
      'Total salary: ' || v_totsal);

   SELECT ename INTO v_ename
     FROM emp
    WHERE sal =
       (SELECT MAX (sal)
          FROM emp WHERE deptno = -15);
          
   DBMS_OUTPUT.PUT_LINE (
      'The winner is: ' || v_ename);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.PUT_LINE ('Outer block');
END;
/
