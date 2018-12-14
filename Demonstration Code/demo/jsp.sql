/* Formatted on 2001/09/11 06:06 (RevealNet Formatter v4.4.1) */
CREATE OR REPLACE JAVA SOURCE NAMED "foo" AS
public class Foo {
  public static String hi() {
    System.out.println ("tracing here");
    return "hello there";
  }
}
/
CREATE OR REPLACE FUNCTION foofoo
   RETURN VARCHAR2
AS
   LANGUAGE java
      NAME 'Foo.hi() return java.lang.String';
/
SET serveroutput on
CALL dbms_java.set_output(2000);

-- This will print "tracing here" in SQLPLUS
DECLARE
   x   VARCHAR2 (200);
BEGIN
   x := foofoo;
   p.l (x);
END;
/

SELECT foofoo
  FROM DUAL;


