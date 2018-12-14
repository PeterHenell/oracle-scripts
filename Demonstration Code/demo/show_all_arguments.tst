/*
Dependencies:

@show_all_arguments_setup.sql
@show_all_arguments.sp
*/

BEGIN
   show_all_arguments
           (program_in                   => 'ALLARGS_TEST'
          , show_collections_in          => TRUE
          , show_loading_process_in      => FALSE
           );
END;
/
