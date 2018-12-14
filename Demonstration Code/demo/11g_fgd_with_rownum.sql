DROP TABLE mumu
/

CREATE TABLE mumu
(
   x   NUMBER
 , c   VARCHAR2 (5 BYTE)
 , z   NUMBER
);

INSERT INTO mumu (x, c)
     VALUES (2, 'x');

INSERT INTO mumu (x, c)
     VALUES (3, 'c');

COMMIT;

CREATE OR REPLACE PROCEDURE mu
AS
   xx   mumu.c%TYPE;
BEGIN
   SELECT c
     INTO xx
     FROM mumu
    WHERE ROWNUM = 1;
END;
/

SELECT status
  FROM user_objects
 WHERE object_name = 'MU';

ALTER TABLE mumu ADD y NUMBER;

SELECT status
  FROM user_objects
 WHERE object_name = 'MU';