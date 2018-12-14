CREATE OR REPLACE PROCEDURE tab2file 
   (tab IN VARCHAR2, file IN VARCHAR2 := NULL, delim IN VARCHAR2 := ',')
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
      
CREATE OR REPLACE PROCEDURE DEPARTMENT2file (
   loc IN VARCHAR2,
   file IN VARCHAR2 := 'DEPARTMENT.dat',
   delim IN VARCHAR2 := '|'
   )
IS
   fid UTL_FILE.FILE_TYPE;
   line VARCHAR2(32767);
BEGIN
   fid := UTL_FILE.FOPEN (loc, file, 'W');

   FOR rec IN (SELECT * FROM DEPARTMENT)
   LOOP
      line :=
         TO_CHAR (rec.DEPARTMENT_ID) || delim ||
         rec.NAME || delim ||
         TO_CHAR (rec.LOC_ID) || delim ||
         rec.CHANGED_BY || delim ||
         TO_CHAR (rec.CHANGED_ON) || delim ||
         NULL;
      UTL_FILE.PUT_LINE (fid, line);
   END LOOP;
   UTL_FILE.FCLOSE (fid);
END;
/

DECLARE
   v VARCHAR2(30);
   plvrep_tmr tmr_t := tmr_t.make ('PLVREP', &&firstparm);
   habitable_tmr tmr_t := tmr_t.make ('Habitable', &&firstparm);
BEGIN
   plvrep_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      tab2file ('department');
   END LOOP;
   plvrep_tmr.stop;

   habitable_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      department2file ('d:\demo');
   END LOOP;
   habitable_tmr.stop;
END;
/
