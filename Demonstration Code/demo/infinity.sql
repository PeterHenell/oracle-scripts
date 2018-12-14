/* Formatted on 2001/05/16 05:17 (RevealNet Formatter v4.4.0) */
DECLARE
   date1 DATE;
   date2 DATE;
BEGIN
   --IF (date1 = date2 OR (date1 IS NULL AND date2 IS NULL)) THEN
   
   WHILE SYSDATE = SYSDATE
   LOOP
      i :=   LEAST (i, 1000)
           + 1;
   END LOOP;

   p.l (i);
END;
