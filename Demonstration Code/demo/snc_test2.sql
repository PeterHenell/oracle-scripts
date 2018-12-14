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

CREATE TABLE tab (d DATE);

CREATE OR REPLACE VIEW vu
AS
   SELECT *
     FROM tab;

EXEC snc ('proc');
EXEC snc ('func');
EXEC snc ('pkg');
EXEC snc ('pkg.pkgproc');
EXEC snc ('pkg.pkgfunc');
EXEC snc ('tab');
EXEC snc ('vu');

DROP PROCEDURE proc;
DROP FUNCTION func;
DROP PACKAGE pkg;
DROP TABLE tab;
DROP VIEW vu;