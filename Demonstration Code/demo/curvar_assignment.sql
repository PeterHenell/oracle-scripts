CREATE OR REPLACE PROCEDURE plch_proc1
IS
BEGIN
   NULL;
END;
/

CREATE OR REPLACE PROCEDURE plch_proc2
IS
BEGIN
   NULL;
END;
/

CREATE OR REPLACE PROCEDURE plch_proc3
IS
BEGIN
   NULL;
END;
/

DECLARE
   l_cv1    SYS_REFCURSOR;
   l_cv2    SYS_REFCURSOR;
   l_name   user_objects.object_name%TYPE;
BEGIN
   OPEN l_cv1 FOR
        SELECT object_name
          FROM user_objects
         WHERE object_name LIKE 'PLCH_PROC%'
      ORDER BY object_name;

   FETCH l_cv1 INTO l_name;
   sys.DBMS_OUTPUT.put_line (l_name);

   l_cv2 := l_cv1;

   FETCH l_cv2 INTO l_name;
   sys.DBMS_OUTPUT.put_line (l_name);

   CLOSE l_cv1;

   FETCH l_cv2 INTO l_name;
   sys.DBMS_OUTPUT.put_line (l_name);

   CLOSE l_cv2;

END;
/