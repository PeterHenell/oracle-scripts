create or replace PROCEDURE give_thanks (year1 IN INTEGER, year2 IN INTEGER) 
IS
   end_of_oct DATE;
BEGIN
   FOR yearnum IN year1 .. year2
   LOOP
      end_of_oct := PLVdate.val ('10/31/' || TO_CHAR(yearnum));
      p.l (NEXT_DAY (end_of_oct, 'THURSDAY') + 21);
      PLVdate.set_nonbizday (NEXT_DAY (end_of_oct, 'THURSDAY') + 21);
   END LOOP;
END;
/