DECLARE
   results ndsutil.results_tt;
   indx INTEGER;
BEGIN
   results := ndsutil.countby ('employee', 'department_id', atleast => 3);
   indx := results.FIRST;

   LOOP
      EXIT WHEN indx IS NULL;
      p.l (results (indx).val, results (indx).countby);
      indx := results.next (indx);
   END LOOP;
END;
/   