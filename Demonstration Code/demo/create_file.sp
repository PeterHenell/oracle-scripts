CREATE OR REPLACE PROCEDURE create_file (
   loc_in IN VARCHAR2
 , file_in IN VARCHAR2
 , lines_in IN VARCHAR2 DEFAULT NULL
 , delim_in IN VARCHAR2 DEFAULT '|'
 , max_linesize_in IN PLS_INTEGER DEFAULT 32767
)
IS
   file_handle   UTL_FILE.file_type;
   l_lines       DBMS_SQL.varchar2a;

   FUNCTION string_to_list (string_in IN VARCHAR2)
      RETURN DBMS_SQL.varchar2a
   IS
      l_item       VARCHAR2 (32767);
      l_loc        PLS_INTEGER;
      l_startloc   PLS_INTEGER        := 1;
      l_items      DBMS_SQL.varchar2a;
   BEGIN
      IF string_in IS NOT NULL
      THEN
         LOOP
            /* find next delimiter */
            l_loc := INSTR (string_in, delim_in, l_startloc);
            /* add the item */
            l_items (l_items.COUNT + 1) :=
               CASE l_loc
                  /* two consecutive delimiters */
               WHEN l_startloc
                     THEN NULL
                  /* rest of string is last item */
               WHEN 0
                     THEN SUBSTR (string_in, l_startloc)
                  ELSE SUBSTR (string_in, l_startloc, l_loc - l_startloc)
               END;

            IF l_loc = 0
            THEN
               EXIT;
            ELSE
               l_startloc := l_loc + 1;
            END IF;
         END LOOP;
      END IF;

      RETURN l_items;
   END string_to_list;
BEGIN
   /*
   || Open the file, write a single line and close the file.
   */
   file_handle :=
       UTL_FILE.fopen (loc_in, file_in, 'W', max_linesize => max_linesize_in);

   IF lines_in IS NOT NULL
   THEN
      l_lines := string_to_list (lines_in);

      FOR indx IN 1 .. l_lines.COUNT
      LOOP
         UTL_FILE.put_line (file_handle, l_lines (indx));
      END LOOP;
   ELSE
      UTL_FILE.put_line (file_handle
                       , 'I make my disk light blink, therefore I am.'
                        );
   END IF;

   UTL_FILE.fclose (file_handle);
END;
/