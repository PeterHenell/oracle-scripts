CREATE OR REPLACE PACKAGE BODY PLVprs
IS
/*----------------------------------------------------------------
||                  PL/Vision Professional
||----------------------------------------------------------------
||    File: plvprs.spb
||  Author: Steven Feuerstein
|| Copyright (C) 1996-2002 Quest Software
|| All rights reserved.
******************************************************************/

   c_pkg   CONSTANT identifier_t := 'plvprs';
   len_string       NUMBER;
   start_loc        NUMBER;
   next_loc         NUMBER;

/*--------------------- Private Modules ---------------------------
|| The following functions are available only to other modules in
|| package. No user of PLVprs can see or use these functions.
------------------------------------------------------------------*/

   FUNCTION a_delimiter (
      character_in    IN   VARCHAR2,
      delimiters_in   IN   VARCHAR2 := std_delimiters,
      one_delimiter_in in boolean := false
   )
      RETURN BOOLEAN
   /*
   || Returns TRUE if the character passsed into the function is found
   || in the list of delimiters.
   */
   IS
      -- 2000.1.3 If NULL, not a delimiter.
      retval   BOOLEAN := character_in IS NOT NULL;
   BEGIN
      IF retval
      THEN
         if one_delimiter_in then 
                  retval := delimiters_in = character_in;
         else
         retval := INSTR (delimiters_in, character_in) > 0;
         end if;
      END IF;

      RETURN retval;
   -- OLD RETURN INSTR (delimiters_in, character_in) > 0;
   END;

   FUNCTION string_length (string_in IN VARCHAR2)
      RETURN INTEGER
   IS
   BEGIN
      RETURN LENGTH (LTRIM (RTRIM (string_in)));
   END;

   FUNCTION next_atom_loc (
      string_in       IN   VARCHAR2,
      start_loc_in    IN   NUMBER,
      direction_in    IN   NUMBER := +1,
      delimiters_in   IN   VARCHAR2 := std_delimiters
   )
      RETURN INTEGER
   /*
   || The next_atom_loc function returns the location
   || in the string of the starting point of the next atomic (from the
   || start location). The function scans forward if direction_in is
   || +1, otherwise it scans backwards through the string. Here is the
   || logic to determine when the next atomic starts:
   ||
   ||    1. If current atomic is a delimiter (if, that is, the character
   ||      at the start_loc_in of the string is a delimiter), then the
   ||      the next character starts the next atomic since all
   ||      delimiters are a single character in length.
   ||
   ||    2. If current atomic is a word (if, that is, the character
   ||      at the start_loc_in of the string is a delimiter), then the
   ||
   ||      CWS begin
   ||      above line should be:
   ||      at the start_loc_in of the string is NOT a delimiter), then the
   ||
   ||      CWS end
   ||
   ||      next atomic starts at the next delimiter. Any letters or
   ||      numbers in between are part of the current atomic.
   ||
   || So I loop through the string a character at a time and apply these
   || tests. I also have to check for end of string. If I scan forward
   || the end of string comes when the SUBSTR which pulls out the next
   || character returns NULL. If I scan backward, then the end of the
   || string comes when the location is less than 0.
   */
   IS
      /* Boolean variable which uses private function to determine
      || if the current character is a delimiter or not.
      */
      was_a_delimiter   BOOLEAN
          := a_delimiter (SUBSTR (string_in, start_loc_in, 1), delimiters_in);
      /* If not a delimiter, then it was a word. */
      was_a_word        BOOLEAN      := NOT was_a_delimiter;
      /* The next character scanned in the string */
      next_char         VARCHAR2 (1);
      /*
      || The value returned by the function. This location is the start
      || of the next atomic found. Initialize it to next character,
      || forward or backward depending on increment.
      */
      return_value      NUMBER       := start_loc_in + direction_in;
   BEGIN
      --PLVconfig.enforce_trial;

      LOOP
         next_char := SUBSTR (string_in, return_value, 1);
         EXIT WHEN
                      /* On a delimiter, since that is always an atomic */
                      a_delimiter (next_char, delimiters_in)
                   OR
                      /* Was a delimiter, but am now in a word. */
                      (
                             was_a_delimiter
                         AND NOT a_delimiter (next_char, delimiters_in)
                      )
                   OR
                      /* Reached end of string scanning forward. */
                      next_char IS NULL
                   OR
                      /* Reached beginning of string scanning backward. */
                      return_value < 0;
         /* Shift return_value to move the next character. */
         return_value := return_value + direction_in;
      END LOOP;

      RETURN GREATEST (return_value, 0);
   END;

   /* CWS begin */
   FUNCTION include_this_atomic (
      atomic_in       IN   VARCHAR2,
      type_in         IN   VARCHAR2 := c_all,
      delimiters_in   IN   VARCHAR2 := std_delimiters,
      one_delimiter_in in boolean := false
   )
      RETURN BOOLEAN
   /*
   ||   given a type of atomic to include (c_all for all atomics,
   ||   c_word for words only, c_delim for delimiters only) return
   ||   TRUE if the input atomic should be included
   */
   IS
      return_value   BOOLEAN := FALSE;
   BEGIN
      IF    type_in = c_all
         OR (    type_in = c_word
             AND NOT a_delimiter (atomic_in, delimiters_in, one_delimiter_in))
         OR (    type_in = c_delim
             AND a_delimiter (atomic_in, delimiters_in, one_delimiter_in))
      THEN
         return_value := TRUE;
      ELSE
         return_value := FALSE;
      END IF;

      RETURN (return_value);
   END;

   /* CWS end   */

   PROCEDURE increment_counter (
      counter_inout   IN OUT   NUMBER,
      count_type_in   IN       VARCHAR2,
      atomic_in       IN       CHAR,
      delimiters_in   IN       VARCHAR2 := std_delimiters
   )
   IS
   BEGIN
      /* CWS begin */
      IF include_this_atomic (atomic_in, count_type_in, delimiters_in)
      /* CWS end   */
      THEN
         counter_inout := counter_inout + 1;
      END IF;
   END increment_counter;

/* ------------------------- Public Modules -----------------------*/

   PROCEDURE string (
      string_in          IN       VARCHAR2,
      atomics_list_out   IN OUT   vc2000_t,
      num_atomics_out    IN OUT   NUMBER,
      delimiters_in      IN       VARCHAR2 := std_delimiters,
      /* CWS begin */
      type_in            IN       VARCHAR2 := c_all,
      one_delimiter_in in boolean := false
   )
      /* CWS end   */
   /*
   || Version of string which stores the list of atomics
   || in a PL/SQL table.
   ||
   || Parameters:
   ||    string_in - the string to be parsed.
   ||    atomics_list_out - the table of atomics.
   ||    num_atomics_out - the number of atomics found.
   ||    delimiters_in - the set of delimiters used in parse.
   ||
   ||    CWS begin
   ||    type_in - specifies the type of atomics to place in
   ||                 the PL/SQL table: c_all for all atomics,
   ||                 c_word for words only and c_delim for
   ||                 delimiters only
   ||    CWS end
   */
   IS
      -- 2001.2
      len_delimiter PLS_INTEGER := LENGTH (delimiters_in);
      -- 2000.1.3
      single_delimiter   BOOLEAN := len_delimiter = 1 or one_delimiter_in;
   BEGIN
      --PLVconfig.enforce_trial;
      /* Initialize variables. */
      num_atomics_out := 0;
      /* 2000.2 also initialize the collection */
      atomics_list_out.delete;
      /* SEF 9/25/97 - do not get length based on TRIMs of blanks. */
      --len_string := string_length (string_in);

      len_string := LENGTH (string_in);

      IF len_string IS NOT NULL
      THEN
         /* 2001.1 If single delimiter, use separate, simple algorithm */
         IF single_delimiter
         THEN
            DECLARE
               v_item       maxvc2_t;
               v_loc        PLS_INTEGER;
               v_startloc   PLS_INTEGER  := 1;

               PROCEDURE add_item (item_in IN VARCHAR2)
               IS
               BEGIN
                  IF include_this_atomic (item_in, type_in, delimiters_in, TRUE)
                  THEN
                     atomics_list_out (NVL (atomics_list_out.LAST, 0) + 1) :=
                                                                      item_in;
                  END IF;
               END;
            BEGIN
               LOOP
                  -- Find next delimiter
                  v_loc := INSTR (string_in, delimiters_in, v_startloc);

                  IF v_loc = v_startloc              -- Previous item is NULL
                  THEN
                     v_item := NULL;
                  ELSIF v_loc = 0               -- Rest of string is last item
                  THEN
                     v_item := SUBSTR (string_in, v_startloc);
                  ELSE
                     v_item :=
                           SUBSTR (string_in, v_startloc, v_loc - v_startloc);
                  END IF;

                  add_item (v_item);
                  

                  IF v_loc = 0
                  THEN
                     EXIT;
                  ELSE 
                  add_item (delimiters_in);
                     v_startloc := v_loc + len_delimiter;
                  END IF;
               END LOOP;
            END;
            num_atomics_out := atomics_list_out.COUNT;
         ELSE
            start_loc := LEAST (1, INSTR (string_in, ' ') + 1);

            WHILE start_loc <= len_string
            LOOP
               /* CWS begin */

               -- increment the atomic counter if appropriate
               increment_counter (num_atomics_out,
                  UPPER (type_in),
                  SUBSTR (string_in, start_loc, 1),
                  delimiters_in
               );
               -- move to the next atomic
               next_loc :=
                       next_atom_loc (string_in, start_loc, 1, delimiters_in);

               IF include_this_atomic (SUBSTR (string_in, start_loc, 1),
                     type_in,
                     delimiters_in
                  )
               THEN
                  -- add this atomic to the table
                  IF next_loc > len_string
                  THEN
                     -- Atomic is all characters right to the end of the string.
                     atomics_list_out (num_atomics_out) :=
                                                SUBSTR (string_in, start_loc);
                  ELSE
                     atomics_list_out (num_atomics_out) :=
                          SUBSTR (string_in, start_loc, next_loc - start_loc);
                  END IF;
               END IF;

               -- Move starting point of scan for next atomic.
               start_loc := next_loc;
            /* CWS end   */

            END LOOP;
         END IF;
      END IF;
   END string;

   PROCEDURE string (
      string_in          IN       VARCHAR2,
      atomics_list_out   IN OUT   VARCHAR2,
      num_atomics_out    IN OUT   NUMBER,
      delimiters_in      IN       VARCHAR2 := std_delimiters,
      /* CWS begin */
      type_in            IN       VARCHAR2 := c_all,
      one_delimiter_in in boolean := false
   )
      /* CWS end   */
   /*
   || The version of string which writes the atomics out to a
   || packed list in the format "|A|,|C|".
   */
   IS
      v_atomics   vc2000_t;
   BEGIN
      /* Call the table version to perform the parse. */
      string (string_in, v_atomics, num_atomics_out, delimiters_in
                                                                  /* CWS begin */
                                                                  , type_in, one_delimiter_in);
      /* CWS end   */

      /* Pack into a string. */
      atomics_list_out := NULL;

      FOR atomic_ind IN 1 .. num_atomics_out
      LOOP
         atomics_list_out := atomics_list_out || '|' || v_atomics (atomic_ind
                                                        );
      END LOOP;

      IF atomics_list_out IS NOT NULL
      THEN
         atomics_list_out := atomics_list_out || '|';
      END IF;
   END string;

   FUNCTION numatomics (
      string_in       IN   VARCHAR2,
      count_type_in   IN   VARCHAR2 := c_all,
      delimiters_in   IN   VARCHAR2 := std_delimiters
   )
      RETURN INTEGER
   /*
   || Counts the number of atomics in the string_in. You can specify the
   || type of count you want: ALL for all atomics, WORD to count only the
   || words and DELIMITER to count only the delimiters. You can optionally
   ||
   || CWS begin
   ||
   || above line should be:
   || words and DELIM to count only the delimiters. You can optionally
   || CWS end
   ||
   || pass your own set of delimiters into the function.
   */
   IS
      return_value   INTEGER        := 0;
      v_type         identifier_t := UPPER (count_type_in);
   BEGIN
      --PLVconfig.enforce_trial;
      /* Initialize variables. */
      /* SEF 9/25/97 - do not get length based on TRIMs of blanks. */
      --len_string := string_length (string_in);
      len_string := LENGTH (string_in);

      IF len_string IS NOT NULL
      THEN
         /*
         || This loop is much simpler than string. Call the
         || next_atom_loc to move to the next atomic and increment the
         || counter if appropriate. Everything complicated is shifted into
         || sub-programs so that you can read the program "top-down",
         || understand it layer by layer.
         */
         start_loc := LEAST (1, INSTR (string_in, ' ') + 1);

         WHILE start_loc <= len_string
         LOOP
            increment_counter (return_value,
               v_type/* 7/99 UPPER (count_type_in) */,
               SUBSTR (string_in, start_loc, 1),
               delimiters_in
            );
            start_loc :=
               next_atom_loc (string_in,
                  start_loc,
                  delimiters_in   => delimiters_in
               );
         END LOOP;
      END IF;

      RETURN return_value;
   END numatomics;

   FUNCTION nth_atomic (
      string_in       IN   VARCHAR2,
      nth_in          IN   NUMBER,
      count_type_in   IN   VARCHAR2 := c_all,
      delimiters_in   IN   VARCHAR2 := std_delimiters,
      start_in        IN   INTEGER := 1
   )
      RETURN VARCHAR2
   --RETURN identifier_t
   /*
   || Find and return the nth atomic in a string. If nth_in is greater
   || the number of atomics, then return NULL. If nth_in is negative the
   || function counts from the back of the string. You can again request
   || a retrieval by ALL atomics, just the WORDs or just the DELIMITER.
   || So you can ask for the third atomic, or the second word from the end
   || of the string. You can pass your own list of delimiters as well.
   */
   IS
      /* Local copy of string. */
      local_string     VARCHAR2(4000)   := LTRIM (RTRIM (string_in));
      /* Running count of atomics so far counted. */
      atomic_count     NUMBER         := 1;
      /* Boolean variable which controls the looping logic. */
      still_scanning   BOOLEAN    :=     local_string IS NOT NULL
                                     AND nth_in != 0;
      /* The amount by which I increment the counter. */
      scan_increment   INTEGER;
      v_type           identifier_t := UPPER (count_type_in);
   BEGIN
      --PLVconfig.enforce_trial;

      IF nth_in = 0
      THEN
         /* Not much to do here. Find 0th atomic? */
         RETURN NULL;
      ELSE
         /* Initialize the loop variables. */

         /* SEF 9/25/97 - do not get length based on TRIMs of blanks. */
         --len_string := string_length (local_string);
         len_string := LENGTH (local_string);

         IF nth_in > 0
         THEN
            /* Start at first non-blank character and scan forward. */
            scan_increment := 1;
         ELSE
            /* Start at last non-blank character and scan backward. */
            scan_increment := -1;
         END IF;

         IF start_in > 0
         THEN
            next_loc := start_in;
         ELSE
            next_loc := len_string + start_in;
         END IF;

         /* Loop through the string until the Boolean is FALSE. */
         WHILE still_scanning
         LOOP
            /* Move start of scan in string to loc of last atomic. */
            start_loc := next_loc;
            /* Find the starting point of the next atomic. */
            next_loc :=
               next_atom_loc (local_string,
                  start_loc,
                  scan_increment,
                  delimiters_in
               );
            /* Increment the count of atomics. */
            increment_counter (atomic_count,
               v_type/* 7/99 UPPER (count_type_in) */,
               SUBSTR (local_string, start_loc, 1),
               delimiters_in
            );
            /*
            || Keep scanning if my count hasn't exceeded the request
            || and I am neither at the beginning nor end of the string.
            */
            still_scanning :=
                   atomic_count <= ABS (nth_in)
               AND next_loc <= len_string
               AND next_loc >= 1;
         END LOOP;

         /*
         || Done with the loop. If my count has not exceeded the requested
         || amount, then there weren't enough atomics in the string to
         || satisfy the request.
         */
         IF atomic_count <= ABS (nth_in)
         THEN
            RETURN NULL;
         ELSE
            /*
            || I need to extract the atomic from the string. If scanning
            || forward, then I start at start_loc and SUBSTR forward.
            || If I am scanning backwards, I start at next_loc+1 (next_loc
            || is the starting point of the NEXT atomic and I want the
            || current one) and SUBSTR forward (when scanning in
            || reverse, next_loc comes before start_loc in the string.
            */
            IF scan_increment = +1
            THEN
               RETURN SUBSTR (local_string, start_loc, next_loc - start_loc);
            ELSE
               RETURN SUBSTR (local_string,
                         next_loc + 1,
                         start_loc - next_loc
                      );
            END IF;
         END IF;
      END IF;
   END nth_atomic;

   FUNCTION numinstr (
      string_in        IN   VARCHAR2,
      substring_in     IN   VARCHAR2,
      ignore_case_in   IN   VARCHAR2 := c_ignore_case
   )
      RETURN INTEGER
   /*
   || Function returns the number of times a sub-string
   || appears in a string.
   ||
   || Idea for this simple, one-pass algorithm comes
   || from Kevin Loney. If it looks crazy, it is because
   || I am handling the case issue.
   */
   IS
      return_value   INTEGER := NULL;
   BEGIN
      --PLVconfig.enforce_trial;

      IF ignore_case_in = c_ignore_case
      THEN
         return_value :=
            (
               LENGTH (string_in) -
                  NVL (LENGTH (REPLACE (UPPER (string_in),
                                  UPPER (substring_in)
                               )
                       ),
                     0
                  )
            ) /
               LENGTH (substring_in);
      ELSE
         return_value :=
            (
               LENGTH (string_in) -
                  NVL (LENGTH (REPLACE (string_in, substring_in)), 0)
            ) /
               LENGTH (substring_in);
      END IF;

      RETURN return_value;
   END;

   PROCEDURE wrap (
      text_in         IN       VARCHAR2,
      line_length     IN       INTEGER,
      paragraph_out   IN OUT   vc2000_t,
      num_lines_out   IN OUT   INTEGER,
      use_newlines    IN       BOOLEAN := FALSE,
      delimiters_in   IN       VARCHAR2 := std_delimiters
   )
   IS
      v_text             maxvc2_t;
      len_text           INTEGER;
      start_loc          INTEGER      := 1;
      end_loc            INTEGER      := 1;
      cr_loc             INTEGER;
      last_space_loc     INTEGER;
      curr_line          VARCHAR2(4000);
      break_on_newline   BOOLEAN      := FALSE;
   BEGIN
      --PLVconfig.enforce_trial;

      IF LTRIM (text_in) IS NULL
      THEN
         num_lines_out := 0;
      ELSE
         IF NOT use_newlines
         THEN
            v_text := REPLACE (text_in, CHR (10), ' ');
         ELSE
            v_text := text_in;
         END IF;

         len_text := LENGTH (v_text);
         num_lines_out := 1;

         LOOP
            EXIT WHEN end_loc > len_text;
            end_loc := LEAST (end_loc + line_length, len_text + 1);

            IF use_newlines
            THEN
               cr_loc := INSTR (text_in, CHR (10), start_loc);
               break_on_newline :=     cr_loc > 0
                                   AND end_loc > cr_loc;
            END IF;

            /* Get the next possible line of text */
            IF break_on_newline
            THEN
               paragraph_out (num_lines_out) :=
                               SUBSTR (v_text, start_loc, cr_loc - start_loc);
               end_loc := cr_loc + 1;
               break_on_newline := FALSE;
            ELSE
               curr_line := SUBSTR (v_text || ' ', start_loc, line_length + 1);
               last_space_loc :=
                  next_atom_loc (curr_line,
                     LENGTH (curr_line),
                     -1,
                     delimiters_in
                  );

/*
|| When NO delimiters exist, use full current line
|| otherwise, cut the line at the delimiter.
*/
               IF last_space_loc > 0
               THEN
                  end_loc := start_loc + last_space_loc;
               END IF;

               /* Add this line to the paragraph */
               paragraph_out (num_lines_out) :=
                               SUBSTR (v_text, start_loc, end_loc - start_loc);
            END IF;

            num_lines_out := num_lines_out + 1;
            start_loc := end_loc;
         END LOOP;

         num_lines_out := num_lines_out - 1;
      END IF;
   END wrap;

   PROCEDURE display_wrap (
      text_in         IN   VARCHAR2,
      line_length     IN   INTEGER := 80,
      prefix_in       IN   VARCHAR2 := NULL,
      use_newlines    IN   BOOLEAN := FALSE,
      delimiters_in   IN   VARCHAR2 := std_delimiters
   )
   IS
      lines        vc2000_t;
      line_count   INTEGER             := 0;
   BEGIN
      wrap (text_in,
         line_length,
         lines,
         line_count,
         use_newlines,
         delimiters_in
      );

      IF lines.COUNT > 0
      THEN
         FOR indx IN lines.FIRST .. lines.LAST
         LOOP
            DBMS_OUTPUT.PUT_LINE (prefix_in || lines (indx));
         END LOOP;
      END IF;
   END;

   FUNCTION wrapped_string (
      text_in         IN   VARCHAR2,
      line_length     IN   INTEGER := 80,
      use_newlines    IN   BOOLEAN := FALSE,
      delimiters_in   IN   VARCHAR2 := std_delimiters
   )
      RETURN VARCHAR2
   IS
      lines          vc2000_t;
      line_count     INTEGER             := 0;
      return_value   PLV.maxvc2          := NULL;
   BEGIN
      wrap (text_in,
         line_length,
         lines,
         line_count,
         use_newlines,
         delimiters_in
      );

      FOR line_num IN 1 .. line_count
      LOOP
         return_value := return_value || CHR (10) || lines (line_num);
      END LOOP;

      RETURN return_value;
   END wrapped_string;
END PLVprs;
/
