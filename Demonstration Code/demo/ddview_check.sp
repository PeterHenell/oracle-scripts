/* Formatted on 2002/10/04 07:46 (Formatter Plus v4.7.0) */

CREATE OR REPLACE PROCEDURE dd_view_scan (
   name_filter_in     IN   VARCHAR2 := NULL,
   column_filter_in   IN   VARCHAR2 := NULL
)
IS 
   l_name     VARCHAR2 (100) := UPPER (name_filter_in);
   l_column   VARCHAR2 (100) := UPPER (column_filter_in);

   CURSOR by_name_cur (NAME_IN IN VARCHAR2)
   IS
      SELECT object_name
        FROM all_objects
       WHERE owner = 'SYS' AND object_name LIKE NAME_IN AND object_type =
                                                                       'VIEW';

   CURSOR by_column_cur (NAME_IN IN VARCHAR2, column_in IN VARCHAR2)
   IS
      SELECT table_name, column_name
        FROM all_tab_columns
       WHERE owner = 'SYS'
         AND table_name LIKE NAME_IN
         AND column_name LIKE column_in;

   PROCEDURE pl (
      str         IN   VARCHAR2,
      len         IN   INTEGER := 80,
      expand_in   IN   BOOLEAN := TRUE
   )
   IS 
      v_len     PLS_INTEGER     := LEAST (len, 255);
      v_len2    PLS_INTEGER;
      v_chr10   PLS_INTEGER;
      v_str     VARCHAR2 (2000);
   BEGIN
      IF LENGTH (str) > v_len
      THEN
         v_chr10 := INSTR (str, CHR (10));

         IF v_chr10 > 0 AND v_len < v_chr10
         THEN
            v_len := v_chr10 - 1;
            v_len2 := v_chr10 + 1;
         ELSE
            v_len := v_len - 1;
            v_len2 := v_len;
         END IF;

         v_str := SUBSTR (str, 1, v_len);
         DBMS_OUTPUT.put_line (v_str);
         pl (SUBSTR (str, v_len2), len, expand_in);
      ELSE
         DBMS_OUTPUT.put_line (str);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         /* TVP 9/99: Might want to use buffer size to STOP program */
         IF expand_in
         THEN
            DBMS_OUTPUT.ENABLE (1000000);
            DBMS_OUTPUT.put_line (v_str);
         ELSE
            RAISE;
         END IF;
   END;

   PROCEDURE assert (condition_in IN BOOLEAN, msg_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      IF NOT condition_in OR condition_in IS NULL
      THEN
         IF msg_in IS NOT NULL
         THEN
            pl (msg_in);
         END IF;

         RAISE VALUE_ERROR;
      END IF;
   END;
BEGIN
   -- Need to provide at least one significant filter
   assert (NOT (NVL (l_name, '%') = '%' AND NVL (l_column, '%') = '%'));
   pl ('');
   pl ('Data Dictionary Views with names like "' || l_name || '"');
   pl ('');

   FOR rec IN by_name_cur (l_name)
   LOOP
      pl ('> ' || rec.object_name);
   END LOOP;

   IF l_column IS NOT NULL
   THEN
      pl ('');
      pl (
            'Data Dictionary Views with columns like "'
         || l_name
         || '.'
         || l_column
         || '"'
      );
      pl ('');

      FOR rec IN by_column_cur (l_name, l_column)
      LOOP
         pl ('> ' || rec.table_name || '.' || rec.column_name);
      END LOOP;
   END IF;
END;