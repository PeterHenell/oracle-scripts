CREATE OR REPLACE PROCEDURE strong_mismatch
IS
   TYPE strong_reftype IS REF CURSOR RETURN emp%ROWTYPE;
   cv strong_reftype;
BEGIN
   OPEN cv FOR SELECT * FROM dept;
EXCEPTION
   WHEN OTHERS
   THEN
      p.l (SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE weak_mismatch1
IS
   TYPE weak_reftype IS REF CURSOR;
   cv weak_reftype;
   rec cv%ROWTYPE;
BEGIN
   OPEN cv FOR SELECT * FROM dept;
   FETCH cv INTO rec;
   p.l (rec.dname);
EXCEPTION
   WHEN OTHERS
   THEN
      p.l (SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE weak_mismatch2
IS
   TYPE weak_reftype IS REF CURSOR;
   cv weak_reftype;
   rec emp%ROWTYPE;
BEGIN
   OPEN cv FOR SELECT * FROM dept;
   FETCH cv INTO rec;
   p.l (rec.ename);
EXCEPTION
   WHEN OTHERS
   THEN
      p.l (SQLERRM);
END;
/
BEGIN
   weak_mismatch2;
END;
/
CREATE OR REPLACE PROCEDURE weak_mismatch2
IS
   TYPE weak_reftype IS REF CURSOR;
   cv weak_reftype;
   rec dept%ROWTYPE;
BEGIN
   OPEN cv FOR SELECT * FROM dept;
   FETCH cv INTO rec;
   p.l (rec.dname);
EXCEPTION
   WHEN OTHERS
   THEN
      p.l (SQLERRM);
END;
/
BEGIN
   weak_mismatch2;
END;
/
