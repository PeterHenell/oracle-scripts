DROP TABLE output_log
/

CREATE TABLE output_log (line VARCHAR2 (1000))
/

DECLARE
   l_list    DBMS_OUTPUT.chararr;
   l_count   PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.enable (1000000);
   DBMS_OUTPUT.put_line ('abc1');
   DBMS_OUTPUT.put_line ('abc2');
   DBMS_OUTPUT.put_line ('abc3');
   DBMS_OUTPUT.put ('abc4');
   DBMS_OUTPUT.put ('abc5');
   DBMS_OUTPUT.put_line ('abc6');

   DBMS_OUTPUT.get_lines (l_list, l_count);

   FOR indx IN 1 .. l_list.COUNT
   LOOP
      INSERT INTO output_log
           VALUES (l_list (indx));
   END LOOP;

   COMMIT;
END;
/

DECLARE
   l_list    DBMS_OUTPUT.chararr;
   l_count   PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.get_lines (l_list, l_count);

   FOR indx IN 1 .. l_list.COUNT
   LOOP
      INSERT INTO output_log
           VALUES (l_list (indx));
   END LOOP;

   COMMIT;
END;
/