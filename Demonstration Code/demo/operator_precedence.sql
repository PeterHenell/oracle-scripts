DECLARE
   a   BOOLEAN := FALSE;
   b   BOOLEAN := FALSE;
   c   BOOLEAN := TRUE;
   d   BOOLEAN := FALSE;
BEGIN
   IF a OR b OR c AND d
   THEN
      DBMS_OUTPUT.put_line ('true');
   END IF;
END;
/

DECLARE
   a   BOOLEAN := FALSE;
   b   BOOLEAN := FALSE;
   c   BOOLEAN := FALSE;
   d   BOOLEAN := FALSE;
BEGIN
   IF a OR b OR c AND d
   THEN
      DBMS_OUTPUT.put_line ('true');
   END IF;
END;
/

DECLARE
   a   BOOLEAN := FALSE;
   b   BOOLEAN := FALSE;
   c   BOOLEAN := TRUE;
   d   BOOLEAN := TRUE;
BEGIN
   IF a OR b OR c AND d
   THEN
      DBMS_OUTPUT.put_line ('true');
   END IF;
END;
/

DECLARE
   a   BOOLEAN := FALSE;
   b   BOOLEAN := TRUE;
   c   BOOLEAN := FALSE;
   d   BOOLEAN := TRUE;
BEGIN
   IF a OR (b OR c) AND d
   THEN
      DBMS_OUTPUT.put_line ('true');
   END IF;
END;
/