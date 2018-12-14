CREATE OR REPLACE PROCEDURE plvfkys_test (tab IN VARCHAR2)
IS
   t plvfkys.fky_tabtype;
   ct plvfkys.fkycol_tabtype;
BEGIN
   plvfkys.fortab (tab, t, ct);
   IF t.COUNT > 0 
   THEN
      FOR i in t.FIRST .. t.LAST
      LOOP
         p.l (t(i).pky_constraint_name);
         p.l (t(i).pky_table_name);
         p.l (t(i).pky_owner);
      END LOOP;
   END IF;
END;
/
  
 