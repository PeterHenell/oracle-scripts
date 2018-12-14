-- Must run in SCOTT schema

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE this_one (n in number)
IS
BEGIN
   DBMS_OUTPUT.put_line ( 'schema-level' );
END this_one;
/

CREATE OR REPLACE PACKAGE same_name
IS
   PROCEDURE this_one (n in number);

   PROCEDURE that_one;
END same_name;
/

CREATE OR REPLACE PACKAGE BODY same_name
IS
   PROCEDURE this_one (n in number)
   IS
   BEGIN
      DBMS_OUTPUT.put_line ( 'package-level' );
   END this_one;

   PROCEDURE that_one
   IS
   BEGIN
      this_one (10);
	  
      scott.this_one (10);

      EXECUTE IMMEDIATE 'BEGIN same_name.this_one (:val); END;'
         USING 10;
	  
      EXECUTE IMMEDIATE 'BEGIN this_one (:val); END;'
         USING 10;
   END that_one;
END same_name;
/

BEGIN
   same_name.that_one;
END;
/
