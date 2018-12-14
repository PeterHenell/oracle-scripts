CREATE OR REPLACE PROCEDURE file2tab 
   (file IN VARCHAR2, tab IN VARCHAR2, 
    delim IN VARCHAR2 := ',', fixedlen IN BOOLEAN := FALSE)
IS
   tid INTEGER := PLVrep.dbtabid (tab, '=' || tab);
   fid INTEGER := PLVrep.fileid (file, '=' || tab, fixedlen => fixedlen);
BEGIN
   PLVrep.copy (fid, tid, segdelim => delim);
END;
/
