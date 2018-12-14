CREATE OR REPLACE PACKAGE pipeline
IS
   TYPE ticker_tt IS TABLE OF tickertype;

   FUNCTION stockpivot_pl (dataset refcur_pkg.refcur_t)
      RETURN tickertypeset PIPELINED;
END pipeline;
/

CREATE OR REPLACE PACKAGE BODY pipeline
IS
   FUNCTION stockpivot_pl (dataset refcur_pkg.refcur_t)
      RETURN tickertypeset PIPELINED
   IS
      out_obj   tickertype     := tickertype (NULL, NULL, NULL, NULL);
      in_rec    dataset%ROWTYPE;
   BEGIN
      LOOP
         FETCH dataset
          INTO in_rec;

         EXIT WHEN dataset%NOTFOUND;
         -- first row
         out_obj.ticker := in_rec.ticker;
         out_obj.pricetype := 'O';
         out_obj.price := in_rec.open_price;
         out_obj.pricedate := in_rec.trade_date;
         PIPE ROW (out_obj);
         -- second row
         out_obj.pricetype := 'C';
         out_obj.price := in_rec.close_price;
         out_obj.pricedate := in_rec.trade_date;
         PIPE ROW (out_obj);
      END LOOP;

      CLOSE dataset;

      RETURN;
   END;
END pipeline;
/

INSERT INTO tickertable
   SELECT *
     FROM TABLE (pipeline.stockpivot_pl (CURSOR (SELECT *
                                                   FROM stocktable)))
    WHERE ROWNUM < 10;