ALTER SESSION SET PLSQL_CCFLAGS = 'show_private_joke_programs:FALSE'
/

CREATE OR REPLACE PACKAGE sense_of_humor
IS
   PROCEDURE calc_how_funny (
      joke_in               IN       VARCHAR2
    , funny_rating_out      OUT      NUMBER
    , appropriate_age_out   OUT      NUMBER
   );
$IF $$show_private_joke_programs $THEN
   FUNCTION humor_level ( joke_in IN VARCHAR2 )
      RETURN NUMBER;
            
    FUNCTION maturity_level ( joke_in IN VARCHAR2 )
      RETURN NUMBER;
$END         
END;
/

CREATE OR REPLACE PACKAGE BODY sense_of_humor
IS
   FUNCTION humor_level ( joke_in IN VARCHAR2 )
      RETURN NUMBER
   IS
   BEGIN
      -- Some really interesting code here...
      RETURN NULL;
   END humor_level;

   FUNCTION maturity_level ( joke_in IN VARCHAR2 )
      RETURN NUMBER
   IS
   BEGIN
      -- Some really interesting code here...
      RETURN NULL;
   END maturity_level;

   PROCEDURE calc_how_funny (
      joke_in               IN       VARCHAR2
    , funny_rating_out      OUT      NUMBER
    , appropriate_age_out   OUT      NUMBER
   )
   IS
   BEGIN
      funny_rating_out := humor_level ( joke_in );
      appropriate_age_out := maturity_level ( joke_in );
   END calc_how_funny;
END;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PACKAGE', USER, 'SENSE_OF_HUMOR');
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'show_private_joke_programs:TRUE'
/

ALTER PACKAGE sense_of_humor COMPILE
/

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PACKAGE', USER, 'SENSE_OF_HUMOR');
END;
/

CREATE OR REPLACE PACKAGE sense_of_humor
IS
   PROCEDURE calc_how_funny (
      joke_in               IN       VARCHAR2
    , funny_rating_out      OUT      NUMBER
    , appropriate_age_out   OUT      NUMBER
   );

   PROCEDURE test_package;
END;
/


CREATE OR REPLACE PACKAGE BODY sense_of_humor
IS
   FUNCTION humor_level ( joke_in IN VARCHAR2 )
      RETURN NUMBER
   IS
   BEGIN
      -- Some really interesting code here...
      RETURN NULL;
   END humor_level;

   FUNCTION maturity_level ( joke_in IN VARCHAR2 )
      RETURN NUMBER
   IS
   BEGIN
      -- Some really interesting code here...
      RETURN NULL;
   END maturity_level;

   PROCEDURE calc_how_funny (
      joke_in               IN       VARCHAR2
    , funny_rating_out      OUT      NUMBER
    , appropriate_age_out   OUT      NUMBER
   )
   IS
   BEGIN
      funny_rating_out := humor_level ( joke_in );
      appropriate_age_out := maturity_level ( joke_in );
   END calc_how_funny;
   
   $IF $$test_humor_package  $THEN
   PROCEDURE int_test_package
   IS
   BEGIN
	  DBMS_OUTPUT.PUT_LINE ('Testing of sense_of_humor is enabled.');  
   END int_test_package;
   $END

   PROCEDURE test_package
   IS
   BEGIN
   $IF $$test_humor_package 
   $THEN
      int_test_package;
   $ELSE
      RAISE PROGRAM_ERROR;
   $END
   END test_package;
   
END;
/

BEGIN
   DBMS_OUTPUT.PUT_LINE ('New test_humor_package not set....'); 
   dbms_preprocessor.print_post_processed_source (
      'PACKAGE BODY', USER, 'SENSE_OF_HUMOR');
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'test_humor_package:FALSE'
/

ALTER PACKAGE sense_of_humor COMPILE
/

BEGIN
   DBMS_OUTPUT.PUT_LINE ('test_humor_package set to FALSE....'); 
   dbms_preprocessor.print_post_processed_source (
      'PACKAGE BODY', USER, 'SENSE_OF_HUMOR');
END;
/

BEGIN
   sense_of_humor.test_package;
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'test_humor_package:TRUE'
/

ALTER PACKAGE sense_of_humor COMPILE
/

BEGIN
   DBMS_OUTPUT.PUT_LINE ('test_humor_package set to TRUE....'); 
   dbms_preprocessor.print_post_processed_source (
      'PACKAGE BODY', USER, 'SENSE_OF_HUMOR');
END;
/

BEGIN
   sense_of_humor.test_package;
END;
/
   
