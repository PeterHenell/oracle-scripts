SET VERIFY OFF
@@ssoo
/* 
|| Purpose: Test efficiency of PLS_INTEGER 
||  Author: Steven Feuerstein
||
|| All rights reserved, PL/Solutions, 1999
*/
DECLARE  
   withInt tmr_t := tmr_t.make ('INTEGER', &&firstparm);
   withPLSInt tmr_t := tmr_t.make ('PLS_INTEGER', &&firstparm);
   
   int1 INTEGER;
   int2 INTEGER;
   int3 INTEGER;
   
   plsint1 PLS_INTEGER;
   plsint2 PLS_INTEGER;
   plsint3 PLS_INTEGER;
   
BEGIN
   withInt.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      int2 := MOD (indx, 10);
      int3 := MOD (indx, 3);
      int1 := int2 * int3;
      int2 := int1 - int3;
      int3 := int2 ** 5;
   END LOOP;
   withInt.stop;
      
   withPLSint.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      PLSint2 := MOD (indx, 10);
      PLSint3 := MOD (indx, 3);
      PLSint1 := PLSint2 * PLSint3;
      PLSint2 := PLSint1 - PLSint3;
      PLSint3 := PLSint2 ** 5;
   END LOOP;
   withPLSint.stop;
END;
/   
