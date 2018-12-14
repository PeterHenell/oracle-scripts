DECLARE
   l_boolean BOOLEAN := TRUE;
BEGIN
   DBMS_OUTPUT.put_line ( l_boolean );
END;
/

DECLARE
   l_boolean BOOLEAN := TRUE;
BEGIN
   IF l_boolean
   THEN
      DBMS_OUTPUT.put_line ( 'true' );
   ELSE
      DBMS_OUTPUT.put_line ( 'false' );
   END IF;
END;
/

DECLARE
   l_boolean BOOLEAN := TRUE;
BEGIN
   p.l ( l_boolean );
END;
/
