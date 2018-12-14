/*
If n1 != 0, then the remainder is n2 - (n1*N) where N is the integer nearest n2/n1. 
            If n2/n1 equals x.5, then N is the nearest even integer.
*/

BEGIN
   DBMS_OUTPUT.put_line (15 - 4 * ROUND (15 / 4));

   DBMS_OUTPUT.put_line (REMAINDER (15, 4));
   
   dbms_output.put_line ( ROUND (15 / 6) );

   DBMS_OUTPUT.put_line (15 - 6 * ROUND (15 / 6));

   DBMS_OUTPUT.put_line (REMAINDER (15, 6));
END;
/
