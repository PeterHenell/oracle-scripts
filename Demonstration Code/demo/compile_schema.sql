BEGIN
   DBMS_UTILITY.compile_schema ( SCHEMA              => USER
                               , compile_all         => FALSE
                               , reuse_settings      => TRUE
                               );
END;
