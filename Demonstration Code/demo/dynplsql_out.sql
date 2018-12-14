DECLARE
   localvar   INTEGER;
BEGIN
   /* No need to declare a variable for the
      placeholder. */
   EXECUTE IMMEDIATE 'begin :l := 123; end;'
      USING OUT localvar;

   DBMS_OUTPUT.put_line (localvar);
END;
/