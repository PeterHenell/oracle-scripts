CREATE OR REPLACE 
FUNCTION random_string(len NUMBER) RETURN VARCHAR2 IS
  /*
  || Author: 
  ||  - James Padfield 30/06/2000
  || Overview:
  ||  - Simple function to generate a given length string of random chrs.
  ||    Viable characters are given by char_list variable. 
  || Requirements:
  ||  - The DBMS_RANDOM package must be installed.
  || Usage:
  ||  - The following example seeds DBMS_RANDOM then generates
  ||    and displays 5 random strings of length 15
  || 
  ||    BEGIN
  ||      DBMS_RANDOM.SEED(12345678);
  ||      FOR i IN 1..5 LOOP
  ||        DBMS_OUTPUT.PUT_LINE(random_string(15));
  ||      END LOOP;
  ||    END;
  */
  char_list VARCHAR2(40) := 'ABCDEFGHIJKLMNPQRSTUVWXYZ1234567890'; 
  list_len  NUMBER := LENGTH(char_list);
  ret_val   VARCHAR2(255);
BEGIN
  FOR i IN 1..len LOOP
    ret_val := ret_val||SUBSTR(char_list,TRUNC(list_len * DBMS_RANDOM.VALUE) + 1,1); 
  END LOOP;
  RETURN ret_val;
END;
/





