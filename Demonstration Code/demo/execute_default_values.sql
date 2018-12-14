DECLARE
   l_count PLS_INTEGER := 1;
   l_user all_objects.owner%TYPE;

   FUNCTION my_user
      RETURN VARCHAR2
   IS
   BEGIN
      l_count := l_count + 1;
      RETURN USER;
   END my_user;

   FUNCTION who_is_it ( schema_in IN VARCHAR2 DEFAULT my_user )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN NVL ( schema_in, my_user );
   END who_is_it;
BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      l_user := who_is_it ( 'SCOTT' );
   END LOOP;

   DBMS_OUTPUT.put_line ( l_count );
END;
/
