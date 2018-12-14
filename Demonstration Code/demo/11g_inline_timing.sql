DECLARE
   n   NUMBER;

   FUNCTION f1 (p NUMBER)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN p * 10;
   END;

   FUNCTION f2 (p NUMBER)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN p * 10;
   END;
BEGIN
   sf_timer.start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      PRAGMA INLINE (f1, 'YES');
      n := f1 (indx);
   END LOOP;

   sf_timer.show_elapsed_time ('INLINE');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. 10000000
   LOOP
      n := f2 (indx);
   END LOOP;

   sf_timer.show_elapsed_time ('NO INLINE');
END;
/