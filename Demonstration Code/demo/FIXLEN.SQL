DECLARE
   fileid INTEGER := 
      PLVrep.fileid ('fixlen.dat', 'n10,v15,d10', fixedlen=>TRUE);
BEGIN
   PLVdate.setdeffmt ('MM/DD/YYYY'); 
   PLVrep.open (fileid);
   LOOP
      PLVrep.get (fileid);
      EXIT WHEN PLVrep.setNOTfound (fileid);
      p.l (PLVrep.segvals (fileid, segdelim=> '"'));
   END LOOP;
   PLVrep.destroy (fileid);
END;
/
