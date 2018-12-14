/* Try delete a range */

DECLARE
   TYPE numbers_t IS VARRAY (5) OF NUMBER;

   l_numbers   numbers_t
                  := numbers_t (1,
                                2,
                                3,
                                4,
                                5);
   l_index     PLS_INTEGER;
BEGIN
   l_numbers.delete (2, 4);
   l_index := l_numbers.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (l_numbers (l_index));
      l_index := l_numbers.NEXT (l_index);
   END LOOP;
END;
/

/* Three individual deletes */

DECLARE
   TYPE numbers_t IS VARRAY (5) OF NUMBER;

   l_numbers   numbers_t
                  := numbers_t (1,
                                2,
                                3,
                                4,
                                5);
   l_index     PLS_INTEGER;
BEGIN
   l_numbers.delete (2);
   l_numbers.delete (3);
   l_numbers.delete (4);

   l_index := l_numbers.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (l_numbers (l_index));
      l_index := l_numbers.NEXT (l_index);
   END LOOP;
END;
/

/* Copy those I want to keep */

DECLARE
   TYPE numbers_t IS VARRAY (5) OF NUMBER;

   l_numbers   numbers_t
                  := numbers_t (1,
                                2,
                                3,
                                4,
                                5);
   l_index     PLS_INTEGER;
BEGIN
   DECLARE
      l_temp   numbers_t := numbers_t ();
   BEGIN
      FOR indx IN 1 .. l_numbers.COUNT
      LOOP
         IF indx IN (1, 5)
         THEN
            l_temp.EXTEND;
            l_temp (l_temp.LAST) := l_numbers (indx);
         END IF;
      END LOOP;

      l_numbers := l_temp;
   END;

   l_index := l_numbers.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (l_numbers (l_index));
      l_index := l_numbers.NEXT (l_index);
   END LOOP;
END;
/

/* Trim back four and add one. */

DECLARE
   TYPE numbers_t IS VARRAY (5) OF NUMBER;

   l_numbers   numbers_t
                  := numbers_t (1,
                                2,
                                3,
                                4,
                                5);
   l_index     PLS_INTEGER;
BEGIN
   l_numbers.TRIM (4);
   l_numbers.EXTEND;
   l_numbers (2) := 5;

   l_index := l_numbers.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (l_numbers (l_index));
      l_index := l_numbers.NEXT (l_index);
   END LOOP;
END;
/