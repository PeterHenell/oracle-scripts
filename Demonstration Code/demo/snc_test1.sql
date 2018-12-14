SET serveroutput on size 1000000 format wrapped

CREATE OR REPLACE PROCEDURE proc
IS
BEGIN
   NULL;
END proc;
/

CREATE OR REPLACE FUNCTION func
   RETURN DATE
IS
BEGIN
   RETURN NULL;
END func;
/

CREATE OR REPLACE PACKAGE pkg
IS
   PROCEDURE pkgproc;

   FUNCTION pkgfunc
      RETURN DATE;
END pkg;
/

EXEC snc ('proc', &1);
EXEC snc ('func', &1);
EXEC snc ('pkg', &1);
EXEC snc ('pkg.pkgproc', &1);
EXEC snc ('pkg.pkgfunc', &1);

DROP PROCEDURE proc;
DROP FUNCTION func;
DROP PACKAGE pkg;