DECLARE
   utc   VARCHAR2 (1000)
      := '#program name|test case name|message|arguments|result|assertion type
betwnstr|1|normal|normal|abcdefgh;2;5;!TRUE|cde|eq|N
betwnstr|1|zero start|zero start|abcdefgh;0;2;!TRUE|ab|eq|N
betwnstr|1|null start|null start|abcdefgh;!null;2;!TRUE|null|isnull|N
betwnstr|1|big start small end|big start small end|abcdefgh;10;5;!TRUE|null|isnull|N
betwnstr|1|null end|null end|abcdefgh;!3;!null;!TRUE|null|isnull|N
betwnstr|1|neg start and end too big|neg start and end too big|abcdefgh;-1;-15;!TRUE|abcdefgh|eq|N
betwnstr|1|neg start and end|neg start and end|abcdefgh;-2;-4;!TRUE|efg|eq|N';
BEGIN
   utgen.testpkg_from_string (package_in          => 'betwnstr'
                            , grid_in             => utc
                            , output_type_in      => utgen.c_file
                            , dir_in              => 'TEMP'
                             );
END;
/