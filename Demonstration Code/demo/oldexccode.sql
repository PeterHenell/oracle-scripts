1. Really bad code

EXCEPTION
   WHEN NO_DATA_FOUND THEN 
      v_msg := 'No company for id ' || TO_CHAR (v_id);
      v_err := SQLCODE;
      v_prog := 'fixdebt';
      INSERT INTO errlog VALUES
         (v_err, v_msg, v_prog, SYSDATE, USER);

   WHEN OTHERS THEN
      v_err := SQLCODE;
      v_msg := SQLERRM;
      v_prog := 'fixdebt';
      INSERT INTO errlog VALUES
         (v_err, v_msg, v_prog, SYSDATE, USER);
      RAISE;

and this

IF :NEW.birthdate > ADD_MONTHS (SYSDATE, -1 * 18 * 12)
THEN
   RAISE_APPLICATION_ERROR 
      (-20070, ‘Employee must be 18.’);
END IF;
	  
2. What I used to recommend

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN 
      errpkg.recNgo (
         SQLCODE, 
         ' No company for id ' || TO_CHAR (v_id));

   WHEN OTHERS   
   THEN
      errpkg.recNstop; 
END;

and 

PROCEDURE validate_emp (birthdate_in IN DATE) IS
BEGIN
   IF ADD_MONTHS (SYSDATE, 18 * 12 * -1) < birthdate_in
   THEN
      errpkg.raise (errnums.en_must_be_18);
   END IF;
END;

	  
