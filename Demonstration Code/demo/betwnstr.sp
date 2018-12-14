CREATE OR REPLACE procedure get_betwnstr (string_in    IN VARCHAR2
                                   , start_in     IN PLS_INTEGER
                                   , end_in       IN PLS_INTEGER
                                   , inclusive_in IN BOOLEAN:= TRUE
                                   , string_out out varchar2
                                    )
/*
Overview: Return the string between start and end locations.
          A variation on SUBSTR useful for string parsing,
          it encapsulates the "end - start + 1" necessary
          to compute the number of characters between start
          and end.

          abc,defgh,ijkl
             ^     ^
             4     10   --> length (,defgh,) = 10 - 4 + 1 = 7

Author:   Steven Feuerstein

Requirements:
   * Treat a 0 start value as a 1 (like SUBSTR)
   * End > length of string -> get rest of string
   * Neg start and end retrieve substring from end of string
   * Null for any input causes return of NULL
   * User chooses whether or not to include the endpoints
   * You cannot mix positive and negative values.
*/
IS
   v_start      PLS_INTEGER;
   v_numchars   PLS_INTEGER;
BEGIN
   IF (start_in > 0 AND end_in < 0) OR (start_in < 0 AND end_in > 0)
   THEN
      RAISE_APPLICATION_ERROR (
         -20000
       , 'Start and end values must either be both positive or both negative.'
      );
   END IF;

   IF    string_in IS NULL
      OR (start_in < 0 AND end_in > start_in)
      OR (start_in > 0 AND end_in < start_in)
   THEN
      string_out := NULL;
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

      string_out := (SUBSTR (string_in, v_start, v_numchars));
   END IF;
END;
/