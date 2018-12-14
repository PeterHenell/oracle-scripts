@ssoo
CREATE OR REPLACE FUNCTION my_user RETURN VARCHAR2
IS
BEGIN
   DBMS_LOCK.SLEEP (.01);
   RETURN USER;
END;
/
CREATE OR REPLACE PROCEDURE pass_null (who IN VARCHAR2 := NULL)
IS
   v_who VARCHAR2(30);
BEGIN
   IF who IS NULL
   THEN 
      DBMS_LOCK.SLEEP (.01);
      v_who := USER;
   END IF;
END;
/
CREATE OR REPLACE PROCEDURE pass_user (who IN VARCHAR2 := my_user)
IS
   v_who VARCHAR2(30);
BEGIN
   v_who := v_who;
END;
/
DECLARE
   v_user VARCHAR2(30);
   null_tmr tmr_t := tmr_t.make ('NULL', &&firstparm);
   every_tmr tmr_t := tmr_t.make ('FUNCTION', &&firstparm);
BEGIN
   null_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      pass_null ('abc');
   END LOOP;
   null_tmr.stop;
   
   every_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      pass_user ('abc');
   END LOOP;
   every_tmr.stop;
END;
/
DROP FUNCTION my_user;
DROP PROCEDURE pass_user;
DROP PROCEDURE pass_null;
