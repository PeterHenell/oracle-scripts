ALTER SESSION SET plsql_ccflags = 'include_nocopy:FALSE'
/
ALTER PACKAGE string_nocopy COMPILE
/

BEGIN
   string_nocopy.time_manipulate_string (count_in           => 10000
                                       , string_in          => 'abc'
                                       , to_length_in       => 32000
                                       , add_string_in      => '123'
                                        );
END;
/

ALTER SESSION SET plsql_ccflags = 'include_nocopy:TRUE'
/
ALTER PACKAGE string_nocopy COMPILE
/

BEGIN
   string_nocopy.time_manipulate_string (count_in           => 10000
                                       , string_in          => 'abc'
                                       , to_length_in       => 32000
                                       , add_string_in      => '123'
                                        );
END;
/