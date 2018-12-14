begin
BEGIN
   INSERT INTO EMP (empno) VALUES (2);

EXCEPTION
   WHEN OTHERS
   THEN
      ps_exception.handle
	     ('anon', SQLCODE, ps_exception.c_rec_halt);
END;
/*
exception
   when others then commit;
   */
end;
/
