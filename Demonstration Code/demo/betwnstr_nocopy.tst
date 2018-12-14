CREATE OR REPLACE PACKAGE betwnstrs
IS
   FUNCTION betwnstr (
      string_in IN VARCHAR2
    , start_in IN PLS_INTEGER
    , end_in IN PLS_INTEGER
    , inclusive_in IN BOOLEAN := TRUE
   )
      RETURN VARCHAR2;

   PROCEDURE betwnstr (
      string_inout IN OUT VARCHAR2
    , start_in IN PLS_INTEGER
    , end_in IN PLS_INTEGER
    , inclusive_in IN BOOLEAN := TRUE
   );
END betwnstrs;
/

CREATE OR REPLACE PACKAGE BODY betwnstrs
IS
   FUNCTION betwnstr (
      string_in IN VARCHAR2
    , start_in IN PLS_INTEGER
    , end_in IN PLS_INTEGER
    , inclusive_in IN BOOLEAN := TRUE
   )
      RETURN VARCHAR2
   IS
      v_start      PLS_INTEGER;
      v_numchars   PLS_INTEGER;
   BEGIN
      IF    string_in IS NULL
         OR (start_in < 0 AND end_in > 0)
         OR (start_in > 0 AND end_in < 0)
         OR (start_in < 0 AND end_in > start_in)
         OR (start_in > 0 AND end_in < start_in)
      THEN
         RETURN NULL;
      ELSE
         IF start_in < 0
         THEN
            v_numchars := ABS (end_in) - ABS (start_in) + 1;
            v_start := GREATEST (end_in, -1 * LENGTH (string_in));
         ELSIF start_in = 0
         THEN
            v_start := 1;
            v_numchars := ABS (end_in) - ABS (v_start) + 1;
         ELSE
            v_start := start_in;
            v_numchars := ABS (end_in) - ABS (v_start) + 1;
         END IF;

         IF NOT NVL (inclusive_in, FALSE)
         THEN
            v_start := v_start + 1;
            v_numchars := v_numchars - 2;
         END IF;

         RETURN (SUBSTR (string_in, v_start, v_numchars));
      END IF;
   END;

   PROCEDURE betwnstr (
      string_inout IN OUT VARCHAR2
    , start_in IN PLS_INTEGER
    , end_in IN PLS_INTEGER
    , inclusive_in IN BOOLEAN := TRUE
   )
   IS
      v_start      PLS_INTEGER;
      v_numchars   PLS_INTEGER;
   BEGIN
      IF    string_inout IS NULL
         OR (start_in < 0 AND end_in > 0)
         OR (start_in > 0 AND end_in < 0)
         OR (start_in < 0 AND end_in > start_in)
         OR (start_in > 0 AND end_in < start_in)
      THEN
         string_inout := NULL;
      ELSE
         IF start_in < 0
         THEN
            v_numchars := ABS (end_in) - ABS (start_in) + 1;
            v_start := GREATEST (end_in, -1 * LENGTH (string_inout));
         ELSIF start_in = 0
         THEN
            v_start := 1;
            v_numchars := ABS (end_in) - ABS (v_start) + 1;
         ELSE
            v_start := start_in;
            v_numchars := ABS (end_in) - ABS (v_start) + 1;
         END IF;

         IF NOT NVL (inclusive_in, FALSE)
         THEN
            v_start := v_start + 1;
            v_numchars := v_numchars - 2;
         END IF;

         string_inout := SUBSTR (string_inout, v_start, v_numchars);
      END IF;
   END;
END betwnstrs;
/

CREATE OR REPLACE PROCEDURE betwnstr_nocopy_test (
   count_in IN PLS_INTEGER 
 , length_in IN PLS_INTEGER 
)
IS
   v          VARCHAR2 (32767);
   func_tmr   tmr_t         := NEW tmr_t ('Function', count_in);
   proc_tmr   tmr_t         := NEW tmr_t ('Procedure', count_in);
BEGIN
   func_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      v := betwnstrs.betwnstr (RPAD ('abc', length_in, 'def'), 3, 100, TRUE);
   END LOOP;

   func_tmr.STOP;
   --
   proc_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      v := RPAD ('abc', length_in, 'def');
      betwnstrs.betwnstr (v, 3, 100, TRUE);
   END LOOP;

   proc_tmr.STOP;
END;
/

BEGIN
   betwnstr_nocopy_test (1000000, 100);
   betwnstr_nocopy_test (1000000, 10000);
END;
/