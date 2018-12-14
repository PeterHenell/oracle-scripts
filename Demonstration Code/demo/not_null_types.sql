DECLARE
   my_value   NATURAL;
BEGIN
   my_value := 100;
   DBMS_OUTPUT.put_line (my_value);
END;
/

/*
PLS-00218: a variable declared NOT NULL must have an initialization assignment
*/

DECLARE
   my_value   NATURALN;
BEGIN
   my_value := 100;
   DBMS_OUTPUT.put_line (my_value);
END;
/

DECLARE
   my_value   NATURAL := 100;
BEGIN
   DBMS_OUTPUT.put_line (my_value);
END;
/

DECLARE
   my_value   NATURALN := 100;
BEGIN
   DBMS_OUTPUT.put_line (my_value);
END;
/

/* Same with POSITIVE */

DECLARE
   my_value   NATURAL;
BEGIN
   my_value := 100;
   DBMS_OUTPUT.put_line (my_value);
END;
/

/*
PLS-00218: a variable declared NOT NULL must have an initialization assignment
*/

DECLARE
   my_value   POSITIVEN;
BEGIN
   my_value := 100;
   DBMS_OUTPUT.put_line (my_value);
END;
/

DECLARE
   my_value   POSITIVE := 100;
BEGIN
   DBMS_OUTPUT.put_line (my_value);
END;
/

DECLARE
   my_value   POSITIVEN := 100;
BEGIN
   DBMS_OUTPUT.put_line (my_value);
END;
/