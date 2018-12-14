DECLARE
      utc   VARCHAR2 (1000)
   := '#program name|test case name|message|arguments|result|assertion type
Betwnstr|1|NORMAL|NORMAL|abcdefgh;2;5;!TRUE|cde|eq
Betwnstr|1|zero START|zero START|abcdefgh;0;2;!TRUE|ab|eq
Betwnstr|1|NULL START|NULL START|abcdefgh;!NULL;2;!TRUE|NULL|isnull
Betwnstr|1|big START small END|big START small END|abcdefgh;10;5;!TRUE|NULL|isnull
Betwnstr|1|NULL END|NULL END|abcdefgh;!3;!NULL;!TRUE|NULL|isnull
Betwnstr|1|neg START AND END too big|neg START AND END too big|abcdefgh;-1;-15;!TRUE|abcdefgh|eq
Betwnstr|1|neg START AND END|neg START AND END|abcdefgh;-2;-4;!TRUE|gef|eq';
BEGIN
   Utgen.testpkg_from_string ('betwnstr',
      utc,
      output_type_in=> Utgen.c_file,
      dir_in=> 'd:\demo-seminar'
   );
END;
/

BEGIN
   Utgen.testpkg_from_table ('betwnstr',
      output_type_in=> Utgen.c_file,
      dir_in=> 'd:\demo-seminar'
   );
END;
/

