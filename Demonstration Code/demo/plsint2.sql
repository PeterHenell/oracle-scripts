SET TIMING ON
DECLARE
   lcv PLS_INTEGER := 0;
   dum NUMBER;
BEGIN
   WHILE lcv <= 1000000
   LOOP
      lcv := lcv + 1;
   END LOOP;
END;
/
DECLARE
   lcv NUMBER := 0;
   dum NUMBER;
BEGIN
   WHILE lcv <= 1000000
   LOOP
      lcv := lcv + 1;
   END LOOP;
END;
/
DECLARE
   lcv BINARY_INTEGER := 0;
   dum NUMBER;
BEGIN
   WHILE lcv <= 1000000
   LOOP
      lcv := lcv + 1;
   END LOOP;
END;
/

  	