DECLARE
   utc   VARCHAR2 (32767)
      := '#program name|test case name|message|arguments|result|assertion type
is_number|1|only digits|the string contains only digits 0-9|123456;!NULL|!TRUE|eq|Y
is_number|1|digits with decimal delimiter|contains digits 0-9 plus decimal delimiter|12345600.567;!NULL|!TRUE|eq|Y
is_number|1|scientific notation|uses "e" syntax|12e55;!NULL|!TRUE|eq|Y
is_number|1|IN-pass null|a null string is passed|!NULL;!NULL|!FALSE|isnull|Y
#
is_letter|1|single letter for letter|the string contains a single letter|a|!TRUE|eq|Y
is_letter|1|single number for letter|the string contains a single number|3|!FALSE|eq|Y
is_letter|1|single delimiter for letter|the string contains a single delimiter|\|!FALSE|eq|Y
is_letter|1|IL-pass null|a null string is passed|!NULL|!FALSE|isnull|Y
#
is_digit|1|single letter for digit|the string contains a single letter|a|!FALSE|eq|Y
is_digit|1|single number for digit|the string contains a single number|3|!TRUE|eq|Y
is_digit|1|single delimiter for digit|the string contains a single delimiter|\|!FALSE|eq|Y
is_digit|1|ID-pass null|a null string is passed|!NULL|!FALSE|isnull|Y
#
is_alpha_numeric|1|AN-valid string|bunch of letters and numbers|abc44rr6;!NULL|!TRUE|eq|Y
is_alpha_numeric|1|AN-delimiters all|a string with only delimiters|_$#%^@;!NULL|!FALSE|eq|Y
is_alpha_numeric|1|AN-letters and delimiters|a string with letters and delimiters|abc$def;!NULL|!FALSE|eq|Y
is_alpha_numeric|1|AN-pass null|a null string is passed|!NULL;!NULL|!FALSE|isnull|Y
#
only_letters|1|OL-surname|a string with just my last name|Feuerstein|!TRUE|eq|Y
only_letters|1|OL-partname|a string with letters and numbers - a part name|WIDGET107|!FALSE|eq|Y
only_letters|1|OL-pass null|a null string is passed|!NULL|!FALSE|isnull|Y
#
is_identifier|1|IDENT-all letters|standard valid identifer, all letters|is_letter|!TRUE|eq|Y
is_identifier|1|IDENT-regular name|Normal, valid name of program|check_string|!TRUE|eq|Y
is_identifier|1|IDENT-bad delimiters|Program name with hyphen|check-string|!FALSE|eq|Y
is_identifier|1|IDENT-anything goes|Crazy string inside double quotes|"^this is@crazy"|!TRUE|eq|Y
is_identifier|1|IDENT-too long|Identifier with more than 30 characters|a123456789b123456789c123456789d123456789|!FALSE|eq|Y
';
BEGIN
   utgen.testpkg_from_string ('check_string'
                            , utc
                            , output_type_in      => utgen.c_file
                            , dir_in              => 'TEMP'
							, only_if_in_grid_in => TRUE
                             );
END;
/
