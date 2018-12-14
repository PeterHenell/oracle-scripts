DECLARE
   cons    PLVcons.cons_tabtype;
   conscol PLVcons.conscol_tabtype;
   colrec  PLVcons.conscol_rectype;
   consrow PLS_INTEGER;
BEGIN
   PLVcons.fortab (
      'employee',
      cons,
      conscol,
      USER,
      constype => PLVcons.c_check,
      consstatus => PLVcons.c_enabled,
      colsuffix => '_in');

   /* For each constraint... */
   consrow := cons.FIRST;
   LOOP
      EXIT WHEN consrow IS NULL;

      p.l ('');
      p.l ('Constraint ' || cons(consrow).constraint_name);
      
      /* For each column in the constraint... */
      FOR colind IN 1 .. cons(consrow).column_count
      LOOP
         colrec := PLVcons.nthcol (conscol, consrow, colind);
         p.l ('column = ' || colrec.column_name);
         p.l ('converted column = ' || colrec.converted_column_name);
      END LOOP;
      consrow := cons.NEXT (consrow);
   END LOOP;
END;
/
