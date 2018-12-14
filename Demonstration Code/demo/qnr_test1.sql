CONNECT SCOTT/TIGER

DROP PACKAGE pkg;
DROP SYNONYM ls_pkg;
DROP SYNONYM ls_ls_pkg;
DROP SYNONYM ls_ps_pkg;
DROP PUBLIC SYNONYM ps_pkg;
DROP PUBLIC SYNONYM ps_ps_pkg;
DROP PUBLIC SYNONYM ps_ls_pkg;
DROP PUBLIC SYNONYM qnr_show;

GRANT EXECUTE ON qnr_show TO PUBLIC;
CREATE OR REPLACE PUBLIC SYNONYM qnr_show FOR qnr_show;

CREATE OR REPLACE PACKAGE pkg
IS
   PROCEDURE pkgproc;

   FUNCTION pkgfunc
      RETURN DATE;
END pkg;
/

GRANT EXECUTE ON pkg TO PUBLIC;

CREATE SYNONYM ls_pkg FOR pkg;

CREATE PUBLIC SYNONYM ps_pkg FOR pkg;

CREATE SYNONYM ls_ls_pkg FOR ls_pkg;

CREATE PUBLIC SYNONYM ps_ps_pkg FOR ps_pkg;

CREATE SYNONYM ls_ps_pkg FOR ps_pkg;

CREATE PUBLIC SYNONYM ps_ls_pkg FOR ls_pkg;

SET serveroutput on size 1000000 format wrapped

BEGIN
   qnr_show ('pkg');
   qnr_show ('ls_pkg');
   qnr_show ('ps_pkg');
   qnr_show ('ps_ls_pkg');
   qnr_show ('ps_ps_pkg');
   qnr_show ('ls_ps_pkg');
END;
/

CONNECT DEMO/DEMO

SET serveroutput on size 1000000 format wrapped

BEGIN
   scott.qnr_show ('scott.pkg');
   scott.qnr_show ('ps_pkg');
   scott.qnr_show ('ps_ls_pkg');
   scott.qnr_show ('ps_ps_pkg');
END;
/

CONNECT SCOTT/TIGER

DROP PACKAGE pkg;
DROP SYNONYM ls_pkg;
DROP SYNONYM ls_ls_pkg;
DROP SYNONYM ls_ps_pkg;
DROP PUBLIC SYNONYM ps_pkg;
DROP PUBLIC SYNONYM ps_ps_pkg;