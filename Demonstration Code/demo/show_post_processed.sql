BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PROCEDURE', USER, '&1');
END;
/