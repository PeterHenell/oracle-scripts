@ssoo
DECLARE
   v_loc PLS_INTEGER := 1;
   v_start  PLS_INTEGER := 1;
   v_new VARCHAR2(2000);
   v_old VARCHAR2(2000) :=
      '         [if]lakjd;flkajdf;lkajdflkadsfl;kasdf;laskjdfla;skfjd';
   rtrim_trm tmr_t := tmr_t.make ('TRIM-LENGTH', &&firstparm);
   substr_tmr tmr_t := tmr_t.make ('SUBSTR', &&firstparm);
BEGIN
   rtrim_trm.go;
   v_new := LTRIM (v_old);
   FOR indx IN 1 .. &&firstparm
   LOOP
      v_loc := LENGTH (v_old) - LENGTH (v_new) + 1;
   END LOOP;
   rtrim_trm.stop;
   
   substr_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      LOOP
         v_new := SUBSTR (v_old, v_start, 1);
         EXIT WHEN v_new != ' ';
         v_start := v_start + 1;
      END LOOP; 
   END LOOP;
   substr_tmr.stop;
END;
/