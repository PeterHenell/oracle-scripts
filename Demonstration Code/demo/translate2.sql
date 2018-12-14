BEGIN
   /* Remove all digits (0-9) from the string. */
   sys.DBMS_OUTPUT.put_line (
      TRANSLATE ('S1t2e3v4e56n'
               , '1234567890'
               , ''));
   sys.DBMS_OUTPUT.put_line (
      TRANSLATE ('S1t2e3v4e56n'
               , 'A1234567890'
               , 'A'));
END;
/