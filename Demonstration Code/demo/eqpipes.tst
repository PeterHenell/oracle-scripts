REM
REM Pass in 1 for &&firstparm and pipes should be equal
REM Pass in 2 for &&firstparm and pipes should be different
REM 
@@employee_pipe.pkg
@@pl.sp
@@bpl.sp
@@eqpipes.sf

DECLARE
   stat PLS_INTEGER;
BEGIN
   DBMS_PIPE.PURGE ('pipe1');
   DBMS_PIPE.PURGE ('pipe2');
   
   FOR rec IN (SELECT *
                 FROM employee)
   LOOP
      -- Populate first pipe
      employee_pipe.setpipe ('pipe1');
      stat := employee_pipe.send (rec);
      
      -- Populate second pipe
      employee_pipe.setpipe ('pipe2');

      IF &&firstparm = 1
      THEN
         stat := employee_pipe.send (rec);
      ELSIF &&firstparm = 2
      THEN
         stat := employee_pipe.send (rec);
         stat := employee_pipe.send (rec);
      END IF;
   END LOOP;

   bpl (eqpipes ('pipe1', 'pipe2'));
END;
/

