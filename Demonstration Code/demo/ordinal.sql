CREATE OR REPLACE FUNCTION to_ordinal (n_in IN NUMBER)
   RETURN VARCHAR2
/*
Convert any number to its ordinal, as in 23 -> 23rd

The rules for constructing an ordinal:

1. If the tens digit of a number is 1, then write "th" after the number. 
   For example: 13th, 19th, 112th, 9,311th.
   
2. If the tens digit is not equal to 1, then use the following table:

   Units Digit    Suffix
        0            th
        1            st
        2            nd
        3            rd
       4-9           th

    For example: 2nd, 7th, 20th, 23rd, 52nd, 135th, 301st.

Source: http://en.wikipedia.org/wiki/English_numerals#Ordinal_numbers
*/   
IS
   c_last_digit   CONSTANT PLS_INTEGER := MOD (n_in, 10);
BEGIN
   RETURN    TO_CHAR (n_in)
          || CASE
             WHEN SUBSTR ('0' || TO_CHAR (n_in), -2, 1) = '1' THEN 'th'
                WHEN c_last_digit = 1 THEN 'st'
                WHEN c_last_digit = 2 THEN 'nd'
                WHEN c_last_digit = 3 THEN 'rd'
                ELSE 'th'
             END;
END to_ordinal;
/

BEGIN
   DBMS_OUTPUT.put_line (to_ordinal (1));
   DBMS_OUTPUT.put_line (to_ordinal (8));
   DBMS_OUTPUT.put_line (to_ordinal (256));
   DBMS_OUTPUT.put_line (to_ordinal (25763));
END;
/