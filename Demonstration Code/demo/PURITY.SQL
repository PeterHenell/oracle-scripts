create or replace PACKAGE comp
IS
   FUNCTION total (empno_in IN INTEGER)
      RETURN NUMBER;

   FUNCTION total (ename_in IN VARCHAR2)
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (total, WNDS);
END comp;
/
create or replace PACKAGE body comp
IS
   FUNCTION total (empno_in IN INTEGER)
      RETURN NUMBER is begin return 100; end;

   FUNCTION total (ename_in IN VARCHAR2)
      RETURN NUMBER is begin return -100; end;
END comp;
/

BEGIN
   p.l (comp.total (4076));
   p.l (comp.total ('steven'));
END;
/

SELECT comp.total ('steven') FROM dual;

SELECT comp.total (100) FROM dual;
