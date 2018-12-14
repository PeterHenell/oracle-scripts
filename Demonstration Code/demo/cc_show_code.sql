BEGIN
   dbms_preprocessor.print_post_processed_source (
      :progtype, USER, :progname);
END;
/