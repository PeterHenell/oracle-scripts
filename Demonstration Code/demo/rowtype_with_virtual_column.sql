CREATE TABLE sales_with_vc
(
   sales_id    NUMBER
 , cust_id     NUMBER
 , sales_amt   NUMBER
 , sale_category VARCHAR2 (6)
         GENERATED ALWAYS AS
            (CASE
                WHEN sales_amt <= 10000 THEN 'LOW'
                WHEN sales_amt > 10000 AND sales_amt <= 100000 THEN 'MEDIUM'
                WHEN sales_amt > 100000 AND sales_amt <= 1000000 THEN 'HIGH'
                ELSE 'ULTRA'
             END)
            VIRTUAL
)
/

DECLARE
   l_rec   sales_with_vc%ROWTYPE;
BEGIN
   DBMS_OUTPUT.put_line (l_rec.sale_category);
END;
/