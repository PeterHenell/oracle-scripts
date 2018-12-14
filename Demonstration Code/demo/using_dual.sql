/* Not necessary, unless you need the current date/time
   on the server. */
   
SELECT SYSDATE INTO v_date FROM dual;

/* Here I use dual to make a SQL-only capability available in
   PL/SQL, using DECODE for missing CASE. */
   
SELECT DECODE (myvar, 1, 'Hello', 2, 'Goodbye')
  INTO myvar_desc
  FROM dual;
   
/* Common usage of dual table, but not the best implementation. */

SELECT emp_seq.NEXTVAL 
  INTO :emp.empno
  FROM dual;

/* Better to hide the usage of dual. */
  
:emp.empno := emppkg.nextseq;

:emp.empno := PLVdyn.NEXTseq ('emp_seq', 100);  
  
   
