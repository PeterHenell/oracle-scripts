DECLARE
   l_first    VARCHAR2 (10) := 'Steven';
   l_middle   VARCHAR2 (5) := 'Eric';
   l_last     VARCHAR2 (20)
                 := 'Feuerstein';
   l_empty    VARCHAR2 (10);
BEGIN
   /* Use the CONCAT function */
   sys.DBMS_OUTPUT.put_line (
      CONCAT ('Steven', 'Feuerstein'));
   /* Use the || operator */
   sys.DBMS_OUTPUT.put_line (
         l_first
      || ' '
      || l_middle
      || ' '
      || l_last);

   /* Impact of NULLs on concatenation */
   sys.DBMS_OUTPUT.put_line (
      CONCAT ('Steven', l_empty));
   /* Use the || operator */
   sys.DBMS_OUTPUT.put_line (
      l_first || ' ' || l_empty);
END;
/