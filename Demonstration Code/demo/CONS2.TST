DECLARE
   c PLVcons.cons_tabtype;
   cc PLVcons.conscol_tabtype;
BEGIN
   PLVcons.fortab (
      'employee',
      c,
      cc,
      constype => NULL,
      consstatus => 'ENABLED',
      colsuffix => '_in'
   );
   p.l ('number of constraints', c.COUNT);
   FOR i IN c.FIRST .. c.LAST
   LOOP
      p.l (c (i).constraint_name);
      p.l (c (i).column_count);
   END LOOP;
END;
/
