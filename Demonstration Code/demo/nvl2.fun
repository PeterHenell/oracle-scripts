CREATE OR REPLACE FUNCTION NVL2 (val_in      IN VARCHAR2
                               , ifnull      IN VARCHAR2
                               , ifnotnull   IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   IF val_in IS NULL
   THEN
      RETURN ifnull;
   ELSE
      RETURN ifnotnull;
   END IF;
END;
/

CREATE OR REPLACE FUNCTION NVL2 (val         IN VARCHAR2
                               , ifnotnull   IN VARCHAR2
                               , ifnull      IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE WHEN val IS NOT NULL THEN ifnotnull ELSE ifnull END;
END;
/