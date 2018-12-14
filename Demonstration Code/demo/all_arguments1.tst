/* Formatted on 2002/10/11 22:13 (Formatter Plus v4.7.0) */

CREATE OR REPLACE PACKAGE allargs_test
IS 
   PROCEDURE valid_diffnum (arg1 IN DATE, arg2 IN VARCHAR2);
   PROCEDURE valid_diffnum (arg1 IN DATE);

   PROCEDURE namednot (arg1 IN DATE);
   PROCEDURE namednot (arg2 IN DATE);

   PROCEDURE samefamily1 (arg IN NUMBER);
   PROCEDURE samefamily1 (arg IN INTEGER);

   PROCEDURE noparms1;
   PROCEDURE noparms1 (arg IN VARCHAR2 := NULL);

   PROCEDURE noparms2 (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2 := NULL);
   PROCEDURE noparms2 (
      arg1   IN   VARCHAR2 := NULL,
      arg2   IN   VARCHAR2 := NULL,
      arg3   IN   VARCHAR2 := NULL
   );

   PROCEDURE noparms3 (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2);
   PROCEDURE noparms3 (
      arg1   IN   VARCHAR2,
      arg2   IN   VARCHAR2 := NULL,
      arg3   IN   VARCHAR2 := NULL
   );

   PROCEDURE noparms4 (arg1 IN VARCHAR2);
   PROCEDURE noparms4 (arg1 IN VARCHAR2, arg2 IN VARCHAR2 := NULL);

   PROCEDURE oneargdef (onearg IN VARCHAR2 := NULL);
   PROCEDURE oneargdef (onearg IN CHAR := 'abc');

   PROCEDURE difftype1;
   FUNCTION difftype1 RETURN VARCHAR2;

   PROCEDURE difftype2 (arg IN DATE);
   FUNCTION difftype2 (arg IN DATE) RETURN VARCHAR2;
END allargs_test;
/
