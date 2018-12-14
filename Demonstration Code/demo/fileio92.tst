BEGIN
   q$error_manager.set_trace (TRUE);
   q$error_manager.TOSCREEN;
   
   /* this one does not exist */
   bpl (fileio92.fexists ('TEMP', 'abc.ghi'));
   
   /* this one exists */
   bpl (fileio92.fexists ('TEMP', 'abc.def'));
END;
/
