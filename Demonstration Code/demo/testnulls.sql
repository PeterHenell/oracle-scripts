/* Formatted on 2001/06/20 15:33 (RevealNet Formatter v4.4.0) */
DECLARE
   TYPE bvec IS TABLE OF BOOLEAN
      INDEX BY BINARY_INTEGER;

   left      bvec;
   right     bvec;
   or_val    bvec;
   and_val   bvec;
   not_val   bvec;
   line      VARCHAR2 (100);

   FUNCTION string (b BOOLEAN)
      RETURN VARCHAR2
   IS
   BEGIN
      IF b IS NULL
      THEN
         RETURN 'NULL ';
      ELSIF b
      THEN
         RETURN 'TRUE ';
      ELSE
         RETURN 'FALSE';
      END IF;
   END string;
BEGIN
   left (1) := TRUE;
   left (2) := TRUE;
   left (3) := TRUE;
   left (4) := FALSE;
   left (5) := FALSE;
   left (6) := FALSE;
   left (7) := NULL;
   left (8) := NULL;
   left (9) := NULL;
   right (1) := TRUE;
   right (2) := FALSE;
   right (3) := NULL;
   right (4) := TRUE;
   right (5) := FALSE;
   right (6) := NULL;
   right (7) := TRUE;
   right (8) := FALSE;
   right (9) := NULL;

   FOR i IN 1 .. 9
   LOOP
      or_val (i) :=    left (i)
                    OR right (i);
      and_val (i) :=     left (i)
                     AND right (i);
      not_val (i) := NOT left (i);
   END LOOP;

   text_io.put_line ('Left  Right And   Or    Not  ');
   text_io.put_line ('----- ----- ----- ----- -----');

   FOR i IN 1 .. 9
   LOOP
      line :=    string (left (i))
              || ' '
              || string (right (i))
              || ' '
              || string (and_val (i))
              || ' '
              || string (or_val (i))
              || ' '
              || string (not_val (i))
              || ' ';
      text_io.put_line (line);
   END LOOP;
END;

