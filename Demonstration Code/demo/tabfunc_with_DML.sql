create table e3 as select * from employees;

CREATE OR REPLACE FUNCTION stockpivot (dataset refcur_pkg.refcur_t)
   RETURN tickertypeset
IS
   out_obj     tickertype    := tickertype (NULL, NULL, NULL, NULL);

   --
   TYPE dataset_tt IS TABLE OF stocktable%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_dataset   dataset_tt;
   retval      tickertypeset := tickertypeset ();
   l_row       PLS_INTEGER;
BEGIN
   DELETE FROM e3;

   FETCH dataset
   BULK COLLECT INTO l_dataset;

   CLOSE dataset;

   l_row := l_dataset.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      out_obj.ticker := l_dataset (l_row).ticker;
      out_obj.pricetype := 'O';
      out_obj.price := l_dataset (l_row).open_price;
      out_obj.pricedate := l_dataset (l_row).trade_date;
      retval.EXTEND;
      retval (retval.LAST) := out_obj;
      --
      out_obj.pricetype := 'C';
      out_obj.price := l_dataset (l_row).close_price;
      out_obj.pricedate := l_dataset (l_row).trade_date;
      retval.EXTEND;
      retval (retval.LAST) := out_obj;
      --
      l_row := l_dataset.NEXT (l_row);
   END LOOP;

   RETURN retval;
END;
/

DECLARE
   CV   sys_refcursor;
BEGIN
   OPEN CV FOR
      SELECT *
        FROM TABLE (stockpivot (CURSOR (SELECT *
                                          FROM stocktable)));

   COMMIT;
END;
/