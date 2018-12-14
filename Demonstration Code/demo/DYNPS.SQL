<<a>>
DECLARE
   n NUMBER;
BEGIN   
   plvdyn.plsql ('n := 5');
EXCEPTION
   WHEN OTHERS THEN p.l(SQLCODE);
END;
/   