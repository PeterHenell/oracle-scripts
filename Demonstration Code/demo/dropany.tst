@ssoo

CREATE OR REPLACE PROCEDURE dropany (
   tp IN VARCHAR2,
   nm IN VARCHAR2
   )
AS LANGUAGE JAVA
   NAME 'DropAny.object (
            java.lang.String,
            java.lang.String)';
/

BEGIN  
   dropany ('TABLE', 'blip');
END;
/

BEGIN  
   dropany ('TABLE', 'blip');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLCODE);
      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/

   
