CREATE OR REPLACE FUNCTION lreplace (
   string_in          IN   VARCHAR2
  ,old_substring_in   IN   VARCHAR2
  ,new_substring_in   IN   VARCHAR2
)
   RETURN VARCHAR2
IS
   v_old_length   PLS_INTEGER      := LENGTH (old_substring_in);
   v_clipcount    PLS_INTEGER      := 0;
   retval         VARCHAR2 (32767) := string_in;

   PROCEDURE calculate_clip_count
   IS
   BEGIN
      LOOP
         EXIT WHEN SUBSTR (string_in
                          , v_clipcount * v_old_length + 1
                          ,v_old_length
                          ) != old_substring_in;
         v_clipcount := v_clipcount + 1;
      END LOOP;
   END calculate_clip_count;
BEGIN
   IF string_in IS NOT NULL AND old_substring_in IS NOT NULL
   THEN
      -- How many leading occurrences?
      calculate_clip_count;

      IF v_clipcount > 0 AND new_substring_in IS NULL
      THEN
	     -- Just strip away the leading occurrences.
         retval := SUBSTR (string_in, v_clipcount * v_old_length + 1);
      ELSIF v_clipcount > 0
      THEN
	     -- Use RPAD to repeat the new string the necessary number of
		 -- times to do the replacement. Then prepend that to the
		 -- remaining chunk of the original string.
         retval :=
               RPAD (new_substring_in
                    , v_clipcount * LENGTH (new_substring_in)
                    ,new_substring_in
                    )
            || SUBSTR (string_in, v_clipcount * v_old_length + 1);
      END IF;
   END IF;

   RETURN retval;
END lreplace;
/