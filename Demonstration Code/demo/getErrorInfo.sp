CREATE OR REPLACE PROCEDURE getErrorInfo (
   errcode OUT INTEGER,
   errtext OUT VARCHAR2)
IS                      
   c_keyword CONSTANT CHAR(14) := 'SQLException: ';
   c_keyword_len CONSTANT PLS_INTEGER := 14;
   v_keyword_loc PLS_INTEGER;
   v_msg VARCHAR2(1000) := SQLERRM;
BEGIN
   v_keyword_loc := INSTR (v_msg, c_keyword);
   IF v_keyword_loc = 0
   THEN
      errcode := SQLCODE;
      errtext := v_msg;
   ELSE
      errtext := SUBSTR (
         v_msg, v_keyword_loc + c_keyword_len);
      errcode := 
         SUBSTR (errtext, 4, 6 /* ORA-NNNNN */);
   END IF;
END;
/   
