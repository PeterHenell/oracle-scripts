/* You cannot use CONTINUE in a FORALL header:

   PLS-00103: Encountered the symbol "CONTINUE" when expecting one of the following:
*/

CREATE TABLE plch_tab (n NUMBER)
/

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_numbers   numbers_t := numbers_t (1, 2);
BEGIN
   FORALL indx IN 1 .. l_numbers.COUNT
      CONTINUE
      UPDATE plch_tab
         SET n = l_numbers (indx);
END;
/

/* You certainly can use CONTINUE in a numeric FOR loop */

BEGIN
  <<for_loop>>
   FOR indx IN 1 .. 5
   LOOP
      DBMS_OUTPUT.put_line ('Outer: ' || indx);
      CONTINUE for_loop;

      FOR indx2 IN 1 .. 5
      LOOP
         DBMS_OUTPUT.put_line ('Inner: ' || indx2);
      END LOOP;
   END LOOP;
END;
/

/* You can use CONTINUE without a label */

BEGIN
   FOR indx IN 1 .. 5
   LOOP
      DBMS_OUTPUT.put_line ('Outer: ' || indx);
      CONTINUE;

      FOR indx2 IN 1 .. 5
      LOOP
         DBMS_OUTPUT.put_line ('Inner: ' || indx2);
      END LOOP;
   END LOOP;
END;
/

/* You cannot use CONTINUE outside of a loop:

   PLS-00376: illegal EXIT/CONTINUE statement; it must appear inside a loop
   PLS-00373: EXIT/CONTINUE label 'START_BLOCK' must label a LOOP statement
*/

BEGIN
   CONTINUE;
END;
/

BEGIN
  <<start_block>>
   NULL;
   CONTINUE start_block;
END;
/

/* Clean up */

DROP TABLE plch_tab
/