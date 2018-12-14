DROP TABLE onerow
/
CREATE TABLE onerow (dummy VARCHAR2(1))
/
CREATE OR REPLACE TRIGGER enforce_onerow
   BEFORE INSERT
   ON onerow
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_count PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM onerow;

   IF l_count = 1
   THEN
      raise_application_error
                      (-20000
                     , 'The onerow table can only have one row.'
                      );
   END IF;
END;
/
INSERT INTO onerow
     VALUES ('X')
/
COMMIT ;

INSERT INTO onerow
     VALUES ('Y')
/
SELECT *
  FROM onerow;

GRANT SELECT ON onerow TO PUBLIC;
CREATE PUBLIC SYNONYM onerow FOR onerow;

CREATE OR REPLACE FUNCTION next_pky (seq_in IN VARCHAR2)
   RETURN PLS_INTEGER AUTHID CURRENT_USER
IS
   retval PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE 'SELECT ' || seq_in
                     || '.NEXTVAL FROM onerow'
                INTO retval;

   RETURN retval;
END next_pky;
/