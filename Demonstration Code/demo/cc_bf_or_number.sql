CREATE OR REPLACE PROCEDURE crunch_numbers
IS
   n $IF DBMS_DB_VERSION.VER_LE_9_2 $THEN NUMBER;
     $ELSE BINARY_FLOAT;
     $END
BEGIN
   n := $IF DBMS_DB_VERSION.VER_LE_9_2 $THEN 1.0
   $ELSE 1.0f
   $END
   ;
   DBMS_OUTPUT.put_line ( n );
END crunch_numbers;
/

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PROCEDURE', USER, 'CRUNCH_NUMBERS');
END;
/
