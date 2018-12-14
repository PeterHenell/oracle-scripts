CREATE OR REPLACE PROCEDURE showcons (tab IN VARCHAR2, tp IN VARCHAR2)
IS
   c PLVcons.cons_tabtype;
   cc PLVcons.conscol_tabtype;
   r PLVcons.conscol_rectype;
   k INTEGER;
BEGIN
   PLVcons.fortab (
      tab,
      c,
      cc,
      constype => 'C',
      consstatus => 'ENABLED',
      colsuffix => '_in'
   );
   IF c.COUNT > 0
   THEN
      FOR i IN 1 .. c.COUNT
      LOOP
         p.l ('Constraint: ' || c (i).constraint_name);
         p.l ('   ' || c (i).column_count || ' columns:');
         
         /* Indexed read through columns table */
         FOR j IN 1 .. c (i).column_count
         LOOP
            r := PLVcons.nthcol (cc, i, j);
            p.l ('      ' || r.column_name);
         END LOOP;
      END LOOP;
      
      /* Straight read through columns table */
      p.l ('');
      p.l ('All columns across all constraints:');
      k := cc.FIRST;
      LOOP
         EXIT WHEN k IS NULL;
         p.l ('   ' || cc (k).column_name, k);
         k := cc.NEXT (k);
      END LOOP;
   ELSE
      p.l ('no constraints');
   END IF;
END;
/

