@tmr.ot
@translations
@vocab1
@vocab2
@vocab3
@vocab4
@vocab5

SET SERVEROUTPUT ON SIZE 1000000 FORMAT WRAPPED

CREATE OR REPLACE PROCEDURE test_assoc_array (
   p_iterations IN PLS_INTEGER
)
IS
   v translations.french%TYPE;
   db_tmr tmr_t := tmr_t.make ('DB lookup');
   linear_tmr tmr_t := tmr_t.make ('Linear search');
   hash_tmr tmr_t := tmr_t.make ('Hash Index');
   vc2_tmr tmr_t := tmr_t.make ('Assoc Array');
   vc2_nofunction_tmr tmr_t
      := tmr_t.make ('Assoc Array without Function');
BEGIN
   DBMS_OUTPUT.put_line ('');
   DBMS_OUTPUT.put_line (   'Compare Lookup Performance with '
                         || p_iterations
                         || ' iterations:');
   DBMS_OUTPUT.put_line ('');
   -- Reset memory
   DBMS_SESSION.free_unused_user_memory;
   db_tmr.go;

   FOR indx IN 1 .. p_iterations
   LOOP
      v := vocab1.lookup (   'english'
                          || indx);
   END LOOP;

   db_tmr.STOP;
   linear_tmr.go;

   FOR indx IN 1 .. p_iterations
   LOOP
      v := vocab2.lookup_for (   'english'
                              || indx);
   END LOOP;

   linear_tmr.STOP;
   hash_tmr.go;

   FOR indx IN 1 .. p_iterations
   LOOP
      v := vocab3.lookup (   'english'
                          || indx);
   END LOOP;

   hash_tmr.STOP;
   vc2_tmr.go;

   FOR indx IN 1 .. p_iterations
   LOOP
      v := vocab4.lookup (   'english'
                          || indx);
   END LOOP;

   vc2_tmr.STOP;
   vc2_nofunction_tmr.go;

   FOR indx IN 1 .. p_iterations
   LOOP
      v := vocab5.lookup (   'english'
                          || indx);
   END LOOP;

   vc2_nofunction_tmr.STOP;
END;
/

BEGIN
   test_assoc_array (5000);
   test_assoc_array (10000);
END;
/

/* My results:
Compare Lookup Performance with 5000 iterations:
Elapsed time for "DB lookup" = 1.65 seconds.
Elapsed time for "Linear search" = 29.52 seconds.
Elapsed time for "Hash Index" = .13 seconds.
Elapsed time for "Assoc Array" = .08 seconds.
Elapsed time for "Assoc Array without Function" = .06 seconds.

Compare Lookup Performance with 10000 iterations:
Elapsed time for "DB lookup" = 1.99 seconds.
Elapsed time for "Linear search" = 117.53 seconds.
Elapsed time for "Hash Index" = .33 seconds.
Elapsed time for "Assoc Array" = .19 seconds.
Elapsed time for "Assoc Array without Function" = .11 seconds.
*/

