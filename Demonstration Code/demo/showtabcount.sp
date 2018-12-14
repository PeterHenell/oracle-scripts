/* Formatted on 2001/09/10 09:21 (RevealNet Formatter v4.4.1) */
CREATE OR REPLACE PROCEDURE showtabcount (
   tab   IN   VARCHAR2,
   whr   IN   VARCHAR2 := NULL,
   sch   IN   VARCHAR2 := NULL,
   addsch IN BOOLEAN := TRUE
)
IS
   l_count   INTEGER;
BEGIN
   l_count := tabcount (tab, whr, sch, addsch);
   
   DBMS_OUTPUT.PUT_LINE (
      'Count of ' || NVL (sch, USER) || '.' || tab ||
	  ' WHERE ' || NVL (whr, '* no filter *') || ' = ' || l_count);
END;
/	  