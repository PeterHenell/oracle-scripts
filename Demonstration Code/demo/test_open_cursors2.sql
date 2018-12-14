DECLARE
   CURSOR cur
   IS
      SELECT * FROM DUAL;

   PROCEDURE show_isopen
   IS
   BEGIN
      IF cur%ISOPEN
      THEN
         DBMS_OUTPUT.put_line ('opened already');
      ELSE
         OPEN cur;

         DBMS_OUTPUT.put_line ('opened');
      END IF;
   END show_isopen;
BEGIN
   show_isopen;
   show_isopen;
END;
/

DECLARE
   PROCEDURE show_isopen
   IS
      CURSOR cur
      IS
         SELECT * FROM DUAL;
   BEGIN
      IF cur%ISOPEN
      THEN
         DBMS_OUTPUT.put_line ('opened already');
      ELSE
         OPEN cur;

         DBMS_OUTPUT.put_line ('opened');
      END IF;
   END show_isopen;
BEGIN
   show_isopen;
   show_isopen;
END;
/

DECLARE
   cur   SYS_REFCURSOR;

   PROCEDURE show_isopen
   IS
   BEGIN
      IF cur%ISOPEN
      THEN
         DBMS_OUTPUT.put_line ('opened already');
      ELSE
         OPEN cur FOR 'SELECT * FROM sys.DUAL';

         DBMS_OUTPUT.put_line ('opened');
      END IF;
   END show_isopen;
BEGIN
   show_isopen;
   show_isopen;
END;
/

DECLARE
   PROCEDURE show_isopen
   IS
      cur   SYS_REFCURSOR;
   BEGIN
      IF cur%ISOPEN
      THEN
         DBMS_OUTPUT.put_line ('opened already');
      ELSE
         OPEN cur FOR 'SELECT * FROM sys.DUAL';

         DBMS_OUTPUT.put_line ('opened');
      END IF;
   END show_isopen;
BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      show_isopen;
   END LOOP;
END;
/