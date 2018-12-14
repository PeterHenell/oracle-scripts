BEGIN
   NULL;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      l_code := SQLCODE;
      l_errm := SQLERRM;

      INSERT INTO errlog
           VALUES (l_code
                 , 'No company for id ' || TO_CHAR (v_id)
                 , 'fixdebt'
                 , SYSDATE
                 , USER);
   WHEN DUP_VAL_ON_INDEX
   THEN
      raise_application_error (-20984, 'Company with name already exists');
   WHEN OTHERS
   THEN
      l_code := SQLCODE;
      l_errm := SQLERRM;

      INSERT INTO errlog
           VALUES (l_code
                 , l_errm
                 , 'fixdebt'
                 , SYSDATE
                 , USER);

      RAISE;
END;
/
