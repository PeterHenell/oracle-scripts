BEGIN
   /* Find the location of the first "e" */
   sys.DBMS_OUTPUT.put_line (
      INSTR ('steven feuerstein', 'e'));
      
   /* Find the location of the 6th "e" */
   sys.DBMS_OUTPUT.put_line (
      INSTR ('steven feuerstein'
           , 'e'
           , 6));
           
   /* Find the location of the first "e",
      starting from the 6th position from
      the end of string. */
   sys.DBMS_OUTPUT.put_line (
      INSTR ('steven feuerstein'
           , 'e'
           , -6));
           
   /* Find the location of the 3rd "e"
      starting from the 6th position from
      the end of string. */
   sys.DBMS_OUTPUT.put_line (
      INSTR ('steven feuerstein'
           , 'e'
           , -6
           , 3));
END;
/