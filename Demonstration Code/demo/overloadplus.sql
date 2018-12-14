/*
This does NOT work in 10g...

PLS-00736: user-declared operators are not allowed

*/

SET serveroutput on size 9999

CREATE OR REPLACE PACKAGE p1
AS
   TYPE foo IS RECORD (
      f1   NUMBER
    , f2   VARCHAR2 (20)
   );

   FUNCTION '+' (LEFT foo, RIGHT foo)
      RETURN foo;

   PROCEDURE bar;
END;
/

SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY p1
IS
   a   foo;
   b   foo;
   c   foo;

   FUNCTION '+' (LEFT foo, RIGHT foo)
      RETURN foo
   IS
      ret_val   foo;
   BEGIN
      ret_val.f1 := LEFT.f1 + RIGHT.f1;
      ret_val.f2 := LEFT.f2 || RIGHT.f2;
      RETURN ret_val;
   END;

   PROCEDURE bar
   IS
   BEGIN
      a.f1 := 10;
      a.f2 := 'ABC';
      b.f1 := 10;
      b.f2 := 'DEF';
      DBMS_OUTPUT.put_line ('before');
      c := a + b;
      DBMS_OUTPUT.put_line ('after');
      DBMS_OUTPUT.put_line (c.f1);
      DBMS_OUTPUT.put_line (c.f2);
   END;
END p1;
/

SHOW errors

EXECUTE p1.bar;

/* But cannot reference outside of package... */

DECLARE
   a   p1.foo;
   b   p1.foo;
   c   p1.foo;
BEGIN
   c := p1."+" (a, b);
   DBMS_OUTPUT.put_line ('DOUBLE WOW ' || c.f1);
END;
/