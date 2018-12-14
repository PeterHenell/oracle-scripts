DROP TABLE tbl;
CREATE TABLE tbl (onecol NUMBER);

INSERT INTO tbl
     VALUES (1);
INSERT INTO tbl
     VALUES (2);
INSERT INTO tbl
     VALUES (3);
COMMIT ;

DECLARE
   CURSOR cur
   IS
      SELECT onecol
        FROM tbl;

   no_rows   EXCEPTION;
   n         PLS_INTEGER := 0;

   PROCEDURE show_cur_attributes (scope_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (scope_in);

      CASE cur%ISOPEN
         WHEN TRUE
         THEN
            DBMS_OUTPUT.put_line ('cur%isopen is true');

            IF cur%FOUND
            THEN
               DBMS_OUTPUT.put_line ('cur%found is true');
            END IF;

            DBMS_OUTPUT.put_line ('cur%rowcount: ' || cur%ROWCOUNT);
         WHEN FALSE
         THEN
            DBMS_OUTPUT.put_line ('cur%isopen is false');

            IF cur%FOUND
            THEN
               DBMS_OUTPUT.put_line ('cur%found is true');
            END IF;

            DBMS_OUTPUT.put_line ('cur%rowcount: ' || cur%ROWCOUNT);
      END CASE;
   EXCEPTION
      WHEN INVALID_CURSOR
      THEN
         DBMS_OUTPUT.put_line ('Invalid cursor at this point!');
   END show_cur_attributes;
BEGIN
   FOR j IN cur
   LOOP
      n := n + 1;
      DBMS_OUTPUT.put_line ('iteration: ' || TO_CHAR (n));
      show_cur_attributes ('in cfl on iteration ' || n);
   END LOOP;

   show_cur_attributes ('past cfl');
END;
/