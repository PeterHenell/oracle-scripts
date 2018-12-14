/* Formatted on 2002/01/04 17:11 (Formatter Plus v4.5.2) */
DROP TABLE hairstyles;

CREATE TABLE hairstyles (
  code         INTEGER,
  description  VARCHAR2 (100),
  popularity INTEGER );


INSERT INTO hairstyles
     VALUES (1000, 'CREWCUT', 3);
INSERT INTO hairstyles
     VALUES (1001, 'BOB', 88);
INSERT INTO hairstyles
     VALUES (1002, 'SHAG', 16);
INSERT INTO hairstyles
     VALUES (1003, 'BOUFFANT', 1);
INSERT INTO hairstyles
     VALUES (1004, 'PAGEBOY', 7);


CREATE OR REPLACE FUNCTION favorite_styles (where_in IN VARCHAR2)
   RETURN SYS_REFCURSOR
IS
   retval   SYS_REFCURSOR;
BEGIN
   OPEN retval FOR    'select * from hairstyles where '
                   || NVL (where_in, '1=1'); /* NEOUG 1/2002 */
   RETURN retval;
END;
/


CREATE OR REPLACE PROCEDURE show_styles (cursor_in IN sys_refcursor)
IS
   rec   hairstyles%ROWTYPE;
BEGIN
   LOOP
      FETCH cursor_in INTO rec;
      EXIT WHEN cursor_in%NOTFOUND;
      DBMS_OUTPUT.put_line (rec.description);
   END LOOP;
   CLOSE cursor_in; 
END;
/

BEGIN
   show_styles (favorite_styles (' description like ''B%'''));
END;
/

/* Formatted on 2002/04/03 06:48 (Formatter Plus v4.5.2) */
CREATE OR REPLACE FUNCTION most_popular (
   cursor_in   IN   sys_refcursor
)
   RETURN INTEGER
IS
   rec      hairstyles%ROWTYPE;
   retval   INTEGER              := 9999;
BEGIN
   LOOP
      FETCH cursor_in INTO rec;
      EXIT WHEN cursor_in%NOTFOUND;

      IF rec.popularity < retval
      THEN
         retval := rec.popularity;
      END IF;
   END LOOP;

   RETURN retval;
END;
/

DECLARE
   cv SYS_REFCURSOR;
BEGIN
   OPEN cv FOR select * from hairstyles where code < 2000;
   DBMS_OUTPUT.PUT_LINE (most_popular (cv));
END;
/
   
SELECT * FROM hairstyles
 WHERE popularity = most_popular (
                       CURSOR (SELECT * FROM hairstyles where code < 2000));


