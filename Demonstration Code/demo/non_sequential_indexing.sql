spool non_sequential_indexing.log

set serveroutput on format wrapped 

DROP TABLE parts
/

CREATE TABLE parts
(
   partnum    NUMBER
 , partname   VARCHAR2 (100)
)
/

CREATE OR REPLACE PROCEDURE non_sequential_indexing (num IN INTEGER)
IS
   TYPE parts_t IS TABLE OF parts%ROWTYPE
                      INDEX BY PLS_INTEGER;

   l_parts_seq      parts_t;
   l_parts_nonseq   parts_t;
   l_name           parts.partname%TYPE;

   FUNCTION name_for_num (partnum_in IN INTEGER)
      RETURN VARCHAR2
   IS
      c_count   CONSTANT PLS_INTEGER := l_parts_seq.COUNT;
      l_index            PLS_INTEGER := l_parts_seq.FIRST;
      l_found            BOOLEAN DEFAULT FALSE;
   BEGIN
      WHILE (NOT l_found AND l_index <= c_count)
      LOOP
         l_found := partnum_in = l_parts_seq (l_index).partnum;
         l_index := l_index + 1;
      END LOOP;

      RETURN CASE
                WHEN l_found THEN l_parts_seq (l_index - 1).partname
                ELSE NULL
             END;
   END name_for_num;
BEGIN
   FOR indx IN 1 .. num
   LOOP
      INSERT INTO parts
           VALUES (indx, 'Part ' || TO_CHAR (indx));
   END LOOP;

   COMMIT;
   sf_timer.start_timer;

   SELECT *
     BULK COLLECT INTO l_parts_seq
     FROM parts;

   sf_timer.show_elapsed_time ('sequential load of '||num);

   sf_timer.start_timer;

   FOR rec IN (SELECT * FROM parts)
   LOOP
      l_parts_nonseq (rec.partnum).partnum := rec.partnum;
      l_parts_nonseq (rec.partnum).partname := rec.partname;
   END LOOP;

   sf_timer.show_elapsed_time ('non-sequential load');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. num
   LOOP
      l_name := name_for_num (indx);
   END LOOP;

   sf_timer.show_elapsed_time ('sequential lookup');

   sf_timer.start_timer;

   FOR indx IN 1 .. num
   LOOP
      l_name := l_parts_nonseq (indx).partname;
   END LOOP;

   sf_timer.show_elapsed_time ('non-sequential lookup');
END;
/

BEGIN
   non_sequential_indexing (50000);
/*
sequential load of 50000 - Elapsed CPU : .05 seconds.
non-sequential load - Elapsed CPU : .06 seconds.
sequential lookup - Elapsed CPU : 187.03 seconds.
non-sequential lookup - Elapsed CPU : .02 seconds.
*/
END;
/

DROP TABLE parts
/

spool off