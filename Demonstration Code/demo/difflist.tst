CREATE OR REPLACE PACKAGE strlist 
IS
   PROCEDURE define (list IN VARCHAR2);
   PROCEDURE remove (str IN VARCHAR2);
   FUNCTION inlist (str IN VARCHAR2) RETURN BOOLEAN;
END;
/
CREATE OR REPLACE PACKAGE hashlist 
IS
   PROCEDURE define (list IN VARCHAR2);
   PROCEDURE remove (str IN VARCHAR2);
   FUNCTION inlist (str IN VARCHAR2) RETURN BOOLEAN;
END;
/
CREATE OR REPLACE PACKAGE tablist 
IS
   PROCEDURE define (list IN VARCHAR2);
   PROCEDURE remove (str IN VARCHAR2);
   FUNCTION inlist (str IN VARCHAR2) RETURN BOOLEAN;
END;
/


