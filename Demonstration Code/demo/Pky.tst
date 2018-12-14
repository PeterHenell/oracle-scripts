CREATE OR REPLACE PROCEDURE demo_plvpky (tab IN VARCHAR2)
IS
   t plvpky.pky_tabtype;
BEGIN
   t := plvpky.fortab (tab);
   FOR i in t.first .. t.last
   LOOP
      p.l (t(i).constraint_name);
      p.l (t(i).column_name);
      p.l (t(i).position);
   END LOOP;
END;
/   
 