DECLARE
   v_context PLV_log.context%TYPE;
   v_code PLV_log.code%TYPE;
   v_text PLV_log.text%TYPE;
   v_create_by PLV_log.create_by%TYPE;
   v_create_ts PLV_log.create_ts%TYPE;

BEGIN
   FOR row_ind IN 1 .. PLVlog.pstab_count
   LOOP
      PLVlog.get_line 
         (row_ind, 
          v_context, v_code, v_text, 
          v_create_by, v_create_ts);

      IF v_create_ts BETWEEN TRUNC (SYSDATE)
                         AND TRUNC (SYSDATE+1) AND
         v_context = '&&firstparm'
      THEN
         p.l (v_text);
      END IF;
   END LOOP;
END;
/
