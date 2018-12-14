CREATE OR REPLACE PROCEDURE test_unpack (disp IN BOOLEAN := FALSE)
/*
|| Test the generic unpack procedure in dbpipe.sql.
*/
IS	
   c_pipe CONSTANT VARCHAR2(7) := 'emppipe';
	stat PLS_INTEGER;
	erec emp%ROWTYPE;
	msgtab dbpipe.message_tbltype;
BEGIN
   FOR rec IN (SELECT * FROM emp)
	LOOP
	   DBMS_PIPE.RESET_BUFFER;
      DBMS_PIPE.PACK_MESSAGE (rec.ename);
      DBMS_PIPE.PACK_MESSAGE (rec.empno);
      DBMS_PIPE.PACK_MESSAGE (rec.hiredate);
      DBMS_PIPE.PACK_MESSAGE (rec.sal);
      stat := DBMS_PIPE.SEND_MESSAGE (c_pipe, timeout => 0);
	END LOOP;

   /* First, check to see what happens to the buffer if we
	   make a mistake. */
   stat := DBMS_PIPE.RECEIVE_MESSAGE (c_pipe, timeout => 0);
	BEGIN
      DBMS_PIPE.UNPACK_MESSAGE (stat);
	EXCEPTION
	   WHEN OTHERS
		THEN
		   p.l ('Unpack error: ' || SQLERRM);
			DBMS_PIPE.UNPACK_MESSAGE (erec.ename);

         /* You will see that the data is not lost. */
			p.l ('Next packet', erec.ename);
   END;

   /* Grab the contents using the unpack utility. This way it is not
      necessary to write exception handlers. */
   LOOP
	   stat := DBMS_PIPE.RECEIVE_MESSAGE (c_pipe, timeout => 0);
	   EXIT WHEN stat != 0;
      dbpipe.unpack_to_tbl (msgtab, disp);  
      
      /* Still will write an IF statement to go through the contents
         of the PL/SQL table. */    
	END LOOP;
END;
/

