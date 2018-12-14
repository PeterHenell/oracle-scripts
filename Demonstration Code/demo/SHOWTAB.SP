CREATE OR REPLACE PROCEDURE showtab 
   (tab IN VARCHAR2, delim IN VARCHAR2 := ',')
IS
   tid INTEGER;
   fid INTEGER;
BEGIN
   tid := PLVrep.dbtabid (tab);
   PLVrep.tabsegs (tid, tab);
   PLVrep.open (tid, PLVrep.c_read);
   
   fid := PLVrep.screenid (fixedlen=>delim IS NULL);
   PLVrep.tabsegs (fid, tab);   
   PLVrep.open (fid, PLVrep.c_write, segdelim => delim);
   
   LOOP
      PLVrep.get (tid);
      EXIT WHEN NOT PLVrep.setfound (tid);
      PLVrep.transfer (tid, fid);
      PLVrep.put (fid);
   END LOOP;

   PLVrep.close (fid);
   PLVrep.close (tid);
   
EXCEPTION
   WHEN OTHERS 
   THEN 
      PLVrep.close (fid);
      PLVrep.close (tid);
      PLVexc.recngo;
END;
/
      
