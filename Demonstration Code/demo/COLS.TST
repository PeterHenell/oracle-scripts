CREATE OR REPLACE PROCEDURE plvcols_test (tab IN VARCHAR2)
IS
   t plvcols.col_tabtype;
BEGIN
   t := plvcols.fortab (tab);
   IF t.COUNT > 0 
   THEN
      FOR i in t.FIRST .. t.LAST
      LOOP
         p.l (t(i).column_name);
         p.l (t(i).data_type);
         p.l (t(i).data_default);
         p.l (t(i).nullable);
      END LOOP;
   END IF;
END;
/
  
 