create or replace PROCEDURE showfile (file IN VARCHAR2)
IS
  fid INTEGER := PLVrep.fileid (file);
  sid INTEGER := PLVrep.screenid (fixedlen => TRUE);
BEGIN     
  PLVrep.defsegs (fid, 'SALARY.n10,NAME.v15,HIREDATE.d30');
  PLVrep.repsegs (sid, fid);
  p.l (PLVrep.segnames (sid));
  PLVrep.copy (fid, sid, segdelim=>',');
END;
/