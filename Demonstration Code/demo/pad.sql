DECLARE
   l_first   VARCHAR2 (10) := 'Steven';
   l_last    VARCHAR2 (20)
                := 'Feuerstein';
   l_phone   VARCHAR2 (20)
                := '773-426-9093';
BEGIN
   /* Indent the sub-header by 3 characters */
   sys.DBMS_OUTPUT.put_line ('Header');
   sys.DBMS_OUTPUT.put_line (
      LPAD ('Sub-header', 13));

   /* Add "123" to the end of the string,
      until the 20 character is reached. */
   sys.DBMS_OUTPUT.put_line (
      RPAD ('abc', 20, '123'));

   /* Display headers and then values
      to fit within the columns. */
   sys.DBMS_OUTPUT.put_line (
     /*1234567890x12345678901234567890x*/
      'First Name Last Name            Phone');
   sys.DBMS_OUTPUT.put_line (
         RPAD (l_first, 10)
      || ' '
      || RPAD (l_last, 20)
      || ' '
      || l_phone);
END;
/