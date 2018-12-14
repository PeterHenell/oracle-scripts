SELECT 'SQL IN trimmed trailing blanks!'
  FROM DUAL
 WHERE 'CA   ' IN ( 'CA', 'US' )
/
SELECT 'SQL IN trimmed trailing tab!'
  FROM DUAL
 WHERE 'CA ' IN ( 'CA', 'US' )
/
SELECT 'SQL IN does not trim leading blanks!'
  FROM DUAL
 WHERE '   CA' IN ( 'CA', 'US' )
/

DECLARE
   PROCEDURE exec_in ( message_in IN VARCHAR2, value_in IN VARCHAR2 )
   IS
      l_dummy VARCHAR2 ( 32767 );
   BEGIN
      BEGIN
         SELECT message_in
           INTO l_dummy
           FROM DUAL
          WHERE value_in IN ( 'CA', 'US' );

         DBMS_OUTPUT.put_line ( message_in );
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ( message_in || ' did not happen.' );
      END;

      IF value_in IN ( 'CA', 'US' )
      THEN
         DBMS_OUTPUT.put_line ( '"PL/SQL IN ' || SUBSTR ( message_in, 9 ));
      ELSE
         DBMS_OUTPUT.put_line (    '"PL/SQL IN '
                                || SUBSTR ( message_in, 9 )
                                || ' did not happen.'
                              );
      END IF;
   END;
BEGIN
   exec_in ( '"SQL IN trimmed trailing blanks."', 'CA   ' );
   exec_in ( '"SQL IN trimmed leading blanks."', '   CA' );
   exec_in ( '"SQL IN trimmed trailing tab."', 'CA   ' );
END;
/
