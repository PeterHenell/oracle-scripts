/*
NOTE: This code is taken from Oracle's HTML documentation
*/

CREATE TYPE PurchaseOrder_objtyp AUTHID CURRENT_USER AS OBJECT (
  PONo                 NUMBER,
  Cust_ref             REF Customer_objtyp,
  OrderDate            DATE,
  ShipDate             DATE,
  LineItemList_ntab    LineItemList_ntabtyp,
  ShipToAddr_obj       Address_objtyp,

  MAP MEMBER FUNCTION
    getPONo RETURN NUMBER,
    PRAGMA RESTRICT_REFERENCES (
      getPONo, WNDS, WNPS, RNPS, RNDS),

  MEMBER FUNCTION
    sumLineItems RETURN NUMBER,
    PRAGMA RESTRICT_REFERENCES (sumLineItems, WNDS, WNPS)
  ) 
/

CREATE OR REPLACE TYPE BODY PurchaseOrder_objtyp AS 

   MAP MEMBER FUNCTION getPONo RETURN NUMBER is   
      BEGIN  
         RETURN PONo;   
      END;   
    
   MEMBER FUNCTION sumLineItems RETURN NUMBER IS  
      i          INTEGER;  
      StockVal   StockItem_objtyp;  
      Total      NUMBER := 0;
  
   BEGIN
      IF (UTL_COLL.IS_LOCATOR(LineItemList_ntab)) -- check for locator
         THEN
            SELECT SUM(L.Quantity * L.Stock_ref.Price) 
              INTO Total
              FROM TABLE(CAST(LineItemList_ntab AS LineItemList_ntabtyp)) L;
      ELSE
         FOR i in 1..SELF.LineItemList_ntab.COUNT LOOP  
            UTL_REF.SELECT_OBJECT (
               LineItemList_ntab(i).Stock_ref,StockVal);  
            Total := 
               Total + 
               SELF.LineItemList_ntab(i).Quantity * 
                  StockVal.Price;  
         END LOOP;  
      END IF;  
   RETURN Total;  
   END;  
END;     
/