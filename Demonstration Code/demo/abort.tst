DELETE FROM error_log
/

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   RAISE NO_DATA_FOUND;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      errpkg.record_error (SQLCODE
                          ,'No company found!'
                          ,abort_in      => FALSE
                          );
      RAISE;						  
						 
END proc1;
/

BEGIN
   errpkg.reset_status;
   proc1;
   
EXCEPTION
   WHEN OTHERS
   THEN
      errpkg.record_error (SQLCODE, 'Error from proc1!');
END;
/

-- There will be two rows in the log.

SELECT *
  FROM error_log
/

-- Now try it with abort.

DELETE FROM error_log
/

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   RAISE NO_DATA_FOUND;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      errpkg.record_error (SQLCODE
                          ,'No company found!'
                          ,abort_in      => TRUE
                          );					  
						 
END proc1;
/

BEGIN
   errpkg.reset_status;
   proc1;
   
EXCEPTION
   WHEN OTHERS
   THEN
      errpkg.record_error (SQLCODE, 'Error from proc1!');
END;
/

-- Now just a single row in the log.

SELECT *
  FROM error_log
/

