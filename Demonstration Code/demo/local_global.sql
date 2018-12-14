CREATE OR REPLACE PROCEDURE local_global
IS
   l_id   NUMBER;

   PROCEDURE reference_out_of_scope
   IS
   BEGIN
      l_id := 10;
   END;
BEGIN
   reference_out_of_scope ();
END;