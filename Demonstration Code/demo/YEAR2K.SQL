CREATE OR REPLACE PROCEDURE year2000 (spec IN VARCHAR2) /* One module at a time... */ 
IS
   fromid INTEGER;
   toid INTEGER;
BEGIN
   /* For now just display to screen. */
   toid := PLVasrc.repid (PLV.screen, allcolumns => FALSE);
   PLVrep.open (toid, PLVrep.c_write);
   
   fromid := PLVasrc.repid;
   PLVasrc.setobj (fromid, spec);
   PLVrep.open (fromid, PLVrep.c_read);
   
   LOOP
      PLVrep.get (fromid);
      EXIT WHEN NOT PLVrep.setfound (fromid);
      PLVrep.transfer (fromid, toid);
      PLVrep.put (toid);
   END LOOP;
   
   PLVrep.destroy (fromid);
   PLVrep.destroy (toid);
END;
/
   
