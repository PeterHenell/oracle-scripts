CREATE OR REPLACE PROCEDURE db2ps (tab IN VARCHAR2, delim IN VARCHAR2 := ',')
IS
   dbid INTEGER;
   psid INTEGER;
   t plvtab.vc2000_table;
BEGIN
   dbid := PLVrep.dbtabid (tab); p.l (dbid);
   psid := PLVrep.pstabid; p.l (psid);

   PLVrep.tabsegs (dbid, tab);
   PLVrep.tabsegs (psid, tab);
   
   PLVrep.open (dbid, PLVrep.c_read);
   PLVrep.open (psid, PLVrep.c_write, segdelim => delim);
   
   LOOP
      PLVrep.get (dbid);
      EXIT WHEN NOT PLVrep.setfound (dbid);
      PLVrep.transfer (dbid, psid);
      PLVrep.put (psid);
   END LOOP;

   PLVrep.retrieve (psid, t);
   PLVtab.disp (t);

   --PLVrep.close (psid);
   --PLVrep.close (dbid);
   
EXCEPTION
   WHEN OTHERS 
   THEN 
      --PLVrep.close (psid);
      --PLVrep.close (dbid);
      PLVexc.recngo;
END;
/
      
