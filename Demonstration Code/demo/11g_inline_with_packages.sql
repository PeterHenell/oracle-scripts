CREATE OR REPLACE PACKAGE with_inlining
IS
   FUNCTION f1 (p NUMBER)
      RETURN PLS_INTEGER;

   PROCEDURE show_inlining;
END;
/

CREATE OR REPLACE PACKAGE BODY with_inlining
IS
   PRAGMA INLINE (f1, 'YES');

   FUNCTION f1 (p NUMBER)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN p * 10;
   END;

   FUNCTION f2 (p BOOLEAN)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN CASE WHEN p THEN 10 ELSE 100 END;
   END;

   FUNCTION f3 (p PLS_INTEGER)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN p * 10;
   END;

   PROCEDURE show_inlining
   IS
   BEGIN
      PRAGMA INLINE (f2, 'YES');
      DBMS_OUTPUT.put_line (f2 (TRUE) + f2 (FALSE));

      PRAGMA INLINE (f3, 'NO');
      DBMS_OUTPUT.put_line (f3 (55));
   END;
END;
/

BEGIN
   with_inlining.show_inlining;
END;
/