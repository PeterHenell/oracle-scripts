/*
http://download.oracle.com/docs/cd/B19306_01/appdev.102/b14261/cursor_declaration.htm#LNPLS01313
*/

DROP TABLE plch_parts
/

CREATE TABLE plch_parts
(
   partnum    INTEGER PRIMARY KEY
 , partname   VARCHAR2 (100) UNIQUE
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (1, 'Mouse');

   INSERT INTO plch_parts
        VALUES (100, 'Keyboard');

   INSERT INTO plch_parts
        VALUES (500, 'Monitor');

   COMMIT;
END;
/

DECLARE
   l_filter   VARCHAR2 (100) := 'M%';

   CURSOR parts_cur
   IS
      SELECT *
        FROM plch_parts
       WHERE partname LIKE l_filter;

   l_part     plch_parts%ROWTYPE;
BEGIN
   sys.DBMS_OUTPUT.put_line ('Reference variable in cursor');

   OPEN parts_cur;

   LOOP
      FETCH parts_cur INTO l_part;

      EXIT WHEN parts_cur%NOTFOUND;

      sys.DBMS_OUTPUT.put_line (l_part.partnum);
   END LOOP;

   CLOSE parts_cur;
END;
/

DECLARE
   CURSOR parts_cur (filter_in IN VARCHAR2)
   IS
      SELECT *
        FROM plch_parts
       WHERE partname LIKE filter_in;

   l_part   plch_parts%ROWTYPE;
BEGIN
   sys.DBMS_OUTPUT.put_line ('Pass filter to cursor - IN parameter');

   OPEN parts_cur ('M%');

   LOOP
      FETCH parts_cur INTO l_part;

      EXIT WHEN parts_cur%NOTFOUND;

      sys.DBMS_OUTPUT.put_line (l_part.partnum);
   END LOOP;

   CLOSE parts_cur;
END;
/

DECLARE
   l_filter   VARCHAR2 (100);

   CURSOR parts_cur (filter_in IN VARCHAR2)
   IS
      SELECT *
        FROM plch_parts
       WHERE partname LIKE l_filter;

   l_part     plch_parts%ROWTYPE;
BEGIN
   sys.DBMS_OUTPUT.put_line (
      'IN parameter ignored, local variable referenced');

   OPEN parts_cur ('M%');

   LOOP
      FETCH parts_cur INTO l_part;

      EXIT WHEN parts_cur%NOTFOUND;

      sys.DBMS_OUTPUT.put_line (l_part.partnum);
   END LOOP;

   CLOSE parts_cur;
END;
/

DECLARE
   CURSOR parts_cur (filter_in IN VARCHAR2 DEFAULT 'M%')
   IS
      SELECT *
        FROM plch_parts
       WHERE partname LIKE filter_in;

   l_part     plch_parts%ROWTYPE;
BEGIN
   sys.DBMS_OUTPUT.put_line (
      'IN parameter with default value');

   OPEN parts_cur ();

   LOOP
      FETCH parts_cur INTO l_part;

      EXIT WHEN parts_cur%NOTFOUND;

      sys.DBMS_OUTPUT.put_line (l_part.partnum);
   END LOOP;

   CLOSE parts_cur;
END;
/

/* Oracle also doesn't complain about OUT and IN OUT for
   cursor parameter, even though doc states only IN and
   these don't make any sense...
   
   You see data for the IN OUT, but nothing for the OUT. 
*/

DECLARE
   l_filter   VARCHAR2 (100) := 'M%';

   CURSOR parts_cur (filter_in IN OUT VARCHAR2)
   IS
      SELECT *
        FROM plch_parts
       WHERE partname LIKE filter_in;

   l_part     plch_parts%ROWTYPE;
BEGIN
   sys.DBMS_OUTPUT.put_line ('Cursor IN OUT  parameter');

   OPEN parts_cur (l_filter);

   LOOP
      FETCH parts_cur INTO l_part;

      EXIT WHEN parts_cur%NOTFOUND;

      sys.DBMS_OUTPUT.put_line (l_part.partnum);
   END LOOP;

   CLOSE parts_cur;
END;
/

DECLARE
   l_filter   VARCHAR2 (100) := 'M%';

   CURSOR parts_cur (filter_in OUT VARCHAR2)
   IS
      SELECT *
        FROM plch_parts
       WHERE partname LIKE filter_in;

   l_part     plch_parts%ROWTYPE;
BEGIN
   sys.DBMS_OUTPUT.put_line ('Cursor OUT parameter');

   OPEN parts_cur (l_filter);

   LOOP
      FETCH parts_cur INTO l_part;

      sys.DBMS_OUTPUT.put_line (l_part.partnum);

      EXIT WHEN parts_cur%NOTFOUND;
   END LOOP;

   CLOSE parts_cur;
END;
/