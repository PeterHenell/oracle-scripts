DECLARE
   a NUMBER := 1;
   b NUMBER := 0;
   l_user all_objects.owner%TYPE;

   FUNCTION who_is_it ( schema_in IN NUMBER DEFAULT a / b )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'abc';
   END who_is_it;
BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      l_user := who_is_it ( );
   END LOOP;
END;
/
