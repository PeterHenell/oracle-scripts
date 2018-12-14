CREATE OR REPLACE PACKAGE BODY ut_between_string
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;

   -- For each program to test...
PROCEDURE ut_between_string
IS
  -- Verify and complete data types.
  check_this     VARCHAR2 (2000);
  against_this   VARCHAR2 (2000);
BEGIN
  -- Define "control" operation for "Start and end within string"
  against_this := 'cde';
  -- Execute test code for "Start and end within string"
  check_this :=
     between_string (string_in         => 'abcdefgh'
                   , start_in          => 3
                   , end_in            => 5
                   , inclusive_in      => TRUE
                    );
  -- Assert success for "Start and end within string"

  -- Compare the two values.
  utassert.eq ('Start and end inside the string', check_this
             , against_this);
  -- End of test for "Start and end within string"

      -- Define "control" operation for "zero start"
      against_this := 'ab';
      -- Execute test code for "zero start"
      check_this :=
         between_string (string_in         => 'abcdefgh'
                       , start_in          => 0
                       , end_in            => 2
                       , inclusive_in      => TRUE
                        );
      -- Assert success for "zero start"

      -- Compare the two values.
      utassert.eq ('zero start', check_this, against_this);
      -- End of test for "zero start"

      -- Define "control" operation for "null start"
      against_this := NULL;
      -- Execute test code for "null start"
      check_this :=
         between_string (string_in         => 'abcdefgh'
                       , start_in          => NULL
                       , end_in            => 2
                       , inclusive_in      => TRUE
                        );
      -- Assert success for "null start"

      -- Check for NULL return value.
      utassert.isnull ('null start', check_this);
      -- End of test for "null start"

      -- Define "control" operation for "big start small end"
      against_this := NULL;
      -- Execute test code for "big start small end"
      check_this :=
         between_string (string_in         => 'abcdefgh'
                       , start_in          => 10
                       , end_in            => 5
                       , inclusive_in      => TRUE
                        );
      -- Assert success for "big start small end"

      -- Check for NULL return value.
      utassert.isnull ('Start greater than end', check_this);
      -- End of test for "big start small end"

      -- Define "control" operation for "null end"
      against_this := NULL;
      -- Execute test code for "null end"
      check_this :=
         between_string (string_in         => 'abcdefgh'
                       , start_in          => 3
                       , end_in            => NULL
                       , inclusive_in      => TRUE
                        );
      -- Assert success for "null end"

      -- Check for NULL return value.
      utassert.isnull ('null end', check_this);
      -- End of test for "null end"

      -- Define "control" operation for "neg start and end too big"
      against_this := 'abcdefgh';
      -- Execute test code for "neg start and end too big"
      check_this :=
         between_string (string_in         => 'abcdefgh'
                       , start_in          => -1
                       , end_in            => -15
                       , inclusive_in      => TRUE
                        );
      -- Assert success for "neg start and end too big"

      -- Compare the two values.
      utassert.eq ('neg start and end too big', check_this, against_this);
      -- End of test for "neg start and end too big"

      -- Define "control" operation for "neg start and end"
      against_this := 'efg';
      -- Execute test code for "neg start and end"
      check_this :=
         between_string (string_in         => 'abcdefgh'
                       , start_in          => -2
                       , end_in            => -4
                       , inclusive_in      => TRUE
                        );
      -- Assert success for "neg start and end"

      -- Compare the two values.
      utassert.eq ('Negative start and end values', check_this, against_this);
   -- End of test for "neg start and end"
   END ut_between_string;
END ut_between_string;
/