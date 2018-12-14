DECLARE
/*
   Check to see if a particular column is part of a constraint. If so,
   display the column name. 
*/
   cons    PLVcons.cons_tabtype;
   conscol PLVcons.conscol_tabtype;
BEGIN
   PLVcons.fortab (
      '&&firstparm',
      cons,
      conscol,
      USER);

   FOR rec IN (SELECT * FROM user_tab_columns WHERE table_name = UPPER ('&&firstparm'))
   LOOP
      IF PLVcons.isconscol (conscol, rec.column_name)
      THEN
         p.l ('Column ' || rec.column_name || ' is referenced in a constraint.');
      END IF;
   END LOOP;
END;
/
