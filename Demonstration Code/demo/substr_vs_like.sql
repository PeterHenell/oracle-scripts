DECLARE
/*
Proof that at least as of 9.2, like is faster than substr

success like % Elapsed: 1.23 seconds. Factored: 0 seconds.
success = substr Elapsed: 1.58 seconds. Factored: 0 seconds.
failure like % Elapsed: 1.2 seconds. Factored: 0 seconds.
failure = substr Elapsed: 1.66 seconds. Factored: 0 seconds.
*/
   b boolean;
   s varchar2(100) := 'abcdef';
   c char(1) := 'a';
   v char(2) := 'a%';
   counter pls_integer := 1000000; 
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      b := s like c || '%';
   END LOOP;
   sf_timer.show_elapsed_time ('success like concat %');

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      b := substr (s, 1, 1) = c;
   END LOOP;
   sf_timer.show_elapsed_time ('success = substr');
   
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      b := s like v;
   END LOOP;
   sf_timer.show_elapsed_time ('success like %');
   
   c := 'x';
   
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      b := s like c || '%';
   END LOOP;
   sf_timer.show_elapsed_time ('failure like %');

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      b := substr (s, 1, 1) = c;
   END LOOP;
   sf_timer.show_elapsed_time ('failure = substr');   
END;
/
