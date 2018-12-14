CREATE OR REPLACE PROCEDURE lotsa_code
IS
   CURSOR cur 
   IS
      SELECT * FROM emp;

BEGIN
   FOR rec IN cur
   LOOP
      p.l (rec.ename);
   END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE lotsa_code
IS
   CURSOR cur 
   IS
      SELECT * FROM emp;

   PROCEDURE encap
   IS
   BEGIN
      p.l (rec.ename);
   END;
BEGIN
   FOR rec IN cur
   LOOP
      encap;
   END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE lotsa_code
IS
   CURSOR cur 
   IS
      SELECT * FROM emp;

   rec cur%ROWTYPE;

   PROCEDURE encap
   IS
   BEGIN
      p.l (rec.ename);
   END;
BEGIN
   FOR rec IN cur
   LOOP
      encap;
   END LOOP;
END;
/