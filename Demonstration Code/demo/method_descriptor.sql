CREATE OR REPLACE FUNCTION method_descriptor (
      type_owner_in    IN   all_types.owner%TYPE
    , type_name_in     IN   all_types.type_name%TYPE
    , method_name_in   IN   all_type_methods.method_name%TYPE
    , method_no_in     IN   all_type_methods.method_no%TYPE
   )
      RETURN VARCHAR2
   IS
      l_return   VARCHAR2(100);

      /* Is there a method with these names? */
      FUNCTION method_exists (
         type_owner_in    IN   all_types.owner%TYPE
       , type_name_in     IN   all_types.type_name%TYPE
       , method_name_in   IN   all_type_methods.method_name%TYPE
       , method_no_in     IN   all_type_methods.method_no%TYPE
      )
         RETURN BOOLEAN
      IS
         l_count   PLS_INTEGER;
      BEGIN
         SELECT COUNT ('x')
           INTO l_count
           FROM all_method_params
          WHERE owner = type_owner_in
            AND type_name = type_name_in
            AND method_name = method_name_in
            AND method_no = method_no_in;

         RETURN l_count > 0;
      END method_exists;

      /* Does the specified non-constructor method have a SELF argument? */
      FUNCTION has_self (
         type_owner_in    IN   all_types.owner%TYPE
       , type_name_in     IN   all_types.type_name%TYPE
       , method_name_in   IN   all_type_methods.method_name%TYPE
       , method_no_in     IN   all_type_methods.method_no%TYPE
      )
         RETURN BOOLEAN
      IS
         l_count   PLS_INTEGER;
      BEGIN
         SELECT COUNT ('x') INTO l_count
           FROM all_method_params
          WHERE owner = type_owner_in
            AND type_name = type_name_in
            AND method_name = method_name_in
            AND method_name <> type_name
            AND method_no = method_no_in
            AND param_name = 'SELF';

         RETURN l_count = 1;
      END has_self;
   BEGIN
      IF NOT method_exists (type_owner_in
                          , type_name_in
                          , method_name_in
                          , method_no_in
                           )
      THEN
         raise_application_error (-20000
                                ,    'Method '
                                  || type_owner_in
                                  || '.'
                                  || type_name_in
                                  || '.'
                                  || method_name_in
                                  || '-'
                                  || method_no_in
                                  || ' does not exist!'
                                 );
      END IF;


      CASE
         WHEN type_name_in = method_name_in
         THEN
            l_return := 'CONSTRUCTOR';
         WHEN has_self (type_owner_in
                      , type_name_in
                      , method_name_in
                      , method_no_in
                       )
         THEN
            l_return := 'MEMBER';
         ELSE
            l_return := 'STATIC';
      END CASE;

      RETURN l_return;
   END method_descriptor;
/
