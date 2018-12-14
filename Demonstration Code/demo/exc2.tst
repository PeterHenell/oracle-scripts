CREATE OR REPLACE PROCEDURE empexc2 
  (list_in IN VARCHAR2)
IS
   v_ename VARCHAR2(10);
BEGIN
   PLVseg.loadstg (list_in, ',', numsegs => 1);
   FOR segind IN 1 .. PLVseg.numitems
   LOOP
      BEGIN
         empexc (PLVseg.item (segind));
      EXCEPTION
         WHEN dup_val_on_index
         THEN
            PLVexc.go;
            
         WHEN VALUE_ERROR
         THEN
            PLVexc.recNgo;
            
         WHEN OTHERS
         THEN
            PLVexc.recNstop;
      END;
   END LOOP;
END;
/
