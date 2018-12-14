CONNECT sys/sys as sysdba

INSERT INTO DUAL
            (dummy
            )
     VALUES ('Z'
            );

COMMIT ;

SELECT *
  FROM DUAL;

SET SERVEROUTPUT ON
  
BEGIN
   DBMS_OUTPUT.put_line (USER);
EXCEPTION
   WHEN TOO_MANY_ROWS
   THEN 
      DBMS_OUTPUT.put_line ('WHAT A RIDICULOUS SIUATION!');
END;
/

DELETE FROM dual WHERE dummy = 'Z';

COMMIT;