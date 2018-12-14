CREATE OR REPLACE PROCEDURE show_datecode (file IN VARCHAR2)
IS
   id INTEGER := PLVrep.fileid (file, bidir => TRUE);
   text VARCHAR2(120);
BEGIN
   PLVrep.defseg (id, 1, 'a', 120);
   PLVrep.open (id);
   PLVrep.getall (id);
   FOR line IN 1 .. PLVrep.setsread (id)
   LOOP
      text := PLVrep.segvals (id, line);
      IF PLV2000.relevant (text)
      THEN
         p.l (text);
      END IF;
   END LOOP;
   PLVrep.destroy (id);
END;
/