DROP TABLE some_data
/
CREATE TABLE some_data (
   a_name VARCHAR2(100)
)
/

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   INSERT INTO some_data
        VALUES ('Rhino');

   COMMIT;
   fid := UTL_FILE.fopen ('TEMP', 'some_data.txt', 'W');
   UTL_FILE.put_line (fid, 'Rhino');
   UTL_FILE.fclose (fid);
END;
/

DECLARE
   l_name          some_data.a_name%TYPE;
   l_action        some_data.a_name%TYPE;
   l_line          VARCHAR2 (1023);
   l_sum           PLS_INTEGER;
   fid             UTL_FILE.file_type;
   list_of_names   DBMS_SQL.varchar2s;

   TYPE ndf_for_aat IS TABLE OF some_data.a_name%TYPE
      INDEX BY some_data.a_name%TYPE;

   l_ndf_for       ndf_for_aat;
BEGIN
   FOR indx IN 1 .. 100
   LOOP
      BEGIN
         CASE
            WHEN NOT l_ndf_for.EXISTS ('SELECT')
            THEN
               l_action := 'SELECT';

               SELECT a_name
                 INTO l_name
                 FROM some_data
                WHERE a_name = 'Hippo';

               l_ndf_for (l_action) := 'Nope!';
            WHEN NOT l_ndf_for.EXISTS ('WRITEFILE')
            THEN
               l_action := 'WRITEFILE';
               fid := UTL_FILE.fopen ('TEMP', 'some_data2.txt', 'W');
               l_ndf_for (l_action) := 'Nope!';
               UTL_FILE.fclose (fid);
            WHEN NOT l_ndf_for.EXISTS ('READFILE')
            THEN
               l_action := 'READFILE';
               fid := UTL_FILE.fopen ('TEMP', 'some_data2.txt', 'R');
               UTL_FILE.get_line (fid, l_line);
               UTL_FILE.get_line (fid, l_line);
               l_ndf_for (l_action) := 'Nope!';
               UTL_FILE.fclose (fid);
            WHEN NOT l_ndf_for.EXISTS ('SELECTBULK')
            THEN
               l_action := 'SELECTBULK';

               SELECT a_name
               BULK COLLECT INTO list_of_names
                 FROM some_data
                WHERE a_name = 'Hippo';

               l_ndf_for (l_action) := 'Nope!';
            WHEN NOT l_ndf_for.EXISTS ('READARRAY')
            THEN
               l_action := 'READARRAY';

               IF list_of_names (100) > 0
               THEN
                  DBMS_OUTPUT.put_line ('Positive value at row 100');
               END IF;

               l_ndf_for (l_action) := 'Nope!';
            WHEN NOT l_ndf_for.EXISTS ('SELECTGROUP')
            THEN
               l_action := 'SELECTGROUP';

               SELECT SUM (LENGTH (a_name))
                 INTO l_sum
                 FROM some_data
                WHERE a_name = 'Hippo';

               l_ndf_for (l_action) := 'Nope!';
            ELSE
               NULL;
         END CASE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_ndf_for (l_action) := 'Yep!';

            IF UTL_FILE.is_open (fid)
            THEN
               UTL_FILE.fclose (fid);
            END IF;
      END;
   END LOOP;

   l_sum := 0;
   l_name := l_ndf_for.FIRST;

   WHILE (l_name IS NOT NULL)
   LOOP
      IF l_ndf_for (l_name) = 'Yep!'
      THEN
         l_sum := l_sum + 1;
      END IF;

      l_name := l_ndf_for.NEXT (l_name);
   END LOOP;

   DBMS_OUTPUT.put_line ('NO_DATA_FOUND raised this many times: ' || l_sum);
END;
/