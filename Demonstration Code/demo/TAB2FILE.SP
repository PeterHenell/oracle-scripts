CREATE OR REPLACE PROCEDURE tab2file 
   (tab IN VARCHAR2, 
    file IN VARCHAR2 := NULL, 
    delim IN VARCHAR2 := ',')
IS
   tid INTEGER;
   fid INTEGER;
BEGIN
   tid := PLVrep.dbtabid (tab);
   PLVrep.tabsegs (tid, tab);
   
   fid := PLVrep.fileid (NVL (file, tab || '.dat'),
      fixedlen=>PLV.ifelse (delim IS NULL, TRUE, FALSE));
   PLVrep.tabsegs (fid, tab);
      
   PLVrep.copy (tid, fid, segdelim => delim);

   PLVrep.destroy (fid);
   PLVrep.destroy (tid);
   
EXCEPTION
   WHEN OTHERS 
   THEN
      PLVrep.destroy (fid);
      PLVrep.destroy (tid);
      PLVexc.recngo;
END;
/
