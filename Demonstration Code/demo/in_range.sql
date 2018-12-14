CREATE OR REPLACE PROCEDURE bpl (val IN BOOLEAN)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      CASE val
         WHEN TRUE THEN 'TRUE'
         WHEN FALSE THEN 'FALSE'
         ELSE 'NULL'
      END);
END bpl;
/

CREATE OR REPLACE FUNCTION plch_amount_in_range (
   amount_in   IN NUMBER
 ,  low_in      IN NUMBER
 ,  high_in     IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN (amount_in >= low_in) AND (amount_in <= high_in);
END;
/

BEGIN
   bpl (plch_amount_in_range (100, 90, 120));
   bpl (plch_amount_in_range (100, 100, 120));
   bpl (plch_amount_in_range (100, 90, 100));
   bpl (plch_amount_in_range (70, 90, 120));
END;
/

CREATE OR REPLACE FUNCTION plch_amount_in_range (
   amount_in   IN NUMBER
 ,  low_in      IN NUMBER
 ,  high_in     IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN low_in <= amount_in <= high_in;
END;
/

BEGIN
   bpl (plch_amount_in_range (100, 90, 120));
   bpl (plch_amount_in_range (100, 100, 120));
   bpl (plch_amount_in_range (100, 90, 100));
   bpl (plch_amount_in_range (70, 90, 120));
END;
/

CREATE OR REPLACE FUNCTION plch_amount_in_range (
   amount_in   IN NUMBER
 ,  low_in      IN NUMBER
 ,  high_in     IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN amount_in > low_in AND amount_in < high_in;
END;
/

BEGIN
   bpl (plch_amount_in_range (100, 90, 120));
   bpl (plch_amount_in_range (100, 100, 120));
   bpl (plch_amount_in_range (100, 90, 100));
   bpl (plch_amount_in_range (70, 90, 120));
END;
/

CREATE OR REPLACE FUNCTION plch_amount_in_range (
   amount_in   IN NUMBER
 ,  low_in      IN NUMBER
 ,  high_in     IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN amount_in >= low_in OR amount_in <= high_in;
END;
/

BEGIN
   bpl (plch_amount_in_range (100, 90, 120));
   bpl (plch_amount_in_range (100, 100, 120));
   bpl (plch_amount_in_range (100, 90, 100));
   bpl (plch_amount_in_range (70, 90, 120));
END;
/