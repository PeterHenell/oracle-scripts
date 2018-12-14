/* Formatted on 2004/12/27 15:20 (Formatter Plus v4.8.5) */
CREATE OR REPLACE PACKAGE BODY insga
IS
   PROCEDURE pl (
      str         IN   VARCHAR2,
      len         IN   INTEGER := 80,
      expand_in   IN   BOOLEAN := TRUE
   )
   IS
      v_len   PLS_INTEGER     := LEAST (len, 255);
      v_str   VARCHAR2 (2000);
   BEGIN
      IF LENGTH (str) > v_len
      THEN
         v_str := SUBSTR (str, 1, v_len);
         DBMS_OUTPUT.put_line (v_str);
         pl (SUBSTR (str, len + 1), v_len, expand_in);
      ELSE
         v_str := str;
         DBMS_OUTPUT.put_line (v_str);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF expand_in
         THEN
            DBMS_OUTPUT.ENABLE (1000000);
            DBMS_OUTPUT.put_line (v_str);
         ELSE
            RAISE;
         END IF;
   END pl;

   PROCEDURE println (rec IN cache_cur%ROWTYPE)
   IS
   BEGIN
      pl (   rec.owner
          || '.'
          || rec.NAME
          || ' ('
          || rec.TYPE
          || ')'
          || ' Loads: '
          || rec.loads
          || ' Execs: '
          || rec.executions
          || ' Kept: '
          || rec.kept
         );
   END;

   PROCEDURE println_size (rec IN cachesize_cur%ROWTYPE)
   IS
   BEGIN
      pl (   rec.owner
          || '.'
          || rec.NAME
          || ' ('
          || rec.TYPE
          || ')'
          || ' Loads: '
          || rec.loads
          || ' Execs: '
          || rec.executions
          || ' Kept: '
          || rec.kept
          || ' Code size: '
          || rec.code_size
          || ' Kept size: '
          || rec.kept_size
         );
   END;

   PROCEDURE showdbcache (
      nm              IN   VARCHAR2 := '%',
      sch             IN   VARCHAR2 := USER,
      tp              IN   VARCHAR2 := '%',
      minloads        IN   PLS_INTEGER := 1,
      minexecutions   IN   PLS_INTEGER := 1,
      iskept          IN   BOOLEAN := NULL,
      includesys      IN   BOOLEAN := FALSE
   )
   IS
      v_kept   VARCHAR2 (3) := NULL;
      v_sys    CHAR (1)     := 'N';
   BEGIN
      IF iskept
      THEN
         v_kept := 'YES';
      ELSIF NOT iskept
      THEN
         v_kept := 'NO';
      END IF;

      IF includesys
      THEN
         v_sys := 'Y';
      END IF;

      FOR rec IN cache_cur (nm,
                            sch,
                            tp,
                            minloads,
                            minexecutions,
                            v_kept,
                            v_sys
                           )
      LOOP
         println (rec);
      END LOOP;
   END showdbcache;

   PROCEDURE showdbcache_size (
      nm              IN   VARCHAR2 := '%',
      sch             IN   VARCHAR2 := USER,
      tp              IN   VARCHAR2 := '%',
      minloads        IN   PLS_INTEGER := 1,
      minexecutions   IN   PLS_INTEGER := 0,
      iskept          IN   BOOLEAN := NULL,
      includesys      IN   BOOLEAN := FALSE
   )
   IS
      v_kept    VARCHAR2 (3) := NULL;
      v_code    PLS_INTEGER  := 0;
      v_total   PLS_INTEGER  := 0;
      v_sys     CHAR (1)     := 'N';
   BEGIN
      IF iskept
      THEN
         v_kept := 'YES';
      ELSIF NOT iskept
      THEN
         v_kept := 'NO';
      END IF;

      IF includesys
      THEN
         v_sys := 'Y';
      END IF;

      FOR rec IN cachesize_cur (nm,
                                sch,
                                tp,
                                minloads,
                                minexecutions,
                                v_kept,
                                v_sys
                               )
      LOOP
         println_size (rec);
         v_code := v_code + rec.code_size;
         v_total := v_total + rec.kept_size;
      END LOOP;

      pl ('Total code size: ' || v_code);
      pl ('Total kept size (code + parsed): ' || v_total);
   END showdbcache_size;

   FUNCTION numexecutions (
      nm    IN   VARCHAR2,
      sch   IN   VARCHAR2 := USER,
      tp    IN   VARCHAR2 := '%'
   )
      RETURN PLS_INTEGER
   IS
      cache_rec   cache_cur%ROWTYPE;
   BEGIN
      OPEN cache_cur (nm, sch, tp, 0, 0, NULL, 'Y');

      FETCH cache_cur
       INTO cache_rec;

      CLOSE cache_cur;

      RETURN cache_rec.executions;
   END numexecutions;

   FUNCTION numloads (
      nm    IN   VARCHAR2,
      sch   IN   VARCHAR2 := USER,
      tp    IN   VARCHAR2 := '%'
   )
      RETURN PLS_INTEGER
   IS
      cache_rec   cache_cur%ROWTYPE;
   BEGIN
      OPEN cache_cur (nm, sch, tp, 0, 0, NULL, 'Y');

      FETCH cache_cur
       INTO cache_rec;

      CLOSE cache_cur;

      RETURN cache_rec.loads;
   END numloads;

   PROCEDURE show_hitratio (
      rc_floor   IN   INTEGER := 95,
      lc_floor   IN   INTEGER := 95
   )
   IS
      hit_ratio   NUMBER;
   BEGIN
      SELECT (1 - (SUM (getmisses) / (SUM (gets) + SUM (getmisses)))) * 100
        INTO hit_ratio
        FROM v$rowcache
       WHERE gets + getmisses != 0;

      pl ('ROW CACHE Hit ratio = ' || TO_CHAR (hit_ratio, '99.99') || '%');

      IF hit_ratio < rc_floor
      THEN
         /* Utrecht 12/99 - don't hardcode */
         pl (   '*** This ratio is below '
             || rc_floor
             || '%. '
             || 'Consider raising the SHARED_POOL_SIZE init.ora parameter.'
            );
      END IF;

      SELECT (SUM (pins) / (SUM (pins) + SUM (reloads))) * 100
        INTO hit_ratio
        FROM v$librarycache;

      pl ('LIBRARY CACHE Hit ratio = ' || TO_CHAR (hit_ratio, '99.99') || '%');

      IF hit_ratio < lc_floor
      THEN
         pl (   '*** This ratio is below '
             || lc_floor
             || '%. '
             || 'Consider raising the SHARED_POOL_SIZE init.ora parameter.'
            );
      END IF;
   END;

   FUNCTION lcd_sql (
      str           IN   VARCHAR2,
      startat       IN   PLS_INTEGER := 1,
      stopat        IN   PLS_INTEGER := NULL,
      remove_list   IN   VARCHAR2 := NULL
   )
      RETURN VARCHAR2
   IS
      v_remove   VARCHAR2 (100)
                              := NVL (remove_list, ' ' || CHR (10) || CHR (9));
   BEGIN
      RETURN SUBSTR (TRANSLATE (UPPER (str), 'A' || v_remove, 'A'),
                     startat,
                     stopat
                    );
   END;

   FUNCTION lcd_sql (
      str           IN   VARCHAR2,
      stopat        IN   VARCHAR2,
      nth           IN   PLS_INTEGER := 1,
      remove_list   IN   VARCHAR2 := NULL
   )
      RETURN VARCHAR2
   IS
      v_str      VARCHAR2 (32767) := UPPER (str);
      v_loc      PLS_INTEGER;
      v_remove   VARCHAR2 (100)
                              := NVL (remove_list, ' ' || CHR (10) || CHR (9));
   BEGIN
      v_loc := INSTR (v_str, stopat, 1, nth);

      IF v_loc = 0
      THEN
         RETURN TRANSLATE (v_str, 'A' || v_remove, 'A');
      ELSE
         RETURN TRANSLATE (SUBSTR (v_str, 1, v_loc - 1), 'A' || v_remove,
                           'A');
      END IF;
   END;

   PROCEDURE show_sqltext (
      sqltext   IN   VARCHAR2 := '%',
      MAXLEN    IN   PLS_INTEGER := NULL
   )
   IS
      CURSOR text_cur (str IN VARCHAR2)
      IS
         SELECT sql_text
           FROM v$sqlarea a
          WHERE UPPER (sql_text) LIKE UPPER (str);
   BEGIN
      pl ('*** SQLAREA Cursors that are like "' || sqltext || '"');
      pl ('');

      FOR text_rec IN text_cur (sqltext)
      LOOP
         IF MAXLEN IS NOT NULL
         THEN
            pl (SUBSTR (text_rec.sql_text, 1, MAXLEN));
         ELSE
            pl (text_rec.sql_text);
         END IF;

         pl ('');
      END LOOP;
   END;

   PROCEDURE show_similar (
      sqltext       IN   VARCHAR2 := '%',
      startat       IN   PLS_INTEGER := 1,
      stopat        IN   PLS_INTEGER := NULL,
      remove_list   IN   VARCHAR2 := NULL,
      title         IN   VARCHAR2 := NULL
   )
   IS
      CURSOR same_cur (text IN VARCHAR2)
      IS
         SELECT   lcd_sql (sql_text, startat, stopat, remove_list) text
             FROM v$sqlarea
            WHERE UPPER (sql_text) LIKE UPPER (sqltext)
         GROUP BY lcd_sql (sql_text, startat, stopat, remove_list)
           HAVING COUNT (*) > 1;

      CURSOR text_cur (str IN VARCHAR2)
      IS
         SELECT sql_text
           FROM v$sqlarea a
          WHERE lcd_sql (sql_text, startat, stopat, remove_list) = str;
   BEGIN
      FOR same_rec IN same_cur (sqltext)
      LOOP
         pl ('');
         pl ('*** Possible Statement Redundancy: ' || title);
         pl ('');

         FOR text_rec IN text_cur (same_rec.text)
         LOOP
            pl ('Statement ' || text_cur%ROWCOUNT || ': ' || text_rec.sql_text
               );
            pl ('');
         END LOOP;
      END LOOP;
   END;

   PROCEDURE show_similar (
      sqltext       IN   VARCHAR2,
      stopat        IN   VARCHAR2,
      nth           IN   PLS_INTEGER := 1,
      remove_list   IN   VARCHAR2 := NULL,
      title         IN   VARCHAR2 := NULL
   )
   IS
      CURSOR same_cur (text IN VARCHAR2)
      IS
         SELECT   lcd_sql (sql_text, stopat, nth, remove_list) text
             FROM v$sqlarea
            WHERE UPPER (sql_text) LIKE UPPER (sqltext)
         GROUP BY lcd_sql (sql_text, stopat, nth, remove_list)
           HAVING COUNT (*) > 1;

      CURSOR text_cur (str IN VARCHAR2)
      IS
         SELECT sql_text
           FROM v$sqlarea a
          WHERE lcd_sql (sql_text, stopat, nth, remove_list) = str;
   BEGIN
      FOR same_rec IN same_cur (sqltext)
      LOOP
         pl ('');
         pl ('*** Possible Statement Redundancy: ' || title);
         pl ('');

         FOR text_rec IN text_cur (same_rec.text)
         LOOP
            pl ('Statement ' || text_cur%ROWCOUNT || ': ' || text_rec.sql_text
               );
            pl ('');
         END LOOP;
      END LOOP;
   END;
END;
/
