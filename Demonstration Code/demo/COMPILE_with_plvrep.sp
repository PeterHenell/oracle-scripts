CREATE OR REPLACE PROCEDURE compile (file IN VARCHAR2)
IS
   src PLV.maxvc2;
   fid INTEGER;
BEGIN
   fid := PLVrep.fileid (file);
   PLVrep.defseg (fid, 1, 'a', 2000);
   PLVrep.open (fid);
   
   LOOP
      PLVrep.get (fid);
      EXIT WHEN NOT PLVrep.setfound (fid);
      src := src || 
         PLV.ifelse (PLVrep.setsread(fid)=1,NULL,PLVchr.newline_char) || 
         PLVrep.segvals (fid);
   END LOOP;

   PLVdyn.compile (src, TRUE);

   PLVrep.destroy (fid);
EXCEPTION
   WHEN OTHERS 
   THEN
      IF NOT PLVtrc.tracing THEN 
      PLVrep.destroy (fid);
      END IF;
END;
/
      
