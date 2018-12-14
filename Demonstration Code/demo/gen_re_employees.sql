BEGIN
   hr.gen_row_exists ( tab_in           => 'my_books'
                     , sch_in           => USER
                     , pkg_name_in      => 'my_books_re'
                     , to_file_in       => FALSE
                     , file_in          => NULL
                     , dir_in           => NULL
                     );
END;
/
