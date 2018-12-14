@ssoo
@fromnth1.sf
@fromnth2.sf
DECLARE
   v_str VARCHAR2(100);
   eachchar_tmr tmr_t := tmr_t.make ('EACH CHAR', &&firstparm);
   instr_tmr tmr_t := tmr_t.make ('INSTR', &&firstparm);
BEGIN
   eachchar_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      v_str := fromnth1 (
         'this is an interesting string for finding "g"', 'g', 2);
      IF indx = 1 THEN p.l (v_str); END IF;
   END LOOP;
   eachchar_tmr.stop;
   
   instr_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      v_str := fromnth2 (
         'this is an interesting string for finding "g"', 'g', 2);
      IF indx = 1 THEN p.l (v_str); END IF;
   END LOOP;
   instr_tmr.stop;
END;
/