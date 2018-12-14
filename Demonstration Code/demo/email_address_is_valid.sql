DECLARE
   PROCEDURE bpl ( val IN BOOLEAN )
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line ( 'TRUE' );
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line ( 'FALSE' );
      ELSE
         DBMS_OUTPUT.put_line ( 'NULL' );
      END IF;
   END bpl;
BEGIN
   bpl ( email_address_is_valid ( 'steven@stevenfeuerstein.com' ));
   bpl ( email_address_is_valid ( 'stevenfeuerstein.com' ));
   bpl ( email_address_is_valid ( 'steven@stevenfeuerstein@com' ));
END;
