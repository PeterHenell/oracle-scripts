DECLARE
   t1 VARCHAR2 ( 100 ) := 'dyn_placeholder.placeholder_t';
   t2 VARCHAR2 ( 100 ) := 'dbms_sql.varchar2s';

   FUNCTION needs_eq_function ( type_in IN VARCHAR2 )
      RETURN BOOLEAN
   IS
   BEGIN
      EXECUTE IMMEDIATE    'declare v '
                        || type_in
                        || '; begin select 1 bulk collect into v from dual; end;';

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         BEGIN
            EXECUTE IMMEDIATE    'declare v '
                              || type_in
                              || '; begin select sysdate bulk collect into v from dual; end;';

            RETURN TRUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               RETURN FALSE;
         END;
   END;
BEGIN
   qd_runtime.pl ( needs_eq_function ( t1 ));
   qd_runtime.pl ( needs_eq_function ( t2 ));
END;
