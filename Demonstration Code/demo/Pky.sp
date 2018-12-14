CREATE OR REPLACE PROCEDURE showpky (tab IN VARCHAR2)
IS
   t plvpky.pky_tabtype;
BEGIN
   t := plvpky.fortab (tab);
   
   p.l ('Primary Key Info for ' || tab);
    
   IF t.FIRST IS NOT NULL
   THEN
      FOR pkyind in t.FIRST .. t.LAST
      LOOP
         p.l (t(pkyind).position);
         p.l (t(pkyind).constraint_name);
         p.l (t(pkyind).column_name);
      END LOOP;
   END IF;
END;
/
  
 